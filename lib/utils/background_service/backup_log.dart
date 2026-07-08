import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:intl/intl.dart';
import 'package:othello/utils/globals.dart';
import 'package:synckit/synckit.dart';

/// A single persisted diagnostic log line emitted by the background backup job.
///
/// Plain [StdObj] (no freezed/codegen) so synckit's [LocalStorage] can
/// (de)serialize it. Unlike [BackupState], every entry is its own record keyed
/// by a unique, time-sortable [id] so entries accumulate (keep-all).
class LogEntry with StdObj {
  const LogEntry({
    required this.id,
    required this.ts,
    required this.level,
    required this.message,
    this.runId,
    this.task,
  });

  /// Unique, time-sortable key: `"<ts>-<uuid>"`.
  @override
  final String id;

  /// [DateTime.millisecondsSinceEpoch] the entry was created.
  final int ts;

  /// One of `info` | `warn` | `error`.
  final String level;
  final String message;

  /// Identifies a single background run (so entries can be grouped).
  final String? runId;

  /// The WorkManager task name that produced the entry.
  final String? task;

  DateTime get time => DateTime.fromMillisecondsSinceEpoch(ts);

  /// `ts` rendered for display, e.g. `Jul 6, 02:40:11`.
  String get formattedDate => DateFormat('MMM d, HH:mm:ss').format(time);

  /// Short, human-friendly slice of [runId] (empty when there's no run id).
  String get formattedRunId {
    final id = runId;
    if (id == null || id.isEmpty) return '';
    return id.length <= 8 ? id : id.substring(0, 8);
  }

  /// Single-line representation used for the copy-to-clipboard dump, e.g.
  /// `Jul 6, 02:40:11 INFO [1a2b3c4d]: Started task`.
  String toFormattedString() {
    final run = formattedRunId.isEmpty ? '' : ' [$formattedRunId]';
    return '$formattedDate ${level.toUpperCase()}$run: $message';
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts,
        'level': level,
        'message': message,
        'runId': runId,
        'task': task,
      };

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
        id: json['id'] as String,
        ts: (json['ts'] as num).toInt(),
        level: json['level'] as String? ?? 'info',
        message: json['message'] as String? ?? '',
        runId: json['runId'] as String?,
        task: json['task'] as String?,
      );
}

/// Singleton logger + Hive-backed (via synckit [LocalStorage]) store for the
/// background backup job.
///
/// Because the WorkManager callback runs in its own isolate, this singleton
/// (and therefore [runId]) is created fresh per run: the first `BackupLog()`
/// access lazily instantiates it, so every entry written during a single run
/// shares the same [runId].
///
/// The [boxName]/[store]/[params] are static and shared so both the writer
/// (the background isolate) and the UI notifier (a `SyncedState`) use the exact
/// same Hive box and (de)serialization.
class BackupLog {
  BackupLog._();

  static final BackupLog _instance = BackupLog._();

  factory BackupLog() => _instance;

  static const boxName = 'backup_logs';
  static const store = LocalStorage<LogEntry>(boxName);
  static final params = StdObjParams<LogEntry>(fromJson: LogEntry.fromJson);

  /// Identifies a single background run; generated once when the singleton is
  /// first created (i.e. on the first log call within an isolate).
  final String runId = Globals.uuid.v4();

  /// The WorkManager task name; set once at the start of a run.
  String? task;

  /// Appends a single entry. Safe to call from the background isolate; opens
  /// the box if it is not already open.
  Future<void> add(String level, String message) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final entry = LogEntry(
      id: '$ts-${Globals.uuid.v4()}',
      ts: ts,
      level: level,
      message: message,
      runId: runId,
      task: task,
    );
    await store.initialize();
    await store.update({entry.id: entry}.lock, params);
  }

  Future<void> info(String message) => add('info', message);

  Future<void> warn(String message) => add('warn', message);

  Future<void> error(String message) => add('error', message);
}

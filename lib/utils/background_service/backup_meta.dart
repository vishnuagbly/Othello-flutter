import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:synckit/synckit.dart';

/// Single persisted record shared between the foreground app and the background
/// WorkManager isolate. Plain [StdObj] (no freezed/codegen) so synckit's
/// [LocalStorage] can (de)serialize it.
class BackupState with StdObj {
  const BackupState({
    this.userId,
    this.lastPushedId = 0,
    this.lastError,
    this.docBytes,
  });

  /// Stored as a single entry under this fixed key.
  static const kId = 'meta';

  final String? userId;

  /// Id of the last event row successfully pushed to Firestore (0 = none yet).
  final int lastPushedId;
  final String? lastError;

  /// Approximate serialized size of the current Firestore document's `data`
  /// field. `null` means it has not been seeded yet, so the next run reads the
  /// document once to initialize it (avoids undercounting a pre-existing doc).
  final int? docBytes;

  @override
  String get id => kId;

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'lastPushedId': lastPushedId,
        'lastError': lastError,
        'docBytes': docBytes,
      };

  factory BackupState.fromJson(Map<String, dynamic> json) => BackupState(
        userId: json['userId'] as String?,
        lastPushedId: (json['lastPushedId'] as num?)?.toInt() ?? 0,
        lastError: json['lastError'] as String?,
        docBytes: (json['docBytes'] as num?)?.toInt(),
      );
}

/// Hive-backed (via synckit [LocalStorage]) store for backup metadata.
///
/// [initialize] must be called once per isolate (foreground in `main`,
/// background in the WorkManager `callbackDispatcher`) before any read/write.
abstract class BackupMeta {
  static const _storage = LocalStorage<BackupState>('usage_backup_meta');
  static final _params =
      StdObjParams<BackupState>(fromJson: BackupState.fromJson);

  static Future<void> initialize() => _storage.initialize();

  static BackupState _read() =>
      _storage.getAll(_params).values.firstOrNull ?? const BackupState();

  static Future<void> _write(BackupState state) =>
      _storage.update({BackupState.kId: state}.lock, _params);

  static String? getUserId() => _read().userId;

  static Future<void> setUserId(String userId) async {
    final state = _read();
    if (state.userId == userId) return;
    await _write(BackupState(
      userId: userId,
      lastPushedId: state.lastPushedId,
      lastError: state.lastError,
      docBytes: state.docBytes,
    ));
  }

  static int getLastPushedId() => _read().lastPushedId;

  static Future<void> setLastError(String? error) async {
    final state = _read();
    await _write(BackupState(
      userId: state.userId,
      lastPushedId: state.lastPushedId,
      lastError: error,
      docBytes: state.docBytes,
    ));
  }

  static int? getDocBytes() => _read().docBytes;

  /// Persists the watermark and current document size together after a
  /// successful push, clearing any previous error.
  static Future<void> setBackupResult({
    required int lastPushedId,
    required int docBytes,
  }) async {
    final state = _read();
    await _write(BackupState(
      userId: state.userId,
      lastPushedId: lastPushedId,
      lastError: null,
      docBytes: docBytes,
    ));
  }
}

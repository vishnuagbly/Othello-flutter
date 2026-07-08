import 'package:othello/utils/background_service/backup_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synckit/synckit.dart';

part 'log_providers.g.dart';

/// Local-only [SyncedState] over the shared `backup_logs` Hive box that the
/// background WorkManager isolate writes to. The network layer is disabled, so
/// this is purely a reactive on-device view of [BackupLog].
@Riverpod(keepAlive: true)
class BackupLogs extends _$BackupLogs with SyncedState<LogEntry> {
  @override
  Dataset<LogEntry> build() => initialize(
        SyncConfig(
          manager: SyncManager<LogEntry>(
            stdObjParams: BackupLog.params,
            storage: BackupLog.store,
            network: const NetworkStorage.disabled(),
          ),
          // Newest first: `ascending: false` (the default) reverses this
          // ascending-by-timestamp comparator.
          sortConfig: SortConfig(
            isSorted: true,
            comparator: (a, b) => a.ts.compareTo(b.ts),
          ),
        ),
      );

  /// Pull entries written by the WorkManager isolate. synckit 0.4.6's
  /// [LocalStorage.reInitialize] closes ONLY this box then reopens it, so the
  /// subsequent [refresh] reads fresh from disk (a plain [refresh] would only
  /// re-read the already-open box and miss the isolate's writes).
  Future<void> reload() async {
    await BackupLog.store.reInitialize();
    await refresh();
  }
}

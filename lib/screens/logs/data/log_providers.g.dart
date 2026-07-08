// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Local-only [SyncedState] over the shared `backup_logs` Hive box that the
/// background WorkManager isolate writes to. The network layer is disabled, so
/// this is purely a reactive on-device view of [BackupLog].

@ProviderFor(BackupLogs)
final backupLogsProvider = BackupLogsProvider._();

/// Local-only [SyncedState] over the shared `backup_logs` Hive box that the
/// background WorkManager isolate writes to. The network layer is disabled, so
/// this is purely a reactive on-device view of [BackupLog].
final class BackupLogsProvider
    extends $NotifierProvider<BackupLogs, Dataset<LogEntry>> {
  /// Local-only [SyncedState] over the shared `backup_logs` Hive box that the
  /// background WorkManager isolate writes to. The network layer is disabled, so
  /// this is purely a reactive on-device view of [BackupLog].
  BackupLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupLogsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupLogsHash();

  @$internal
  @override
  BackupLogs create() => BackupLogs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dataset<LogEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dataset<LogEntry>>(value),
    );
  }
}

String _$backupLogsHash() => r'177a96877e221ec3678ef04ba1f9e7d8e4ad0c40';

/// Local-only [SyncedState] over the shared `backup_logs` Hive box that the
/// background WorkManager isolate writes to. The network layer is disabled, so
/// this is purely a reactive on-device view of [BackupLog].

abstract class _$BackupLogs extends $Notifier<Dataset<LogEntry>> {
  Dataset<LogEntry> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Dataset<LogEntry>, Dataset<LogEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Dataset<LogEntry>, Dataset<LogEntry>>,
              Dataset<LogEntry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

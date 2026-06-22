// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(usageLogs)
final usageLogsProvider = UsageLogsProvider._();

final class UsageLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UsageSnapshot>,
          UsageSnapshot,
          FutureOr<UsageSnapshot>
        >
    with $FutureModifier<UsageSnapshot>, $FutureProvider<UsageSnapshot> {
  UsageLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usageLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usageLogsHash();

  @$internal
  @override
  $FutureProviderElement<UsageSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UsageSnapshot> create(Ref ref) {
    return usageLogs(ref);
  }
}

String _$usageLogsHash() => r'2fdc24ed0fb09de63e849f09202464f67e65cac7';

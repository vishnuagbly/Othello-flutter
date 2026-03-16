// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomData)
final roomDataProvider = RoomDataFamily._();

final class RoomDataProvider
    extends $NotifierProvider<RoomData, models.RoomData> {
  RoomDataProvider._({
    required RoomDataFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomDataProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomDataHash();

  @override
  String toString() {
    return r'roomDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RoomData create() => RoomData();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(models.RoomData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<models.RoomData>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoomDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomDataHash() => r'3f7f25d9fddb56210b149d248583fb934adf8b40';

final class RoomDataFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomData,
          models.RoomData,
          models.RoomData,
          models.RoomData,
          String
        > {
  RoomDataFamily._()
    : super(
        retry: null,
        name: r'roomDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RoomDataProvider call(String id) =>
      RoomDataProvider._(argument: id, from: this);

  @override
  String toString() => r'roomDataProvider';
}

abstract class _$RoomData extends $Notifier<models.RoomData> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  models.RoomData build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<models.RoomData, models.RoomData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<models.RoomData, models.RoomData>,
              models.RoomData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

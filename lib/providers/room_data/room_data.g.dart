// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomDatas)
final roomDatasProvider = RoomDatasProvider._();

final class RoomDatasProvider
    extends $NotifierProvider<RoomDatas, Dataset<RoomData>> {
  RoomDatasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomDatasProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomDatasHash();

  @$internal
  @override
  RoomDatas create() => RoomDatas();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dataset<RoomData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dataset<RoomData>>(value),
    );
  }
}

String _$roomDatasHash() => r'a21b9c234e724e66513135c7163cc04c77f81d75';

abstract class _$RoomDatas extends $Notifier<Dataset<RoomData>> {
  Dataset<RoomData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Dataset<RoomData>, Dataset<RoomData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Dataset<RoomData>, Dataset<RoomData>>,
              Dataset<RoomData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(roomsByType)
final roomsByTypeProvider = RoomsByTypeFamily._();

final class RoomsByTypeProvider
    extends $FunctionalProvider<List<RoomData>, List<RoomData>, List<RoomData>>
    with $Provider<List<RoomData>> {
  RoomsByTypeProvider._({
    required RoomsByTypeFamily super.from,
    required RoomType super.argument,
  }) : super(
         retry: null,
         name: r'roomsByTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomsByTypeHash();

  @override
  String toString() {
    return r'roomsByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<RoomData>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<RoomData> create(Ref ref) {
    final argument = this.argument as RoomType;
    return roomsByType(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RoomData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RoomData>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoomsByTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomsByTypeHash() => r'91191dec0da5d1d033da4b7b5f517020744a18b5';

final class RoomsByTypeFamily extends $Family
    with $FunctionalFamilyOverride<List<RoomData>, RoomType> {
  RoomsByTypeFamily._()
    : super(
        retry: null,
        name: r'roomsByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomsByTypeProvider call(RoomType type) =>
      RoomsByTypeProvider._(argument: type, from: this);

  @override
  String toString() => r'roomsByTypeProvider';
}

@ProviderFor(roomExists)
final roomExistsProvider = RoomExistsFamily._();

final class RoomExistsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  RoomExistsProvider._({
    required RoomExistsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomExistsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomExistsHash();

  @override
  String toString() {
    return r'roomExistsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return roomExists(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoomExistsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomExistsHash() => r'4503e8664a007160a6534acedfb8b2fce4698013';

final class RoomExistsFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  RoomExistsFamily._()
    : super(
        retry: null,
        name: r'roomExistsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomExistsProvider call(String id) =>
      RoomExistsProvider._(argument: id, from: this);

  @override
  String toString() => r'roomExistsProvider';
}

@ProviderFor(roomData)
final roomDataProvider = RoomDataFamily._();

final class RoomDataProvider
    extends $FunctionalProvider<RoomData, RoomData, RoomData>
    with $Provider<RoomData> {
  RoomDataProvider._({
    required RoomDataFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomDataProvider',
         isAutoDispose: true,
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
  $ProviderElement<RoomData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoomData create(Ref ref) {
    final argument = this.argument as String;
    return roomData(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomData>(value),
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

String _$roomDataHash() => r'481b393cb925e23c97555883062ba0a45edb42f6';

final class RoomDataFamily extends $Family
    with $FunctionalFamilyOverride<RoomData, String> {
  RoomDataFamily._()
    : super(
        retry: null,
        name: r'roomDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomDataProvider call(String id) =>
      RoomDataProvider._(argument: id, from: this);

  @override
  String toString() => r'roomDataProvider';
}

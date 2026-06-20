// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_data_db.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomDataDb)
final roomDataDbProvider = RoomDataDbProvider._();

final class RoomDataDbProvider
    extends $NotifierProvider<RoomDataDb, Dataset<RoomData>> {
  RoomDataDbProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomDataDbProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomDataDbHash();

  @$internal
  @override
  RoomDataDb create() => RoomDataDb();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dataset<RoomData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dataset<RoomData>>(value),
    );
  }
}

String _$roomDataDbHash() => r'e288c45ecf917b2fbff61fb96389fedbfec9596d';

abstract class _$RoomDataDb extends $Notifier<Dataset<RoomData>> {
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

String _$roomsByTypeHash() => r'87a81fc02beca3a0d1e45000b9acd6df2edbbae3';

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

String _$roomExistsHash() => r'f8b6cfb94c3a7bf7498a253799dc7eaff0579c29';

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

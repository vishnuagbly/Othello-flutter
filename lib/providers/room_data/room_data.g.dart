// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomData)
final roomDataProvider = RoomDataFamily._();

final class RoomDataProvider extends $NotifierProvider<RoomData, o.RoomData> {
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
  RoomData create() => RoomData();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(o.RoomData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<o.RoomData>(value),
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

String _$roomDataHash() => r'e6da9c7101c52db2e2c0594554227d586f6aa927';

final class RoomDataFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomData,
          o.RoomData,
          o.RoomData,
          o.RoomData,
          String
        > {
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

abstract class _$RoomData extends $Notifier<o.RoomData> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  o.RoomData build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<o.RoomData, o.RoomData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<o.RoomData, o.RoomData>,
              o.RoomData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(roomsByType)
final roomsByTypeProvider = RoomsByTypeFamily._();

final class RoomsByTypeProvider
    extends
        $FunctionalProvider<
          List<o.RoomData>,
          List<o.RoomData>,
          List<o.RoomData>
        >
    with $Provider<List<o.RoomData>> {
  RoomsByTypeProvider._({
    required RoomsByTypeFamily super.from,
    required o.RoomType super.argument,
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
  $ProviderElement<List<o.RoomData>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<o.RoomData> create(Ref ref) {
    final argument = this.argument as o.RoomType;
    return roomsByType(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<o.RoomData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<o.RoomData>>(value),
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

String _$roomsByTypeHash() => r'74cef2fc29eeade8f900571344e12bc6632e5504';

final class RoomsByTypeFamily extends $Family
    with $FunctionalFamilyOverride<List<o.RoomData>, o.RoomType> {
  RoomsByTypeFamily._()
    : super(
        retry: null,
        name: r'roomsByTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomsByTypeProvider call(o.RoomType type) =>
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

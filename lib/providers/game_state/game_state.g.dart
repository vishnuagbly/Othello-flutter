// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameState)
final gameStateProvider = GameStateFamily._();

final class GameStateProvider
    extends $NotifierProvider<GameState, gso.GameState> {
  GameStateProvider._({
    required GameStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gameStateProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameStateHash();

  @override
  String toString() {
    return r'gameStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GameState create() => GameState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(gso.GameState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<gso.GameState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameStateHash() => r'f1fe666d51b2a87ae70482a5414498443883dfff';

final class GameStateFamily extends $Family
    with
        $ClassFamilyOverride<
          GameState,
          gso.GameState,
          gso.GameState,
          gso.GameState,
          String
        > {
  GameStateFamily._()
    : super(
        retry: null,
        name: r'gameStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GameStateProvider call(String id) =>
      GameStateProvider._(argument: id, from: this);

  @override
  String toString() => r'gameStateProvider';
}

abstract class _$GameState extends $Notifier<gso.GameState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  gso.GameState build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<gso.GameState, gso.GameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<gso.GameState, gso.GameState>,
              gso.GameState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoogleSignInNotifier)
final googleSignInProvider = GoogleSignInNotifierProvider._();

final class GoogleSignInNotifierProvider
    extends $NotifierProvider<GoogleSignInNotifier, bool> {
  GoogleSignInNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInNotifierHash();

  @$internal
  @override
  GoogleSignInNotifier create() => GoogleSignInNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$googleSignInNotifierHash() =>
    r'2553b38d01e64cb52ebd507aef1bd5cd163194f1';

abstract class _$GoogleSignInNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

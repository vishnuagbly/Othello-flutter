// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Users)
final usersProvider = UsersProvider._();

final class UsersProvider extends $NotifierProvider<Users, Dataset<User>> {
  UsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersHash();

  @$internal
  @override
  Users create() => Users();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dataset<User> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dataset<User>>(value),
    );
  }
}

String _$usersHash() => r'b006f7d2e7b66133a12b5c674e700cb6ee29a252';

abstract class _$Users extends $Notifier<Dataset<User>> {
  Dataset<User> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Dataset<User>, Dataset<User>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Dataset<User>, Dataset<User>>,
              Dataset<User>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(isLoggedIn)
final isLoggedInProvider = IsLoggedInProvider._();

final class IsLoggedInProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsLoggedInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLoggedInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLoggedInHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isLoggedIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLoggedInHash() => r'74273923642fe34dd32918f7f0c4348d501099f2';

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider extends $FunctionalProvider<User, User, User>
    with $Provider<User> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<User> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User>(value),
    );
  }
}

String _$currentUserHash() => r'c4540679d146d5dff7c01597759896065f9fd314';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/people/v1.dart' as people;
import 'package:othello/objects/user/user.dart';
import 'package:othello/utils/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synckit/synckit.dart';

part 'users.g.dart';

@Riverpod(keepAlive: true)
class Users extends _$Users with SyncedState<User> {
  static const kUsersKey = 'users';

  @override
  Dataset<User> build() {
    return initialize(
      SyncConfig(
        manager: SyncManager<User>(
          stdObjParams: StdObjParams<User>(fromJson: User.fromJson),
          storage: const LocalStorage(kUsersKey),
          network: const NetworkStorage(
            kUsersKey,
            collectionBased: true,
            collectionBasedConfig: NetworkStorageCollectionBasedConfig(
              getAllEnabled: false,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(people.Person person) async {
    final email = person.emailAddresses!.first.value!;
    final users = await getQueryFromNetwork(
      (query) => query.where('email', isEqualTo: email),
    );
    if (users.isEmpty) {
      return _addUser(person);
    } else if (users.length > 1) {
      throw Exception('Multiple users found with email $email');
    }
  }

  Future<void> _addUser(people.Person person) {
    final newUser = User.create(
      email: person.emailAddresses!.first.value!,
      name: person.names!.first.displayName!,
      profileImgUrl: person.photos?.firstOrNull?.url,
    );
    return update(newUser);
  }

  Future<void> logout() async {
    await Future.wait([clear(), kGoogleSignIn.signOut()]);
  }
}

@riverpod
bool isLoggedIn(Ref ref) {
  return ref.watch(usersProvider.select((users) => users.isNotEmpty));
}

@riverpod
User currentUser(Ref ref) {
  if (!ref.watch(isLoggedInProvider)) {
    throw Exception('No user is currently logged in');
  }
  return ref.watch(usersProvider).values.first;
}

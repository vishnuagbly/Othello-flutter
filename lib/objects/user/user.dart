import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synckit/synckit.dart';
import 'package:othello/utils/globals.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User implements StdObj {
  const User._();

  factory User.create({
    String? id,
    required String name,
    required String email,
    String? profileImgUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now();
    return User(
      id: id ?? Globals.uuid.v1(),
      name: name,
      email: email,
      profileImgUrl: profileImgUrl,
      createdAt: createdAt ?? updatedAt ?? now,
      updatedAt: updatedAt ?? createdAt ?? now,
    );
  }

  const factory User({
    required String id,
    required String name,
    required String email,
    String? profileImgUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'piece_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PieceState {

 int get value; bool get possibleMove;
/// Create a copy of PieceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PieceStateCopyWith<PieceState> get copyWith => _$PieceStateCopyWithImpl<PieceState>(this as PieceState, _$identity);

  /// Serializes this PieceState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PieceState&&(identical(other.value, value) || other.value == value)&&(identical(other.possibleMove, possibleMove) || other.possibleMove == possibleMove));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,possibleMove);

@override
String toString() {
  return 'PieceState(value: $value, possibleMove: $possibleMove)';
}


}

/// @nodoc
abstract mixin class $PieceStateCopyWith<$Res>  {
  factory $PieceStateCopyWith(PieceState value, $Res Function(PieceState) _then) = _$PieceStateCopyWithImpl;
@useResult
$Res call({
 int value, bool possibleMove
});




}
/// @nodoc
class _$PieceStateCopyWithImpl<$Res>
    implements $PieceStateCopyWith<$Res> {
  _$PieceStateCopyWithImpl(this._self, this._then);

  final PieceState _self;
  final $Res Function(PieceState) _then;

/// Create a copy of PieceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? possibleMove = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,possibleMove: null == possibleMove ? _self.possibleMove : possibleMove // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PieceState].
extension PieceStatePatterns on PieceState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PieceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PieceState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PieceState value)  $default,){
final _that = this;
switch (_that) {
case _PieceState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PieceState value)?  $default,){
final _that = this;
switch (_that) {
case _PieceState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int value,  bool possibleMove)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PieceState() when $default != null:
return $default(_that.value,_that.possibleMove);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int value,  bool possibleMove)  $default,) {final _that = this;
switch (_that) {
case _PieceState():
return $default(_that.value,_that.possibleMove);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int value,  bool possibleMove)?  $default,) {final _that = this;
switch (_that) {
case _PieceState() when $default != null:
return $default(_that.value,_that.possibleMove);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PieceState extends PieceState {
  const _PieceState({required this.value, this.possibleMove = false}): super._();
  factory _PieceState.fromJson(Map<String, dynamic> json) => _$PieceStateFromJson(json);

@override final  int value;
@override@JsonKey() final  bool possibleMove;

/// Create a copy of PieceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PieceStateCopyWith<_PieceState> get copyWith => __$PieceStateCopyWithImpl<_PieceState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PieceStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PieceState&&(identical(other.value, value) || other.value == value)&&(identical(other.possibleMove, possibleMove) || other.possibleMove == possibleMove));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,possibleMove);

@override
String toString() {
  return 'PieceState(value: $value, possibleMove: $possibleMove)';
}


}

/// @nodoc
abstract mixin class _$PieceStateCopyWith<$Res> implements $PieceStateCopyWith<$Res> {
  factory _$PieceStateCopyWith(_PieceState value, $Res Function(_PieceState) _then) = __$PieceStateCopyWithImpl;
@override @useResult
$Res call({
 int value, bool possibleMove
});




}
/// @nodoc
class __$PieceStateCopyWithImpl<$Res>
    implements _$PieceStateCopyWith<$Res> {
  __$PieceStateCopyWithImpl(this._self, this._then);

  final _PieceState _self;
  final $Res Function(_PieceState) _then;

/// Create a copy of PieceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? possibleMove = null,}) {
  return _then(_PieceState(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,possibleMove: null == possibleMove ? _self.possibleMove : possibleMove // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

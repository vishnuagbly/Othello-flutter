// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flip_piece_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlipPieceState {

 bool get flipping;
/// Create a copy of FlipPieceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlipPieceStateCopyWith<FlipPieceState> get copyWith => _$FlipPieceStateCopyWithImpl<FlipPieceState>(this as FlipPieceState, _$identity);

  /// Serializes this FlipPieceState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlipPieceState&&(identical(other.flipping, flipping) || other.flipping == flipping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,flipping);

@override
String toString() {
  return 'FlipPieceState(flipping: $flipping)';
}


}

/// @nodoc
abstract mixin class $FlipPieceStateCopyWith<$Res>  {
  factory $FlipPieceStateCopyWith(FlipPieceState value, $Res Function(FlipPieceState) _then) = _$FlipPieceStateCopyWithImpl;
@useResult
$Res call({
 bool flipping
});




}
/// @nodoc
class _$FlipPieceStateCopyWithImpl<$Res>
    implements $FlipPieceStateCopyWith<$Res> {
  _$FlipPieceStateCopyWithImpl(this._self, this._then);

  final FlipPieceState _self;
  final $Res Function(FlipPieceState) _then;

/// Create a copy of FlipPieceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flipping = null,}) {
  return _then(_self.copyWith(
flipping: null == flipping ? _self.flipping : flipping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FlipPieceState].
extension FlipPieceStatePatterns on FlipPieceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlipPieceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlipPieceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlipPieceState value)  $default,){
final _that = this;
switch (_that) {
case _FlipPieceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlipPieceState value)?  $default,){
final _that = this;
switch (_that) {
case _FlipPieceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool flipping)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlipPieceState() when $default != null:
return $default(_that.flipping);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool flipping)  $default,) {final _that = this;
switch (_that) {
case _FlipPieceState():
return $default(_that.flipping);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool flipping)?  $default,) {final _that = this;
switch (_that) {
case _FlipPieceState() when $default != null:
return $default(_that.flipping);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlipPieceState extends FlipPieceState {
  const _FlipPieceState({this.flipping = false}): super._();
  factory _FlipPieceState.fromJson(Map<String, dynamic> json) => _$FlipPieceStateFromJson(json);

@override@JsonKey() final  bool flipping;

/// Create a copy of FlipPieceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlipPieceStateCopyWith<_FlipPieceState> get copyWith => __$FlipPieceStateCopyWithImpl<_FlipPieceState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlipPieceStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlipPieceState&&(identical(other.flipping, flipping) || other.flipping == flipping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,flipping);

@override
String toString() {
  return 'FlipPieceState(flipping: $flipping)';
}


}

/// @nodoc
abstract mixin class _$FlipPieceStateCopyWith<$Res> implements $FlipPieceStateCopyWith<$Res> {
  factory _$FlipPieceStateCopyWith(_FlipPieceState value, $Res Function(_FlipPieceState) _then) = __$FlipPieceStateCopyWithImpl;
@override @useResult
$Res call({
 bool flipping
});




}
/// @nodoc
class __$FlipPieceStateCopyWithImpl<$Res>
    implements _$FlipPieceStateCopyWith<$Res> {
  __$FlipPieceStateCopyWithImpl(this._self, this._then);

  final _FlipPieceState _self;
  final $Res Function(_FlipPieceState) _then;

/// Create a copy of FlipPieceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flipping = null,}) {
  return _then(_FlipPieceState(
flipping: null == flipping ? _self.flipping : flipping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

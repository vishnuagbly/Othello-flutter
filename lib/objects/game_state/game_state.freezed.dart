// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState {

 RoomData get roomData; double get boardWidth; double get cellWidth; IList<IList<FlipPieceState>> get flipPieceStates; IList<IList<PieceState>> get pieceStates; bool get autoReset;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.roomData, roomData) || other.roomData == roomData)&&(identical(other.boardWidth, boardWidth) || other.boardWidth == boardWidth)&&(identical(other.cellWidth, cellWidth) || other.cellWidth == cellWidth)&&const DeepCollectionEquality().equals(other.flipPieceStates, flipPieceStates)&&const DeepCollectionEquality().equals(other.pieceStates, pieceStates)&&(identical(other.autoReset, autoReset) || other.autoReset == autoReset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomData,boardWidth,cellWidth,const DeepCollectionEquality().hash(flipPieceStates),const DeepCollectionEquality().hash(pieceStates),autoReset);

@override
String toString() {
  return 'GameState(roomData: $roomData, boardWidth: $boardWidth, cellWidth: $cellWidth, flipPieceStates: $flipPieceStates, pieceStates: $pieceStates, autoReset: $autoReset)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 RoomData roomData, double boardWidth, double cellWidth, IList<IList<FlipPieceState>> flipPieceStates, IList<IList<PieceState>> pieceStates, bool autoReset
});


$RoomDataCopyWith<$Res> get roomData;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomData = null,Object? boardWidth = null,Object? cellWidth = null,Object? flipPieceStates = null,Object? pieceStates = null,Object? autoReset = null,}) {
  return _then(_self.copyWith(
roomData: null == roomData ? _self.roomData : roomData // ignore: cast_nullable_to_non_nullable
as RoomData,boardWidth: null == boardWidth ? _self.boardWidth : boardWidth // ignore: cast_nullable_to_non_nullable
as double,cellWidth: null == cellWidth ? _self.cellWidth : cellWidth // ignore: cast_nullable_to_non_nullable
as double,flipPieceStates: null == flipPieceStates ? _self.flipPieceStates : flipPieceStates // ignore: cast_nullable_to_non_nullable
as IList<IList<FlipPieceState>>,pieceStates: null == pieceStates ? _self.pieceStates : pieceStates // ignore: cast_nullable_to_non_nullable
as IList<IList<PieceState>>,autoReset: null == autoReset ? _self.autoReset : autoReset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomDataCopyWith<$Res> get roomData {
  
  return $RoomDataCopyWith<$Res>(_self.roomData, (value) {
    return _then(_self.copyWith(roomData: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoomData roomData,  double boardWidth,  double cellWidth,  IList<IList<FlipPieceState>> flipPieceStates,  IList<IList<PieceState>> pieceStates,  bool autoReset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.roomData,_that.boardWidth,_that.cellWidth,_that.flipPieceStates,_that.pieceStates,_that.autoReset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoomData roomData,  double boardWidth,  double cellWidth,  IList<IList<FlipPieceState>> flipPieceStates,  IList<IList<PieceState>> pieceStates,  bool autoReset)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.roomData,_that.boardWidth,_that.cellWidth,_that.flipPieceStates,_that.pieceStates,_that.autoReset);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoomData roomData,  double boardWidth,  double cellWidth,  IList<IList<FlipPieceState>> flipPieceStates,  IList<IList<PieceState>> pieceStates,  bool autoReset)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.roomData,_that.boardWidth,_that.cellWidth,_that.flipPieceStates,_that.pieceStates,_that.autoReset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState extends GameState {
  const _GameState({required this.roomData, this.boardWidth = 0.0, this.cellWidth = 0.0, this.flipPieceStates = const IListConst([]), this.pieceStates = const IListConst([]), this.autoReset = false}): super._();
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

@override final  RoomData roomData;
@override@JsonKey() final  double boardWidth;
@override@JsonKey() final  double cellWidth;
@override@JsonKey() final  IList<IList<FlipPieceState>> flipPieceStates;
@override@JsonKey() final  IList<IList<PieceState>> pieceStates;
@override@JsonKey() final  bool autoReset;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.roomData, roomData) || other.roomData == roomData)&&(identical(other.boardWidth, boardWidth) || other.boardWidth == boardWidth)&&(identical(other.cellWidth, cellWidth) || other.cellWidth == cellWidth)&&const DeepCollectionEquality().equals(other.flipPieceStates, flipPieceStates)&&const DeepCollectionEquality().equals(other.pieceStates, pieceStates)&&(identical(other.autoReset, autoReset) || other.autoReset == autoReset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomData,boardWidth,cellWidth,const DeepCollectionEquality().hash(flipPieceStates),const DeepCollectionEquality().hash(pieceStates),autoReset);

@override
String toString() {
  return 'GameState(roomData: $roomData, boardWidth: $boardWidth, cellWidth: $cellWidth, flipPieceStates: $flipPieceStates, pieceStates: $pieceStates, autoReset: $autoReset)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 RoomData roomData, double boardWidth, double cellWidth, IList<IList<FlipPieceState>> flipPieceStates, IList<IList<PieceState>> pieceStates, bool autoReset
});


@override $RoomDataCopyWith<$Res> get roomData;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomData = null,Object? boardWidth = null,Object? cellWidth = null,Object? flipPieceStates = null,Object? pieceStates = null,Object? autoReset = null,}) {
  return _then(_GameState(
roomData: null == roomData ? _self.roomData : roomData // ignore: cast_nullable_to_non_nullable
as RoomData,boardWidth: null == boardWidth ? _self.boardWidth : boardWidth // ignore: cast_nullable_to_non_nullable
as double,cellWidth: null == cellWidth ? _self.cellWidth : cellWidth // ignore: cast_nullable_to_non_nullable
as double,flipPieceStates: null == flipPieceStates ? _self.flipPieceStates : flipPieceStates // ignore: cast_nullable_to_non_nullable
as IList<IList<FlipPieceState>>,pieceStates: null == pieceStates ? _self.pieceStates : pieceStates // ignore: cast_nullable_to_non_nullable
as IList<IList<PieceState>>,autoReset: null == autoReset ? _self.autoReset : autoReset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomDataCopyWith<$Res> get roomData {
  
  return $RoomDataCopyWith<$Res>(_self.roomData, (value) {
    return _then(_self.copyWith(roomData: value));
  });
}
}

// dart format on

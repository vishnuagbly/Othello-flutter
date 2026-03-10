// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'move_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoveData {

@UnmodifiableBoardConverter() List<List<int>> get board;@JsonKey(readValue: _readMoveDataId) String get id;@DurationSecondsConverter() Duration get duration; DateTime get timestamp; String get playerIdTurn;
/// Create a copy of MoveData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveDataCopyWith<MoveData> get copyWith => _$MoveDataCopyWithImpl<MoveData>(this as MoveData, _$identity);

  /// Serializes this MoveData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveData&&const DeepCollectionEquality().equals(other.board, board)&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.playerIdTurn, playerIdTurn) || other.playerIdTurn == playerIdTurn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(board),id,duration,timestamp,playerIdTurn);

@override
String toString() {
  return 'MoveData(board: $board, id: $id, duration: $duration, timestamp: $timestamp, playerIdTurn: $playerIdTurn)';
}


}

/// @nodoc
abstract mixin class $MoveDataCopyWith<$Res>  {
  factory $MoveDataCopyWith(MoveData value, $Res Function(MoveData) _then) = _$MoveDataCopyWithImpl;
@useResult
$Res call({
@UnmodifiableBoardConverter() List<List<int>> board,@JsonKey(readValue: _readMoveDataId) String id,@DurationSecondsConverter() Duration duration, DateTime timestamp, String playerIdTurn
});




}
/// @nodoc
class _$MoveDataCopyWithImpl<$Res>
    implements $MoveDataCopyWith<$Res> {
  _$MoveDataCopyWithImpl(this._self, this._then);

  final MoveData _self;
  final $Res Function(MoveData) _then;

/// Create a copy of MoveData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? id = null,Object? duration = null,Object? timestamp = null,Object? playerIdTurn = null,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as List<List<int>>,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,playerIdTurn: null == playerIdTurn ? _self.playerIdTurn : playerIdTurn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveData].
extension MoveDataPatterns on MoveData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveData value)  $default,){
final _that = this;
switch (_that) {
case _MoveData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveData value)?  $default,){
final _that = this;
switch (_that) {
case _MoveData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@UnmodifiableBoardConverter()  List<List<int>> board, @JsonKey(readValue: _readMoveDataId)  String id, @DurationSecondsConverter()  Duration duration,  DateTime timestamp,  String playerIdTurn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveData() when $default != null:
return $default(_that.board,_that.id,_that.duration,_that.timestamp,_that.playerIdTurn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@UnmodifiableBoardConverter()  List<List<int>> board, @JsonKey(readValue: _readMoveDataId)  String id, @DurationSecondsConverter()  Duration duration,  DateTime timestamp,  String playerIdTurn)  $default,) {final _that = this;
switch (_that) {
case _MoveData():
return $default(_that.board,_that.id,_that.duration,_that.timestamp,_that.playerIdTurn);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@UnmodifiableBoardConverter()  List<List<int>> board, @JsonKey(readValue: _readMoveDataId)  String id, @DurationSecondsConverter()  Duration duration,  DateTime timestamp,  String playerIdTurn)?  $default,) {final _that = this;
switch (_that) {
case _MoveData() when $default != null:
return $default(_that.board,_that.id,_that.duration,_that.timestamp,_that.playerIdTurn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoveData extends MoveData {
  const _MoveData({@UnmodifiableBoardConverter() required final  List<List<int>> board, @JsonKey(readValue: _readMoveDataId) required this.id, @DurationSecondsConverter() required this.duration, required this.timestamp, required this.playerIdTurn}): _board = board,super._();
  factory _MoveData.fromJson(Map<String, dynamic> json) => _$MoveDataFromJson(json);

 final  List<List<int>> _board;
@override@UnmodifiableBoardConverter() List<List<int>> get board {
  if (_board is EqualUnmodifiableListView) return _board;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_board);
}

@override@JsonKey(readValue: _readMoveDataId) final  String id;
@override@DurationSecondsConverter() final  Duration duration;
@override final  DateTime timestamp;
@override final  String playerIdTurn;

/// Create a copy of MoveData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveDataCopyWith<_MoveData> get copyWith => __$MoveDataCopyWithImpl<_MoveData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveData&&const DeepCollectionEquality().equals(other._board, _board)&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.playerIdTurn, playerIdTurn) || other.playerIdTurn == playerIdTurn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_board),id,duration,timestamp,playerIdTurn);

@override
String toString() {
  return 'MoveData(board: $board, id: $id, duration: $duration, timestamp: $timestamp, playerIdTurn: $playerIdTurn)';
}


}

/// @nodoc
abstract mixin class _$MoveDataCopyWith<$Res> implements $MoveDataCopyWith<$Res> {
  factory _$MoveDataCopyWith(_MoveData value, $Res Function(_MoveData) _then) = __$MoveDataCopyWithImpl;
@override @useResult
$Res call({
@UnmodifiableBoardConverter() List<List<int>> board,@JsonKey(readValue: _readMoveDataId) String id,@DurationSecondsConverter() Duration duration, DateTime timestamp, String playerIdTurn
});




}
/// @nodoc
class __$MoveDataCopyWithImpl<$Res>
    implements _$MoveDataCopyWith<$Res> {
  __$MoveDataCopyWithImpl(this._self, this._then);

  final _MoveData _self;
  final $Res Function(_MoveData) _then;

/// Create a copy of MoveData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? id = null,Object? duration = null,Object? timestamp = null,Object? playerIdTurn = null,}) {
  return _then(_MoveData(
board: null == board ? _self._board : board // ignore: cast_nullable_to_non_nullable
as List<List<int>>,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,playerIdTurn: null == playerIdTurn ? _self.playerIdTurn : playerIdTurn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

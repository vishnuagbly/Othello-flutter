// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomData {

@JsonKey(name: RoomDataLabels.roomId) String get id;@JsonKey(name: RoomDataLabels.roomType) RoomType get roomType;@JsonKey(name: RoomDataLabels.blackPlayer) Player get blackPlayer;@JsonKey(name: RoomDataLabels.whitePlayer) Player get whitePlayer;@JsonKey(name: RoomDataLabels.length) int get length;@JsonKey(name: RoomDataLabels.height) int get height;@JsonKey(name: RoomDataLabels.playerIdTurn) String get playerIdTurn;@JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter() IList<IList<int>> get currentBoard;@JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter() IList<MoveData> get lastMoves;@JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter() Duration get blackTotalDuration;@JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter() Duration get whiteTotalDuration;@JsonKey(name: RoomDataLabels.timestamp) DateTime get timestamp;
/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomDataCopyWith<RoomData> get copyWith => _$RoomDataCopyWithImpl<RoomData>(this as RoomData, _$identity);

  /// Serializes this RoomData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomData&&(identical(other.id, id) || other.id == id)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.blackPlayer, blackPlayer) || other.blackPlayer == blackPlayer)&&(identical(other.whitePlayer, whitePlayer) || other.whitePlayer == whitePlayer)&&(identical(other.length, length) || other.length == length)&&(identical(other.height, height) || other.height == height)&&(identical(other.playerIdTurn, playerIdTurn) || other.playerIdTurn == playerIdTurn)&&const DeepCollectionEquality().equals(other.currentBoard, currentBoard)&&const DeepCollectionEquality().equals(other.lastMoves, lastMoves)&&(identical(other.blackTotalDuration, blackTotalDuration) || other.blackTotalDuration == blackTotalDuration)&&(identical(other.whiteTotalDuration, whiteTotalDuration) || other.whiteTotalDuration == whiteTotalDuration)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomType,blackPlayer,whitePlayer,length,height,playerIdTurn,const DeepCollectionEquality().hash(currentBoard),const DeepCollectionEquality().hash(lastMoves),blackTotalDuration,whiteTotalDuration,timestamp);

@override
String toString() {
  return 'RoomData(id: $id, roomType: $roomType, blackPlayer: $blackPlayer, whitePlayer: $whitePlayer, length: $length, height: $height, playerIdTurn: $playerIdTurn, currentBoard: $currentBoard, lastMoves: $lastMoves, blackTotalDuration: $blackTotalDuration, whiteTotalDuration: $whiteTotalDuration, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $RoomDataCopyWith<$Res>  {
  factory $RoomDataCopyWith(RoomData value, $Res Function(RoomData) _then) = _$RoomDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: RoomDataLabels.roomId) String id,@JsonKey(name: RoomDataLabels.roomType) RoomType roomType,@JsonKey(name: RoomDataLabels.blackPlayer) Player blackPlayer,@JsonKey(name: RoomDataLabels.whitePlayer) Player whitePlayer,@JsonKey(name: RoomDataLabels.length) int length,@JsonKey(name: RoomDataLabels.height) int height,@JsonKey(name: RoomDataLabels.playerIdTurn) String playerIdTurn,@JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter() IList<IList<int>> currentBoard,@JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter() IList<MoveData> lastMoves,@JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter() Duration blackTotalDuration,@JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter() Duration whiteTotalDuration,@JsonKey(name: RoomDataLabels.timestamp) DateTime timestamp
});


$PlayerCopyWith<$Res> get blackPlayer;$PlayerCopyWith<$Res> get whitePlayer;

}
/// @nodoc
class _$RoomDataCopyWithImpl<$Res>
    implements $RoomDataCopyWith<$Res> {
  _$RoomDataCopyWithImpl(this._self, this._then);

  final RoomData _self;
  final $Res Function(RoomData) _then;

/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomType = null,Object? blackPlayer = null,Object? whitePlayer = null,Object? length = null,Object? height = null,Object? playerIdTurn = null,Object? currentBoard = null,Object? lastMoves = null,Object? blackTotalDuration = null,Object? whiteTotalDuration = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as RoomType,blackPlayer: null == blackPlayer ? _self.blackPlayer : blackPlayer // ignore: cast_nullable_to_non_nullable
as Player,whitePlayer: null == whitePlayer ? _self.whitePlayer : whitePlayer // ignore: cast_nullable_to_non_nullable
as Player,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,playerIdTurn: null == playerIdTurn ? _self.playerIdTurn : playerIdTurn // ignore: cast_nullable_to_non_nullable
as String,currentBoard: null == currentBoard ? _self.currentBoard : currentBoard // ignore: cast_nullable_to_non_nullable
as IList<IList<int>>,lastMoves: null == lastMoves ? _self.lastMoves : lastMoves // ignore: cast_nullable_to_non_nullable
as IList<MoveData>,blackTotalDuration: null == blackTotalDuration ? _self.blackTotalDuration : blackTotalDuration // ignore: cast_nullable_to_non_nullable
as Duration,whiteTotalDuration: null == whiteTotalDuration ? _self.whiteTotalDuration : whiteTotalDuration // ignore: cast_nullable_to_non_nullable
as Duration,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get blackPlayer {
  
  return $PlayerCopyWith<$Res>(_self.blackPlayer, (value) {
    return _then(_self.copyWith(blackPlayer: value));
  });
}/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get whitePlayer {
  
  return $PlayerCopyWith<$Res>(_self.whitePlayer, (value) {
    return _then(_self.copyWith(whitePlayer: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomData].
extension RoomDataPatterns on RoomData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomData value)  $default,){
final _that = this;
switch (_that) {
case _RoomData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomData value)?  $default,){
final _that = this;
switch (_that) {
case _RoomData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: RoomDataLabels.roomId)  String id, @JsonKey(name: RoomDataLabels.roomType)  RoomType roomType, @JsonKey(name: RoomDataLabels.blackPlayer)  Player blackPlayer, @JsonKey(name: RoomDataLabels.whitePlayer)  Player whitePlayer, @JsonKey(name: RoomDataLabels.length)  int length, @JsonKey(name: RoomDataLabels.height)  int height, @JsonKey(name: RoomDataLabels.playerIdTurn)  String playerIdTurn, @JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter()  IList<IList<int>> currentBoard, @JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter()  IList<MoveData> lastMoves, @JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter()  Duration blackTotalDuration, @JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter()  Duration whiteTotalDuration, @JsonKey(name: RoomDataLabels.timestamp)  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomData() when $default != null:
return $default(_that.id,_that.roomType,_that.blackPlayer,_that.whitePlayer,_that.length,_that.height,_that.playerIdTurn,_that.currentBoard,_that.lastMoves,_that.blackTotalDuration,_that.whiteTotalDuration,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: RoomDataLabels.roomId)  String id, @JsonKey(name: RoomDataLabels.roomType)  RoomType roomType, @JsonKey(name: RoomDataLabels.blackPlayer)  Player blackPlayer, @JsonKey(name: RoomDataLabels.whitePlayer)  Player whitePlayer, @JsonKey(name: RoomDataLabels.length)  int length, @JsonKey(name: RoomDataLabels.height)  int height, @JsonKey(name: RoomDataLabels.playerIdTurn)  String playerIdTurn, @JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter()  IList<IList<int>> currentBoard, @JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter()  IList<MoveData> lastMoves, @JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter()  Duration blackTotalDuration, @JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter()  Duration whiteTotalDuration, @JsonKey(name: RoomDataLabels.timestamp)  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _RoomData():
return $default(_that.id,_that.roomType,_that.blackPlayer,_that.whitePlayer,_that.length,_that.height,_that.playerIdTurn,_that.currentBoard,_that.lastMoves,_that.blackTotalDuration,_that.whiteTotalDuration,_that.timestamp);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: RoomDataLabels.roomId)  String id, @JsonKey(name: RoomDataLabels.roomType)  RoomType roomType, @JsonKey(name: RoomDataLabels.blackPlayer)  Player blackPlayer, @JsonKey(name: RoomDataLabels.whitePlayer)  Player whitePlayer, @JsonKey(name: RoomDataLabels.length)  int length, @JsonKey(name: RoomDataLabels.height)  int height, @JsonKey(name: RoomDataLabels.playerIdTurn)  String playerIdTurn, @JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter()  IList<IList<int>> currentBoard, @JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter()  IList<MoveData> lastMoves, @JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter()  Duration blackTotalDuration, @JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter()  Duration whiteTotalDuration, @JsonKey(name: RoomDataLabels.timestamp)  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _RoomData() when $default != null:
return $default(_that.id,_that.roomType,_that.blackPlayer,_that.whitePlayer,_that.length,_that.height,_that.playerIdTurn,_that.currentBoard,_that.lastMoves,_that.blackTotalDuration,_that.whiteTotalDuration,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomData extends RoomData {
   _RoomData({@JsonKey(name: RoomDataLabels.roomId) required this.id, @JsonKey(name: RoomDataLabels.roomType) this.roomType = RoomType.offlinePvP, @JsonKey(name: RoomDataLabels.blackPlayer) required this.blackPlayer, @JsonKey(name: RoomDataLabels.whitePlayer) required this.whitePlayer, @JsonKey(name: RoomDataLabels.length) this.length = 8, @JsonKey(name: RoomDataLabels.height) this.height = 8, @JsonKey(name: RoomDataLabels.playerIdTurn) required this.playerIdTurn, @JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter() required this.currentBoard, @JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter() required this.lastMoves, @JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter() this.blackTotalDuration = Duration.zero, @JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter() this.whiteTotalDuration = Duration.zero, @JsonKey(name: RoomDataLabels.timestamp) required this.timestamp}): assert(blackPlayer.id != whitePlayer.id, 'black and white player must have different ids'),super._();
  factory _RoomData.fromJson(Map<String, dynamic> json) => _$RoomDataFromJson(json);

@override@JsonKey(name: RoomDataLabels.roomId) final  String id;
@override@JsonKey(name: RoomDataLabels.roomType) final  RoomType roomType;
@override@JsonKey(name: RoomDataLabels.blackPlayer) final  Player blackPlayer;
@override@JsonKey(name: RoomDataLabels.whitePlayer) final  Player whitePlayer;
@override@JsonKey(name: RoomDataLabels.length) final  int length;
@override@JsonKey(name: RoomDataLabels.height) final  int height;
@override@JsonKey(name: RoomDataLabels.playerIdTurn) final  String playerIdTurn;
@override@JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter() final  IList<IList<int>> currentBoard;
@override@JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter() final  IList<MoveData> lastMoves;
@override@JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter() final  Duration blackTotalDuration;
@override@JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter() final  Duration whiteTotalDuration;
@override@JsonKey(name: RoomDataLabels.timestamp) final  DateTime timestamp;

/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomDataCopyWith<_RoomData> get copyWith => __$RoomDataCopyWithImpl<_RoomData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomData&&(identical(other.id, id) || other.id == id)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.blackPlayer, blackPlayer) || other.blackPlayer == blackPlayer)&&(identical(other.whitePlayer, whitePlayer) || other.whitePlayer == whitePlayer)&&(identical(other.length, length) || other.length == length)&&(identical(other.height, height) || other.height == height)&&(identical(other.playerIdTurn, playerIdTurn) || other.playerIdTurn == playerIdTurn)&&const DeepCollectionEquality().equals(other.currentBoard, currentBoard)&&const DeepCollectionEquality().equals(other.lastMoves, lastMoves)&&(identical(other.blackTotalDuration, blackTotalDuration) || other.blackTotalDuration == blackTotalDuration)&&(identical(other.whiteTotalDuration, whiteTotalDuration) || other.whiteTotalDuration == whiteTotalDuration)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomType,blackPlayer,whitePlayer,length,height,playerIdTurn,const DeepCollectionEquality().hash(currentBoard),const DeepCollectionEquality().hash(lastMoves),blackTotalDuration,whiteTotalDuration,timestamp);

@override
String toString() {
  return 'RoomData(id: $id, roomType: $roomType, blackPlayer: $blackPlayer, whitePlayer: $whitePlayer, length: $length, height: $height, playerIdTurn: $playerIdTurn, currentBoard: $currentBoard, lastMoves: $lastMoves, blackTotalDuration: $blackTotalDuration, whiteTotalDuration: $whiteTotalDuration, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$RoomDataCopyWith<$Res> implements $RoomDataCopyWith<$Res> {
  factory _$RoomDataCopyWith(_RoomData value, $Res Function(_RoomData) _then) = __$RoomDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: RoomDataLabels.roomId) String id,@JsonKey(name: RoomDataLabels.roomType) RoomType roomType,@JsonKey(name: RoomDataLabels.blackPlayer) Player blackPlayer,@JsonKey(name: RoomDataLabels.whitePlayer) Player whitePlayer,@JsonKey(name: RoomDataLabels.length) int length,@JsonKey(name: RoomDataLabels.height) int height,@JsonKey(name: RoomDataLabels.playerIdTurn) String playerIdTurn,@JsonKey(name: RoomDataLabels.currentBoard)@IListBoardConverter() IList<IList<int>> currentBoard,@JsonKey(name: RoomDataLabels.lastMoves)@IListMoveDataConverter() IList<MoveData> lastMoves,@JsonKey(name: RoomDataLabels.blackTotalDuration)@DurationSecondsConverter() Duration blackTotalDuration,@JsonKey(name: RoomDataLabels.whiteTotalDuration)@DurationSecondsConverter() Duration whiteTotalDuration,@JsonKey(name: RoomDataLabels.timestamp) DateTime timestamp
});


@override $PlayerCopyWith<$Res> get blackPlayer;@override $PlayerCopyWith<$Res> get whitePlayer;

}
/// @nodoc
class __$RoomDataCopyWithImpl<$Res>
    implements _$RoomDataCopyWith<$Res> {
  __$RoomDataCopyWithImpl(this._self, this._then);

  final _RoomData _self;
  final $Res Function(_RoomData) _then;

/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomType = null,Object? blackPlayer = null,Object? whitePlayer = null,Object? length = null,Object? height = null,Object? playerIdTurn = null,Object? currentBoard = null,Object? lastMoves = null,Object? blackTotalDuration = null,Object? whiteTotalDuration = null,Object? timestamp = null,}) {
  return _then(_RoomData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as RoomType,blackPlayer: null == blackPlayer ? _self.blackPlayer : blackPlayer // ignore: cast_nullable_to_non_nullable
as Player,whitePlayer: null == whitePlayer ? _self.whitePlayer : whitePlayer // ignore: cast_nullable_to_non_nullable
as Player,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,playerIdTurn: null == playerIdTurn ? _self.playerIdTurn : playerIdTurn // ignore: cast_nullable_to_non_nullable
as String,currentBoard: null == currentBoard ? _self.currentBoard : currentBoard // ignore: cast_nullable_to_non_nullable
as IList<IList<int>>,lastMoves: null == lastMoves ? _self.lastMoves : lastMoves // ignore: cast_nullable_to_non_nullable
as IList<MoveData>,blackTotalDuration: null == blackTotalDuration ? _self.blackTotalDuration : blackTotalDuration // ignore: cast_nullable_to_non_nullable
as Duration,whiteTotalDuration: null == whiteTotalDuration ? _self.whiteTotalDuration : whiteTotalDuration // ignore: cast_nullable_to_non_nullable
as Duration,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get blackPlayer {
  
  return $PlayerCopyWith<$Res>(_self.blackPlayer, (value) {
    return _then(_self.copyWith(blackPlayer: value));
  });
}/// Create a copy of RoomData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get whitePlayer {
  
  return $PlayerCopyWith<$Res>(_self.whitePlayer, (value) {
    return _then(_self.copyWith(whitePlayer: value));
  });
}
}

// dart format on

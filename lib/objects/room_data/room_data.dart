import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:othello/extensions/nested_list.dart';
import 'package:othello/objects/move_data/move_data.dart';
import 'package:othello/objects/room_data/next_move_fn_ids.dart';
import 'package:othello/objects/player/player.dart';
import 'package:othello/utils/globals.dart';

part 'room_data.freezed.dart';
part 'room_data.g.dart';

extension BoardExtensions on IList<IList<int>> {
  List<int> get flat => expand((row) => row).toList();
}

IList<IList<int>> fromFlatList(List<int> flat, int width) {
  List<IList<int>> res = [];
  List<int> temp = [];
  for (int i = 0; i < flat.length; i++) {
    if ((i + 1) % width == 0) {
      temp.add(flat[i]);
      res.add(temp.lock);
      temp.clear();
    } else {
      temp.add(flat[i]);
    }
  }
  return res.lock;
}

enum RoomType { offlinePvP, offlinePvC, offlineCvC, onlinePvP }

class IListMoveDataConverter
    implements JsonConverter<IList<MoveData>, List<dynamic>?> {
  const IListMoveDataConverter();

  @override
  IList<MoveData> fromJson(List<dynamic>? json) {
    if (json == null || json.isEmpty) return const IList.empty();
    return json
        .map((e) => MoveData.fromJson(Map<String, dynamic>.from(e as Map)))
        .toIList();
  }

  @override
  List<dynamic> toJson(IList<MoveData> object) =>
      object.map((e) => e.toJson()).toList();
}

@freezed
sealed class RoomData with _$RoomData {
  const RoomData._();


  // Non-const: DateTime has no const constructor, and dropping const lets
  // freezed's @Assert run against non-const-evaluable field expressions.
  @Assert('blackPlayer.id != whitePlayer.id', 'black and white player must have different ids')
  factory RoomData({
    required String id,
    @Default(RoomType.offlinePvP) RoomType roomType,
    required Player blackPlayer,
    required Player whitePlayer,
    @Default(8) int length,
    @Default(8) int height,
    required String playerIdTurn,
    @IListBoardConverter() required IList<IList<int>> currentBoard,
    @IListMoveDataConverter() required IList<MoveData> lastMoves,
    @DurationSecondsConverter() @Default(Duration.zero) Duration blackTotalDuration,
    @DurationSecondsConverter() @Default(Duration.zero) Duration whiteTotalDuration,
    required DateTime timestamp,
  }) = _RoomData;

  factory RoomData.fromJson(Map<String, dynamic> json) =>
      _$RoomDataFromJson(json);

  /// Private factory for new games: clamps dimensions, asserts distinct players,
  /// and sets initial board, empty lastMoves, and current timestamp.
  factory RoomData._raw({
    required String id,
    required RoomType roomType,
    required Player blackPlayer,
    required Player whitePlayer,
    required String playerIdTurn,
    int length = 8,
    int height = 8,
  }) {
    final len = max(2, length);
    final h = max(2, height);
    return RoomData(
      id: id,
      roomType: roomType,
      blackPlayer: blackPlayer,
      whitePlayer: whitePlayer,
      playerIdTurn: playerIdTurn,
      length: len,
      height: h,
      currentBoard: initializeBoard(len, h),
      lastMoves: const IList.empty(),
      timestamp: DateTime.now(),
    );
  }

  /// New room with same type and player config as [existing]; fresh id, board, and timestamp.
  factory RoomData.freshFrom(RoomData existing) {
    final black = Player.create(nextMoveFnId: existing.blackPlayer.nextMoveFnId);
    final white = Player.create(nextMoveFnId: existing.whitePlayer.nextMoveFnId);
    return RoomData._raw(
      id: Globals.uuid.v1(),
      roomType: existing.roomType,
      blackPlayer: black,
      whitePlayer: white,
      playerIdTurn: existing.isWhiteTurn ? white.id : black.id,
      length: existing.length,
      height: existing.height,
    );
  }

  factory RoomData.offlinePvP({
    int height = 8,
    int length = 8,
    bool whiteFirstTurn = false,
  }) {
    final black = Player.create();
    final white = Player.create();
    return RoomData._raw(
      id: Globals.uuid.v1(),
      roomType: RoomType.offlinePvP,
      blackPlayer: black,
      whitePlayer: white,
      playerIdTurn: whiteFirstTurn ? white.id : black.id,
      length: length,
      height: height,
    );
  }

  factory RoomData.offlinePvC({
    int height = 8,
    int length = 8,
    bool whiteFirstTurn = false,
    bool mainPlayerIsWhite = false,
  }) {
    final computerPlayer = Player.create(nextMoveFnId: NextMoveFnIds.offlineTempId);
    final mainPlayer = Player.create();
    final black = mainPlayerIsWhite ? computerPlayer : mainPlayer;
    final white = mainPlayerIsWhite ? mainPlayer : computerPlayer;
    return RoomData._raw(
      id: Globals.uuid.v1(),
      roomType: RoomType.offlinePvC,
      blackPlayer: black,
      whitePlayer: white,
      playerIdTurn: whiteFirstTurn ? white.id : black.id,
      length: length,
      height: height,
    );
  }

  factory RoomData.offlineCvC({int length = 8, int height = 8}) {
    final black = Player.create(nextMoveFnId: NextMoveFnIds.offlineDelayedTempId);
    final white = Player.create(nextMoveFnId: NextMoveFnIds.offlineDelayedTempId);
    return RoomData._raw(
      id: Globals.uuid.v1(),
      roomType: RoomType.offlineCvC,
      blackPlayer: black,
      whitePlayer: white,
      playerIdTurn: white.id,
      length: length,
      height: height,
    );
  }

  factory RoomData.onlinePvP({required String creatorUserId}) {
    final creator = Player.create(id: creatorUserId);
    final empty = Player.create(id: '');
    final roomCode = (Random().nextInt(9000) + 1000).toString();
    return RoomData._raw(
      id: roomCode,
      roomType: RoomType.onlinePvP,
      blackPlayer: creator,
      whitePlayer: empty,
      playerIdTurn: creator.id,
    );
  }

  static IList<IList<int>> initializeBoard(int length, int height) {
    List<List<int>> board = [];
    for (int i = 0; i < height; i++) {
      board.add(List.filled(length, -1));
    }
    int lMidSecond = length ~/ 2, hMidSecond = height ~/ 2;
    board[hMidSecond - 1][lMidSecond - 1] = 0;
    board[hMidSecond][lMidSecond] = 0;
    board[hMidSecond - 1][lMidSecond] = 1;
    board[hMidSecond][lMidSecond - 1] = 1;
    return board.deepLock;
  }

  int get currentPlayerMove => _playerMove(isWhiteTurn);
  
  static int _playerMove(bool whiteTurn) => whiteTurn ? 0 : 1;

  String playerId(bool isWhiteTurn) =>
      isWhiteTurn ? whitePlayer.id : blackPlayer.id;

  bool get isWhiteTurn => playerIdTurn == whitePlayer.id;

  bool get isManualTurn => _currentPlayer.nextMoveFnId == null;

  Player get _currentPlayer => isWhiteTurn ? whitePlayer : blackPlayer;

  Duration getTotalDuration(bool forWhite) =>
      forWhite ? whiteTotalDuration : blackTotalDuration;

  Future<List<int>?> get nextTurn => _currentPlayer.nextTurn(this);

  int totalPieces({bool forWhite = true}) {
    int res = 0;
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < length; j++) {
        if (currentBoard[i][j] == _playerMove(forWhite)) res++;
      }
    }
    return res;
  }

  bool get isGameEnded => getPossibleMovesList().isEmpty;

  List<List<int>> getPossibleMovesList() {
    List<List<int>> res = [];
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < length; j++) {
        if (currentBoard[i][j] != -1) continue;
        if (getPiecesToFlip(i, j, currentPlayerMove).length > 0) {
          res.add([i, j]);
        }
      }
    }
    return res;
  }

  ///-1 for tie
  ///0 for White win
  ///1 for black win
  int getStatus() {
    final totalPieces = _getTotalPieces();
    assert(totalPieces.length == 3);
    if (totalPieces[0] == totalPieces[1]) return -1;
    return totalPieces[0] > totalPieces[1] ? 0 : 1;
  }

  List<int> _getTotalPieces() {
    List<int> res = [0, 0, 0];
    for (int i = 0; i < currentBoard.length; i++) {
      for (int j = 0; j < currentBoard[i].length; j++) {
        if (currentBoard[i][j] == 0) {
          res[0]++;
        } else if (currentBoard[i][j] == 1) {
          res[1]++;
        } else {
          res[2]++;
        }
      }
    }
    return res;
  }

  List<List<List<int>>?> getPiecesToFlip(int mainI, int mainJ, int value) {
    final maxDepth = max(this.height, this.length);
    int currentI = mainI, currentJ = mainJ, step;
    bool flipping = true;
    List<List<List<int>>?> piecesToFlip = [];
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        step = 1;
        flipping = false;
        for (int k = 0;; k += step) {
          currentI += step * i;
          currentJ += step * j;
          if (k == -1) break;
          //prevent if any infinite loop happening, even though it should not happen
          if (k > maxDepth || k < -maxDepth) {
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
            break;
          }
          if (currentI < 0 ||
              currentI >= this.height ||
              currentJ < 0 ||
              currentJ >= this.length ||
              currentBoard[currentI][currentJ] == -1) {
            step = -1;
            continue;
          }
          if ((step == 1 && currentBoard[currentI][currentJ] == value)) {
            step = -1;
            flipping = true;
            continue;
          }
          if (step == 1 || !flipping) continue;
          if (piecesToFlip.length <= k + 1) piecesToFlip.length = k + 1;
          if (piecesToFlip[k] == null) piecesToFlip[k] = [];
          piecesToFlip[k]!.add([currentI, currentJ]);
        }
      }
    }
    return piecesToFlip;
  }
}

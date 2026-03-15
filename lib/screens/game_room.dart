import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:othello/components/common_alert_dialog.dart';
import 'package:othello/components/flip_piece.dart';
import 'package:othello/components/piece.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/providers/room_data/room_data.dart' hide RoomData;
import 'package:othello/providers/room_data_db/room_data_db.dart';
import 'package:othello/widgets/room_data_scope.dart';

/// Gate: waits for init, checks room exists; shows loading/invalid or builds [GameRoom].
class GameRoomGate extends ConsumerStatefulWidget {
  const GameRoomGate({super.key, required this.roomDataId});

  final String roomDataId;

  @override
  ConsumerState<GameRoomGate> createState() => _GameRoomGateState();
}

class _GameRoomGateState extends ConsumerState<GameRoomGate> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    ref.read(roomDataDbProvider.notifier).waitForInitialization.then((_) {
      if (mounted) setState(() => _initialized = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final exists = ref.watch(roomExistsProvider(widget.roomDataId));
    if (!exists) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Invalid room',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }
    return GameRoom(roomDataId: widget.roomDataId);
  }
}

class GameRoom extends ConsumerStatefulWidget {
  const GameRoom({
    super.key,
    required this.roomDataId,
    this.onlyBoard = false,
  });

  final String roomDataId;
  final bool onlyBoard;

  @override
  ConsumerState<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends ConsumerState<GameRoom>
    with SingleTickerProviderStateMixin {
  late List<Widget> mainStack;
  bool _gameStateInitialized = false;

  void _createGameState() {
    if (_gameStateInitialized) return;
    _gameStateInitialized = true;
    final notifier = ref.read(roomDataProvider(widget.roomDataId).notifier);
    notifier.initGameState(
      onEndGame: _showEndGameDialog,
      autoReset: widget.onlyBoard,
    );
    _initStack();
  }

  void _showEndGameDialog(int status) {
    String title = "TIE";
    if (status == 0) title = "WHITE WINS";
    else if (status == 1) title = "BLACK WINS";
    showDialog(
      context: context,
      builder: (ctx) => CommonAlertDialog(title),
    );
  }

  void _initStack() {
    final notifier = ref.read(roomDataProvider(widget.roomDataId).notifier);
    mainStack = [
      Column(
        children: List.generate(
          notifier.boardHeight,
          (i) => Row(
            children: List.generate(
              notifier.boardLength,
              (j) => Piece(
                notifier.cellWidth,
                initValue: notifier.board[i][j],
                onCreation: (state) => notifier.pieceStates[i][j] = state,
                onTap: notifier.onTapOnPiece(i, j),
                isWhiteTurn: () =>
                    ref.read(roomDataProvider(widget.roomDataId)).isWhiteTurn,
              ),
            ),
          ),
        ),
      ),
    ];

    for (int i = 0; i < notifier.boardHeight; i++) {
      for (int j = 0; j < notifier.boardLength; j++) {
        mainStack.add(
          FlipPiece(
            notifier.cellWidth,
            i,
            j,
            onCreation: (state) => notifier.flipPieceStates[i][j] = state,
            getPieceStateFn: () => notifier.pieceStates[i][j]!,
          ),
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notifier.makeNextTurn(false);
    });
  }

  Future<void> _resetGame() async {
    final notifier = ref.read(roomDataProvider(widget.roomDataId).notifier);
    final newId = await notifier.resetGame();
    if (mounted) context.go('/game_room/$newId');
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(roomDataProvider(widget.roomDataId));
    _createGameState();

    final notifier = ref.read(roomDataProvider(widget.roomDataId).notifier);
    final board = Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.all(10),
      child: Container(
        width: notifier.cellWidth * notifier.boardLength,
        height: notifier.cellWidth * notifier.boardHeight,
        color: Colors.green[600],
        child: Stack(
          children: mainStack,
        ),
      ),
    );

    return RoomDataScope(
      roomDataId: widget.roomDataId,
      child: widget.onlyBoard
          ? board
          : Scaffold(
              backgroundColor: Colors.black,
              body: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: ScoreBoard(forWhite: true, aboveBoard: true),
                      ),
                    ),
                    board,
                    Expanded(
                      child: Container(
                        child: ScoreBoard(
                            forWhite: false, aboveBoard: false),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: "undo_button",
                    child: Icon(Icons.undo),
                    onPressed: notifier.undo,
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: "reset_tag",
                    onPressed: _resetGame,
                    child: Icon(Icons.replay),
                  ),
                ],
              ),
            ),
    );
  }
}

class ScoreBoard extends ConsumerWidget {
  const ScoreBoard({
    super.key,
    this.forWhite = true,
    this.aboveBoard = true,
  });

  final bool forWhite;
  final bool aboveBoard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomDataId = RoomDataScope.of(context);
    final room = ref.watch(roomDataProvider(roomDataId));

    return LayoutBuilder(builder: (context, constraints) {
      double height =
          min(constraints.maxHeight, constraints.maxWidth * 0.17) / 2;
      return Align(
        alignment: aboveBoard ? Alignment.bottomRight : Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Container(
              color: Colors.brown.withAlpha(100),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage(
                        'assets/${forWhite ? 'flip_0' : 'flip_1'}/frame_0.png'),
                    width: height * 0.8,
                  ),
                  Icon(Icons.close_rounded),
                  Text(
                    room.totalPieces(forWhite: forWhite).toString(),
                    style: TextStyle(
                      fontSize: height * 0.8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: height * 0.3),
                  Icon(Icons.access_time),
                  SizedBox(width: height * 0.3),
                  ChanceTimer(forWhite, height * 0.8),
                ],
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      );
    });
  }
}

class ChanceTimer extends ConsumerStatefulWidget {
  ChanceTimer(this.forWhite, this.fontSize);

  final bool forWhite;
  final double fontSize;

  @override
  ConsumerState<ChanceTimer> createState() => _ChanceTimerState();
}

class _ChanceTimerState extends ConsumerState<ChanceTimer> {
  late DateTime _time;
  Timer? _timer;
  bool _initialized = false;

  void _updateFromRoom(RoomData room) {
    final duration = room.getTotalDuration(widget.forWhite);
    final isActive = room.isWhiteTurn == widget.forWhite;
    if (isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _continueTimer());
    } else {
      _cancelTimer();
    }
    if (mounted) {
      setState(() {
        _time = DateTime(DateTime.now().year).add(duration);
      });
    }
  }

  void _continueTimer() {
    if (_timer != null) return;
    const onSec = Duration(seconds: 1);
    _timer = Timer.periodic(onSec, (Timer timer) {
      if (mounted) setState(() => _time = _time.add(onSec));
    });
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    _time = DateTime(DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    final roomDataId = RoomDataScope.of(context);
    final room = ref.watch(roomDataProvider(roomDataId));

    ref.listen(roomDataProvider(roomDataId), (prev, next) {
      _updateFromRoom(next);
    });

    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateFromRoom(room);
      });
    }

    return Text(
      _time.hour == 0
          ? DateFormat.ms().format(_time)
          : DateFormat.Hms().format(_time),
      style: GoogleFonts.montserrat(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

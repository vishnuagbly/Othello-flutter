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
import 'package:othello/providers/game_state/game_state.dart' hide GameState;
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
  const GameRoom({super.key, required this.roomDataId, this.onlyBoard = false});

  final String roomDataId;
  final bool onlyBoard;

  @override
  ConsumerState<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends ConsumerState<GameRoom>
    with SingleTickerProviderStateMixin {
  late List<Widget> mainStack;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(gameStateProvider(widget.roomDataId).notifier)
            .initGameState(
              onEndGame: _showEndGameDialog,
              autoReset: widget.onlyBoard,
            );
        _initStack();
        /* Not doing setState because, already watching gameState in build */
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _initialized = true);
        });
      }
    });
  }

  void _showEndGameDialog(int status) {
    String title = "TIE";
    if (status == 0)
      title = "WHITE WINS";
    else if (status == 1)
      title = "BLACK WINS";
    showDialog(context: context, builder: (ctx) => CommonAlertDialog(title));
  }

  void _initStack() {
    final notifier = ref.read(gameStateProvider(widget.roomDataId).notifier);
    final boardLength = ref
        .read(gameStateProvider(widget.roomDataId))
        .roomData
        .length;
    final boardHeight = ref
        .read(gameStateProvider(widget.roomDataId))
        .roomData
        .height;

    mainStack = [
      Column(
        children: List.generate(
          boardHeight,
          (i) => Row(
            children: List.generate(
              boardLength,
              (j) => Piece(i, j, widget.roomDataId),
            ),
          ),
        ),
      ),
    ];

    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardLength; j++) {
        mainStack.add(FlipPiece(i, j, widget.roomDataId));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notifier.makeNextTurn(false);
    });
  }

  Future<void> _resetGame() async {
    // Capture all refs and data before any async gap or navigation,
    // so we never use ref after the widget might be disposed.
    final oldId = widget.roomDataId;
    final gameState = ref.read(gameStateProvider(oldId));
    final dbNotifier = ref.read(roomDataDbProvider.notifier);

    // Create new room first so the new route has valid data.
    final newRoom = RoomData.freshFrom(gameState.roomData);
    final newId = await dbNotifier.createRoom(newRoom);
    if (!mounted) return;

    // Delete old room from DB. gameStateProvider(oldId) will rebuild;
    // build() returns stale state and self-detaches from DB (no ref.watch).
    await dbNotifier.deleteRoom(oldId);
    if (!mounted) return;

    // Navigate last. We do NOT call ref.invalidate(gameStateProvider(oldId))
    // because: (1) invalidate on keepAlive only triggers a rebuild, it does
    // not dispose the provider; (2) build() self-detach already stopped the
    // old provider from reacting to DB changes; (3) the old provider stays
    // in memory inert (no subscriptions), which is acceptable.
    context.go('/game_room/$newId');
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    ref.watch(gameStateProvider(widget.roomDataId));
    final cellWidth = ref.read(
      gameStateProvider(widget.roomDataId).select((s) => s.cellWidth),
    );
    final roomDataLength = ref.read(
      gameStateProvider(widget.roomDataId).select((s) => s.roomData.length),
    );
    final roomDataHeight = ref.read(
      gameStateProvider(widget.roomDataId).select((s) => s.roomData.height),
    );
    final isWhiteTurn = ref.watch(
      gameStateProvider(
        widget.roomDataId,
      ).select((s) => s.roomData.isWhiteTurn),
    );
    final isOnlineRoom = ref.read(
      gameStateProvider(
        widget.roomDataId,
      ).select((s) => s.roomData.roomType == RoomType.onlinePvP),
    );
    final notifier = ref.read(gameStateProvider(widget.roomDataId).notifier);

    final board = Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.all(10),
      child: Container(
        width: cellWidth * roomDataLength,
        height: cellWidth * roomDataHeight,
        color: Colors.green[600],
        child: Stack(children: mainStack),
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
                    if (isOnlineRoom)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          isWhiteTurn ? "White's turn" : "Black's turn",
                        ),
                      ),
                    Expanded(
                      child: Container(
                        child: ScoreBoard(forWhite: true, aboveBoard: true),
                      ),
                    ),
                    board,
                    Expanded(
                      child: Container(
                        child: ScoreBoard(forWhite: false, aboveBoard: false),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isOnlineRoom) ...[
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
                ],
              ),
            ),
    );
  }
}

class ScoreBoard extends ConsumerWidget {
  const ScoreBoard({super.key, this.forWhite = true, this.aboveBoard = true});

  final bool forWhite;
  final bool aboveBoard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomDataId = RoomDataScope.of(context);
    final totalPieces = ref.watch(
      gameStateProvider(
        roomDataId,
      ).select((s) => s.roomData.totalPieces(forWhite: forWhite)),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/${forWhite ? 'flip_0' : 'flip_1'}/frame_0.png',
                      ),
                      width: height * 0.8,
                    ),
                    Icon(Icons.close_rounded),
                    Text(
                      totalPieces.toString(),
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
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
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

  Duration _getTotalDuration(RoomData room) {
    return room.getTotalDuration(widget.forWhite);
  }

  bool _getIsActive(RoomData room) {
    return (room.isWhiteTurn == widget.forWhite) && !room.isGameEnded;
  }

  void _updateTimer(Duration duration, bool isActive) {
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
    final timerData = ref.watch(
      gameStateProvider(roomDataId).select(
        (s) => (_getTotalDuration(s.roomData), _getIsActive(s.roomData)),
      ),
    );

    ref.listen(
      gameStateProvider(roomDataId).select(
        (s) => (_getTotalDuration(s.roomData), _getIsActive(s.roomData)),
      ),
      (prev, next) {
        _updateTimer(next.$1, next.$2);
      },
    );

    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTimer(timerData.$1, timerData.$2);
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

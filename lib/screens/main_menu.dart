import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othello/components/custom_button.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/providers/room_data_db/room_data_db.dart';
import 'package:othello/screens/game_room.dart';
import 'package:othello/screens/online.dart';
import 'package:othello/utils/globals.dart';

class MainMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Globals.setMediaQueryData(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage("assets/othello-background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Othello",
                  style: GoogleFonts.montserrat(
                    fontSize: Globals.maxScreenWidth * 0.17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: Globals.maxScreenWidth * 0.8,
                  constraints: BoxConstraints(
                    maxHeight: Globals.screenHeight * 0.5,
                  ),
                  child: FittedBox(child: _PreviewCvC()),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: "vs Computer",
                      onPressed: () =>
                          _onPlayPressed(context, ref, RoomType.offlinePvC),
                      width: Globals.maxScreenWidth * 0.34,
                    ),
                    SizedBox(width: Globals.maxScreenWidth * 0.06),
                    CustomButton(
                      text: "Pass N Play",
                      onPressed: () =>
                          _onPlayPressed(context, ref, RoomType.offlinePvP),
                      width: Globals.maxScreenWidth * 0.34,
                      white: false,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Online",
                  onPressed: () => context.push(OnlineScreen.kPath),
                  width: Globals.maxScreenWidth * 0.34,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPlayPressed(
    BuildContext context,
    WidgetRef ref,
    RoomType type,
  ) async {
    await ref.read(roomDataDbProvider.notifier).waitForInitialization;
    final rooms = ref.read(roomsByTypeProvider(type));

    if (rooms.isEmpty) {
      final room = type == RoomType.offlinePvP
          ? RoomData.offlinePvP()
          : RoomData.offlinePvC();
      final id = await ref.read(roomDataDbProvider.notifier).createRoom(room);
      if (context.mounted) context.go('/game_room/$id');
      return;
    }

    if (rooms.length == 1) {
      if (context.mounted) context.go('/game_room/${rooms.first.id}');
      return;
    }

    if (context.mounted) context.go('/rooms/${type.name}');
  }
}

class _PreviewCvC extends ConsumerStatefulWidget {
  const _PreviewCvC();

  @override
  ConsumerState<_PreviewCvC> createState() => _PreviewCvCState();
}

class _PreviewCvCState extends ConsumerState<_PreviewCvC> {
  String? _previewRoomId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensurePreviewRoom());
  }

  Future<void> _ensurePreviewRoom() async {
    await ref.read(roomDataDbProvider.notifier).waitForInitialization;
    final room = RoomData.offlineCvC();
    final id = await ref.read(roomDataDbProvider.notifier).createRoom(room);
    if (mounted) setState(() => _previewRoomId = id);
  }

  @override
  Widget build(BuildContext context) {
    if (_previewRoomId == null) {
      return SizedBox(
        width: 200,
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return GameRoom(roomDataId: _previewRoomId!, onlyBoard: true);
  }
}

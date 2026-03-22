import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/providers/room_data_db/room_data_db.dart';
import 'package:othello/utils/globals.dart';

class RoomListScreen extends ConsumerWidget {
  const RoomListScreen({super.key, required this.roomType});

  final RoomType roomType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsByTypeProvider(roomType));

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(_titleForType(roomType), style: GoogleFonts.montserrat()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final timestamp = room.lastMoves.isNotEmpty
              ? room.lastMoves.last.timestamp
              : room.timestamp;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.grey[900],
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: const AssetImage('assets/flip_0/frame_0.png'),
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    '${room.totalPieces(forWhite: true)}',
                    style: TextStyle(
                      fontSize: Globals.secondaryFontSize,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image(
                    image: const AssetImage('assets/flip_1/frame_0.png'),
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    '${room.totalPieces(forWhite: false)}',
                    style: TextStyle(
                      fontSize: Globals.secondaryFontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              title: Text(
                DateFormat.yMd().add_Hm().format(timestamp),
                style: GoogleFonts.montserrat(
                  fontSize: Globals.secondaryFontSize,
                  color: Colors.white70,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                onPressed: () {
                  ref.read(roomDataDbProvider.notifier).deleteRoom(room.id);
                },
              ),
              onTap: () => context.go('/game_room/${room.id}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final notifier = ref.read(roomDataDbProvider.notifier);
          final room = _newRoomForType(roomType);
          final id = await notifier.createRoom(room);
          if (context.mounted) context.go('/game_room/$id');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _titleForType(RoomType type) {
    switch (type) {
      case RoomType.offlinePvP:
        return 'Pass N Play';
      case RoomType.offlinePvC:
        return 'vs Computer';
      case RoomType.offlineCvC:
        return 'Computer vs Computer';
      case RoomType.onlinePvP:
        return 'Online Rooms';
    }
  }

  RoomData _newRoomForType(RoomType type) {
    switch (type) {
      case RoomType.offlinePvP:
        return RoomData.offlinePvP();
      case RoomType.offlinePvC:
        return RoomData.offlinePvC();
      case RoomType.offlineCvC:
        return RoomData.offlineCvC();
      case RoomType.onlinePvP:
        throw UnimplementedError();
    }
  }
}

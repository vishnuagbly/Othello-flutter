import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:othello/objects/room_data/room_data.dart';
import 'package:othello/providers/room_data_db/room_data_db.dart';
import 'package:othello/providers/user/users.dart';
import 'package:othello/utils/globals.dart';

class RoomListScreen extends ConsumerWidget {
  const RoomListScreen({super.key, required this.roomType});

  final RoomType roomType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsByTypeProvider(roomType));
    final currentUserId = ref.watch(
      currentUserProvider.select((user) => user.id),
    );
    final filteredRooms = roomType == RoomType.onlinePvP
        ? rooms
              .where(
                (room) =>
                    room.blackPlayer.id == currentUserId ||
                    room.whitePlayer.id == currentUserId,
              )
              .toList()
        : rooms;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(_titleForType(roomType), style: GoogleFonts.montserrat()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredRooms.length,
        itemBuilder: (context, index) {
          final room = filteredRooms[index];
          final timestamp = room.lastMoves.isNotEmpty
              ? room.lastMoves.last.timestamp
              : room.timestamp;
          final canEnter = roomType != RoomType.onlinePvP
              ? true
              : _isOnlineRoomReady(room);
          final subtitle = roomType == RoomType.onlinePvP
              ? (_isOnlineRoomReady(room)
                    ? 'Ready • ${DateFormat.yMd().add_Hm().format(timestamp)}'
                    : 'Waiting for opponent...')
              : null;

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
              title: roomType == RoomType.onlinePvP
                  ? Text(
                      'Code: ${room.id}',
                      style: GoogleFonts.montserrat(
                        fontSize: Globals.secondaryFontSize,
                        color: Colors.white70,
                      ),
                    )
                  : Text(
                      DateFormat.yMd().add_Hm().format(timestamp),
                      style: GoogleFonts.montserrat(
                        fontSize: Globals.secondaryFontSize,
                        color: Colors.white70,
                      ),
                    ),
              subtitle: subtitle == null
                  ? null
                  : Text(
                      subtitle,
                      style: GoogleFonts.montserrat(color: Colors.white54),
                    ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                onPressed: () {
                  ref.read(roomDataDbProvider.notifier).deleteRoom(room.id);
                },
              ),
              onTap: canEnter ? () => context.go('/game_room/${room.id}') : null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (roomType == RoomType.onlinePvP) {
            await _showOnlineRoomOptions(context, ref, currentUserId);
            return;
          }
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
        throw StateError('Use online room dialogs for RoomType.onlinePvP.');
    }
  }

  bool _isOnlineRoomReady(RoomData room) {
    return room.blackPlayer.id.isNotEmpty && room.whitePlayer.id.isNotEmpty;
  }

  Future<void> _showOnlineRoomOptions(
    BuildContext context,
    WidgetRef ref,
    String currentUserId,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Create Room'),
              onTap: () => Navigator.of(context).pop('create'),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Join Room'),
              onTap: () => Navigator.of(context).pop('join'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    if (action == 'create') {
      await _createOnlineRoom(context, ref, currentUserId);
    } else if (action == 'join') {
      await _joinOnlineRoom(context, ref, currentUserId);
    }
  }

  Future<void> _createOnlineRoom(
    BuildContext context,
    WidgetRef ref,
    String currentUserId,
  ) async {
    final notifier = ref.read(roomDataDbProvider.notifier);
    RoomData? roomToCreate;
    for (int attempt = 0; attempt < 10; attempt++) {
      final candidate = RoomData.onlinePvP(creatorUserId: currentUserId);
      if (!await notifier.roomCodeExists(candidate.id)) {
        roomToCreate = candidate;
        break;
      }
    }
    if (roomToCreate == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create room code.')));
      return;
    }
    final id = await notifier.createRoom(roomToCreate);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Room Created'),
        content: Text('Share this room code: $id'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _joinOnlineRoom(
    BuildContext context,
    WidgetRef ref,
    String currentUserId,
  ) async {
    final codeController = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Join Room'),
        content: TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(hintText: 'Enter 4-digit code'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(codeController.text.trim()),
            child: const Text('Join'),
          ),
        ],
      ),
    );
    codeController.dispose();
    if (!context.mounted || code == null) return;
    if (!RegExp(r'^\d{4}$').hasMatch(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit code.')),
      );
      return;
    }

    final notifier = ref.read(roomDataDbProvider.notifier);
    final room = await notifier.findRoomByCode(code);
    if (room == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Room not found or full.')));
      return;
    }

    if (room.blackPlayer.id == currentUserId || room.whitePlayer.id == currentUserId) {
      if (!_isOnlineRoomReady(room)) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Room is not ready yet.')));
        return;
      }
      if (!context.mounted) return;
      context.go('/game_room/${room.id}');
      return;
    }

    try {
      await notifier.joinRoom(room, currentUserId);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to join room. Please try again.')),
      );
      return;
    }
    if (!context.mounted) return;
    context.go('/game_room/${room.id}');
  }
}

import 'package:flutter/material.dart';

class JoinRoomDialog extends StatefulWidget {
  const JoinRoomDialog({super.key});

  @override
  State<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Room'),
      content: TextField(
        controller: codeController,
        keyboardType: TextInputType.number,
        maxLength: 4,
        decoration: const InputDecoration(hintText: 'Enter 4-digit code'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(codeController.text.trim()),
          child: const Text('Join'),
        ),
      ],
    );
  }
}

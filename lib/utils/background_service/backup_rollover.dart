import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:othello/utils/background_service/backup_log.dart';

/// Handles the Firestore document-size rollover.
///
/// When the main `usage_logs/{userId}` document approaches the 1 MiB Firestore
/// limit, the whole document is copied into a `history` sub-collection (keyed
/// by its `time`) and the main document is reset to an empty `data` map.
///
/// The decision to roll over is made by the caller from a locally-tracked byte
/// counter, so the common path never reads from Firestore. This archive-and-
/// reset performs a single read and only runs when the document is near the
/// limit.
abstract class BackupRollover {
  static const collection = 'usage_logs';

  /// Reads the current document once, copies it to `history/{time}`, then
  /// resets the main document to an empty `data` map.
  static Future<void> rollover(String userId) async {
    final logger = BackupLog();
    final docRef =
        FirebaseFirestore.instance.collection(collection).doc(userId);
    final snap = await docRef.get();
    final data = snap.data();
    if (!snap.exists || data == null) return;

    final time = (data['time'] as String?) ?? DateTime.now().toIso8601String();
    await docRef.collection('history').doc(time).set(data);
    await docRef.set({
      'id': userId,
      'time': DateTime.now().toIso8601String(),
      'data': <String, Object?>{},
    });
    log('Archived usage_logs/$userId to history/$time', name: 'usage-backup');
    await logger.warn('Archived usage_logs/$userId to history/$time');
  }
}

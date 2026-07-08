import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:othello/utils/background_service/backup_log.dart';

/// Handles the Firestore document-size rollover.
///
/// Mirrors the notebook's "Push saved data to history" flow: when the main
/// `usage_logs/{userId}` document approaches the 1 MiB Firestore limit, the
/// whole document is copied into a `history` sub-collection (keyed by its
/// `time`) and the main document is reset to an empty `data` map.
abstract class BackupRollover {
  static const collection = 'usage_logs';

  /// Firestore hard-limits documents to 1 MiB; archive a little early so a
  /// subsequent append is unlikely to cross the boundary.
  static const _thresholdBytes = 900 * 1024;

  static Future<void> rolloverIfNeeded(String userId) async {
    final logger = BackupLog();
    final docRef =
        FirebaseFirestore.instance.collection(collection).doc(userId);
    final snap = await docRef.get();
    final data = snap.data();
    if (!snap.exists || data == null) return;

    final estimatedBytes = utf8.encode(jsonEncode(data)).length;
    if (estimatedBytes < _thresholdBytes) {
      log('Doc usage_logs/$userId ~$estimatedBytes bytes; under threshold',
          name: 'usage-backup');
      await logger
          .info('Doc usage_logs/$userId ~$estimatedBytes bytes; under threshold');
      return;
    }

    final time = (data['time'] as String?) ?? DateTime.now().toIso8601String();
    await docRef.collection('history').doc(time).set(data);
    await docRef.set({
      'id': userId,
      'time': DateTime.now().toIso8601String(),
      'data': <String, Object?>{},
    });
    log('Archived usage_logs/$userId to history/$time (~$estimatedBytes bytes)',
        name: 'usage-backup');
    await logger.warn(
        'Archived usage_logs/$userId to history/$time (~$estimatedBytes bytes)');
  }
}

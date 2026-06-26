import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:othello/screens/stats/data/usage_log_repository.dart';
import 'package:othello/utils/background_service/backup_meta.dart';
import 'package:othello/utils/background_service/backup_rollover.dart';

/// Pushes all usage events recorded since the last successful push to
/// Firestore, advancing the watermark only on success.
abstract class BackupRunner {
  static Future<bool> run() async {
    final userId = BackupMeta.getUserId();
    if (userId == null) {
      log('No user id; skipping backup', name: 'usage-backup');
      return true;
    }

    final lastPushedId = BackupMeta.getLastPushedId();
    final events = await UsageLogRepository().fetchEventsSince(lastPushedId);
    if (events.isEmpty) {
      log('No new events to back up', name: 'usage-backup');
      return true;
    }

    final data = <String, Object?>{};
    var maxId = lastPushedId;
    for (final e in events) {
      data['${e.id}'] = {
        'ts': e.timestamp.millisecondsSinceEpoch,
        'type': e.type,
        'package': e.package,
      };
      if (e.id > maxId) maxId = e.id;
    }

    try {
      await _push(userId, data);
    } catch (err) {
      // Most likely the document exceeded the size limit. Archive + retry once.
      log('Push failed, attempting rollover: $err', name: 'usage-backup');
      try {
        await BackupRollover.rolloverIfNeeded(userId);
        await _push(userId, data);
      } catch (err2) {
        log('Backup still failing after rollover: $err2', name: 'usage-backup');
        await BackupMeta.setLastError('$err2');
        // Keep the watermark unchanged so the next run retries these events.
        return false;
      }
    }

    await BackupMeta.setLastPushedId(maxId);
    await BackupMeta.setLastError(null);
    log('Backed up ${events.length} events (through id $maxId)',
        name: 'usage-backup');
    return true;
  }

  /// Merge-writes the batch into `usage_logs/{userId}.data` so new event-id
  /// keys are added without overwriting previously stored ones.
  static Future<void> _push(String userId, Map<String, Object?> data) async {
    final docRef = FirebaseFirestore.instance
        .collection(BackupRollover.collection)
        .doc(userId);
    await docRef.set({
      'id': userId,
      'time': DateTime.now().toIso8601String(),
      'data': data,
    }, SetOptions(merge: true));
  }
}

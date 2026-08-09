import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:othello/screens/stats/data/usage_log_repository.dart';
import 'package:othello/utils/background_service/backup_log.dart';
import 'package:othello/utils/background_service/backup_meta.dart';
import 'package:othello/utils/background_service/backup_rollover.dart';

/// Pushes all usage events recorded since the last successful push to
/// Firestore, advancing the watermark only on success.
abstract class BackupRunner {
  /// Archive the document a little before Firestore's 1 MiB hard limit so the
  /// next batch is unlikely to cross the boundary.
  static const _thresholdBytes = 900 * 1024;

  static Future<bool> run() async {
    final logger = BackupLog();
    final userId = BackupMeta.getUserId();
    if (userId == null) {
      log('No user id; skipping backup', name: 'usage-backup');
      await logger.warn('No user id; skipping backup');
      return true;
    }

    final lastPushedId = BackupMeta.getLastPushedId();
    final events = await UsageLogRepository().fetchEventsSince(lastPushedId);
    if (events.isEmpty) {
      log('No new events to back up', name: 'usage-backup');
      await logger.info('No new events to back up (last pushed id $lastPushedId)');
      return true;
    }

    final batch = <Map<String, Object?>>[];
    var maxId = lastPushedId;
    for (final e in events) {
      batch.add({
        'ts': e.timestamp.millisecondsSinceEpoch,
        'type': e.type,
        'package': e.package,
      });
      if (e.id > maxId) maxId = e.id;
    }

    final batchKey = DateTime.now().millisecondsSinceEpoch.toString();
    final batchBytes = utf8.encode(jsonEncode({batchKey: batch})).length;

    final docRef = FirebaseFirestore.instance
        .collection(BackupRollover.collection)
        .doc(userId);

    try {
      // Seed the size counter from the live document the first time (e.g. after
      // an upgrade/migration) so a pre-existing doc isn't undercounted.
      var docBytes = BackupMeta.getDocBytes();
      if (docBytes == null) {
        final snap = await docRef.get();
        final data = snap.data()?['data'];
        docBytes = data == null ? 0 : utf8.encode(jsonEncode(data)).length;
      }

      if (docBytes + batchBytes > _thresholdBytes) {
        log('Doc near limit (~$docBytes bytes); rolling over',
            name: 'usage-backup');
        await logger.warn('Doc near limit (~$docBytes bytes); rolling over');
        await BackupRollover.rollover(userId);
        docBytes = 0;
      }

      await docRef.set({
        'id': userId,
        'time': DateTime.now().toIso8601String(),
        'data': {batchKey: batch},
      }, SetOptions(merge: true));

      await BackupMeta.setBackupResult(
        lastPushedId: maxId,
        docBytes: docBytes + batchBytes,
      );
    } catch (err) {
      log('Backup failed: $err', name: 'usage-backup');
      await logger.error('Backup failed: $err');
      await BackupMeta.setLastError('$err');
      // Keep the watermark unchanged so the next run retries these events.
      return false;
    }

    log('Backed up ${events.length} events (through id $maxId)',
        name: 'usage-backup');
    await logger.info('Backed up ${events.length} events (through id $maxId)');
    return true;
  }
}

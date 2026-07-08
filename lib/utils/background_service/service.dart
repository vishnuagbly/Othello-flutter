import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:othello/firebase_options.dart';
import 'package:othello/utils/background_service/backup_log.dart';
import 'package:othello/utils/background_service/backup_meta.dart';
import 'package:othello/utils/background_service/backup_runner.dart';
import 'package:workmanager/workmanager.dart';

abstract class ServiceTasks {
  static const kBackup = 'backup-usage-logs';
  static const kBackupUniqueName = 'unique-backup-usage-logs';
}

/// Entry point invoked by WorkManager in a background isolate. It must
/// bootstrap everything it needs (binding, Hive, Firebase) since the foreground
/// app may not be running.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final logger = BackupLog()..task = task;
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();
      await BackupMeta.initialize();
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      log('Native called background task: $task', name: 'usage-backup');
      await logger.info('Started task');

      if (task == ServiceTasks.kBackup) {
        final result = await BackupRunner.run();
        await logger.info('Task finished: $result');
        return result;
      }
      await logger.info('Unknown task');
      return true;
    } catch (e) {
      log('Background task failed: $task $e', name: 'usage-backup');
      await logger.error('Task crashed: $e');
      return false;
    }
  });
}

abstract class BackgroundService {
  static Future<void> initialize() async {
    if (!Platform.isAndroid) return;

    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().cancelAll();
    // No frequency => WorkManager's 15-minute minimum periodic interval.
    await Workmanager().registerPeriodicTask(
      ServiceTasks.kBackupUniqueName,
      ServiceTasks.kBackup,
    );
  }
}

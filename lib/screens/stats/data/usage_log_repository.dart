import 'package:sqflite/sqflite.dart';

/// A single row from the native `events` table.
class UsageEvent {
  const UsageEvent({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.package,
  });

  final int id;
  final DateTime timestamp;
  final String type;
  final String? package;

  factory UsageEvent.fromRow(Map<String, Object?> row) {
    return UsageEvent(
      id: (row['id'] as num).toInt(),
      timestamp: DateTime.fromMillisecondsSinceEpoch((row['ts'] as num).toInt()),
      type: row['type'] as String,
      package: row['package'] as String?,
    );
  }
}

/// Result of a single read of the shared usage database.
class UsageSnapshot {
  const UsageSnapshot({required this.serviceEnabled, required this.events});

  final bool serviceEnabled;
  final List<UsageEvent> events;

  static const empty = UsageSnapshot(serviceEnabled: false, events: []);
}

/// Reads the SQLite database that the native [UsageAccessibilityService] writes.
///
/// This is channel-free: the Kotlin service owns and writes the database via
/// Room, and Flutter opens the very same file (same app sandbox) read-only.
class UsageLogRepository {
  /// File name must match `UsageDatabase.DB_NAME` on the Kotlin side.
  static const _dbName = 'usage_logs.db';

  Future<UsageSnapshot> load() async {
    final path = '${await getDatabasesPath()}/$_dbName';

    // The file only exists once the service has run at least once. Before that
    // there is nothing to read and the service is effectively off.
    if (!await databaseExists(path)) {
      return UsageSnapshot.empty;
    }

    final db = await openReadOnlyDatabase(path);
    try {
      final eventRows = await db.query('events', orderBy: 'ts DESC');
      final events = eventRows.map(UsageEvent.fromRow).toList();

      var enabled = false;
      final statusRows = await db.query(
        'service_status',
        where: 'id = ?',
        whereArgs: [0],
        limit: 1,
      );
      if (statusRows.isNotEmpty) {
        enabled = (statusRows.first['connected'] as num?)?.toInt() == 1;
      }

      return UsageSnapshot(serviceEnabled: enabled, events: events);
    } finally {
      await db.close();
    }
  }

  /// Returns events with `id` greater than [lastId], oldest first.
  ///
  /// Used by the background backup job to read everything recorded since the
  /// last successful push (the watermark). Returns an empty list if the
  /// database does not exist yet.
  Future<List<UsageEvent>> fetchEventsSince(int lastId) async {
    final path = '${await getDatabasesPath()}/$_dbName';
    if (!await databaseExists(path)) return const [];

    final db = await openReadOnlyDatabase(path);
    try {
      final rows = await db.query(
        'events',
        where: 'id > ?',
        whereArgs: [lastId],
        orderBy: 'id ASC',
      );
      return rows.map(UsageEvent.fromRow).toList();
    } finally {
      await db.close();
    }
  }
}

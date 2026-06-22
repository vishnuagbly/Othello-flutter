package com.vishnuworld.othello.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
    entities = [EventEntity::class, ServiceStatusEntity::class],
    version = 1,
    exportSchema = false,
)
abstract class UsageDatabase : RoomDatabase() {
    abstract fun usageDao(): UsageDao

    companion object {
        const val DB_NAME = "usage_logs.db"

        @Volatile
        private var instance: UsageDatabase? = null

        fun get(context: Context): UsageDatabase =
            instance ?: synchronized(this) {
                instance ?: Room.databaseBuilder(
                    context.applicationContext,
                    UsageDatabase::class.java,
                    DB_NAME,
                )
                    // TRUNCATE (rollback journal) instead of the default WAL so the
                    // separate read-only sqflite connection on the Dart side always
                    // sees committed rows from the main .db file.
                    .setJournalMode(JournalMode.TRUNCATE)
                    .build()
                    .also { instance = it }
            }
    }
}

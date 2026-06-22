package com.vishnuworld.othello.data

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "events")
data class EventEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val ts: Long,
    val type: String,
    @ColumnInfo(name = "package") val packageName: String?,
    val extra: String? = null,
)

@Entity(tableName = "service_status")
data class ServiceStatusEntity(
    @PrimaryKey val id: Int = 0,
    val connected: Int,
    @ColumnInfo(name = "updated_at") val updatedAt: Long,
)

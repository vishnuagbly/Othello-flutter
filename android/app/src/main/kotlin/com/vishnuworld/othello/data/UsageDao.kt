package com.vishnuworld.othello.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy

@Dao
interface UsageDao {
    @Insert
    fun insertEvent(event: EventEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun setStatus(status: ServiceStatusEntity)
}

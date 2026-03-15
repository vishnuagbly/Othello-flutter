/// IDs for bot move functions in [NextMoveFns.fns].
/// Kept in a separate file to avoid circular imports between room_data and next_move_fns.
abstract class NextMoveFnIds {
  static const String offlineTempId = 'offlineTemp';
  static const String offlineDelayedTempId = 'offlineDelayedTemp';
}

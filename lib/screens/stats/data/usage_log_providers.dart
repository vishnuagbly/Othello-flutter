import 'package:othello/screens/stats/data/usage_log_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usage_log_providers.g.dart';

@riverpod
Future<UsageSnapshot> usageLogs(Ref ref) {
  return UsageLogRepository().load();
}

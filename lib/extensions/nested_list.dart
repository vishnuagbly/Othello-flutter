import 'package:fast_immutable_collections/fast_immutable_collections.dart';

extension DeepLockList<T> on List<List<T>> {
  IList<IList<T>> get deepLock =>
      [for (final row in this) row.lock].lock;
}

extension DeepUnlockIList<T> on IList<IList<T>> {
  List<List<T>> get deepUnlock =>
      [for (final row in this) row.unlock];
}

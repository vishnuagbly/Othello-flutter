import 'package:flutter/material.dart';

/// Provides [roomDataId] to the widget subtree so descendants can access
/// the current game's room id without prop drilling.
class RoomDataScope extends InheritedWidget {
  const RoomDataScope({
    super.key,
    required this.roomDataId,
    required super.child,
  });

  final String roomDataId;

  static String of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RoomDataScope>();
    assert(scope != null, 'No RoomDataScope found in context');
    return scope!.roomDataId;
  }

  static String? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RoomDataScope>()
        ?.roomDataId;
  }

  @override
  bool updateShouldNotify(RoomDataScope oldWidget) =>
      roomDataId != oldWidget.roomDataId;
}

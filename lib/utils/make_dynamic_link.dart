import 'package:flutter/material.dart';
import 'package:othello/screens/online_rooms.dart';
import 'package:share_plus/share_plus.dart';

import 'globals.dart';

Future<void> shareDynamicLink(BuildContext context, String roomId) async {
  final shareableUrl =
      Globals.BASE_LINK + "${OnlineRooms.routeName}/$roomId";
  await SharePlus.instance.share(ShareParams(text: shareableUrl));
}

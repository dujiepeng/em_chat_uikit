import 'package:flutter/widgets.dart';

typedef ChatUIKitActionItemOnTap = void Function(BuildContext context);

class ChatUIKitActionItem {
  ChatUIKitActionItem({
    required this.title,
    this.onTap,
    required this.icon,
  });

  final String title;
  final ChatUIKitActionItemOnTap? onTap;
  final String icon;
}

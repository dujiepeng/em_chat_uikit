import 'package:flutter/widgets.dart';

typedef ChatUIKitActionItemOnTap = void Function(BuildContext context);

class ChatUIKitActionItem {
  ChatUIKitActionItem({
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final ChatUIKitActionItemOnTap? onTap;
  final String icon;
}

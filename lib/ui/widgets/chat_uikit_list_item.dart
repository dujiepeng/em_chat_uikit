import 'package:em_chat_uikit/ui/widgets/chat_uikit_list_view.dart';
import 'package:flutter/material.dart';


class ChatUIKitListItemModel with ChatUIKitListItemModelBase{}

class ChatUIKitListItem extends StatelessWidget {
  const ChatUIKitListItem({
    required this.title,
    this.rightIcon,
    this.trailing,
    super.key,
  });
  final String title;
  final Widget? rightIcon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

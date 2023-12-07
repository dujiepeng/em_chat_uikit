import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class MessageListView extends StatefulWidget {
  const MessageListView({required this.profile, this.controller, super.key});
  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late final MessageListViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? MessageListViewController(profile: widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}

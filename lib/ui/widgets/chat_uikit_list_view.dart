import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

typedef ChatUIKitListItemBuilder = Widget Function(
    BuildContext context, ChatUIKitListItemModel model);

abstract class ChatUIKitListItemModel {}

class ChatUIKitListView extends StatefulWidget {
  const ChatUIKitListView({
    required this.controller,
    required this.itemBuilder,
    super.key,
  });
  final ChatUIKitListViewControllerBase controller;
  final ChatUIKitListItemBuilder itemBuilder;

  @override
  State<ChatUIKitListView> createState() => _ChatUIKitListViewState();
}

class _ChatUIKitListViewState extends State<ChatUIKitListView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

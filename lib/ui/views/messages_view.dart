import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class MessagesView extends StatefulWidget {
  MessagesView.arguments(MessagesViewArguments arguments, {super.key})
      : profile = arguments.profile,
        controller = arguments.controller,
        appBar = arguments.appBar;

  const MessagesView({
    required this.profile,
    this.appBar,
    this.controller,
    super.key,
  });

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final ChatUIKitAppBar? appBar;
  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  late final MessageListViewController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? MessageListViewController(profile: widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = MessageListView(
      profile: widget.profile,
      controller: controller,
    );

    content = Scaffold(
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            title: widget.profile.showName,
          ),
      body: content,
    );

    return content;
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class MessagesView extends StatefulWidget {
  MessagesView.arguments(MessagesViewArguments arguments, {super.key})
      : profile = arguments.profile,
        controller = arguments.controller,
        inputBar = arguments.inputBar,
        appBar = arguments.appBar;

  const MessagesView({
    required this.profile,
    this.appBar,
    this.inputBar,
    this.controller,
    super.key,
  });

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final Widget? inputBar;
  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  late final MessageListViewController controller;
  @override
  void initState() {
    super.initState();
    controller = MessageListViewController(profile: widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = MessageListView(
      profile: widget.profile,
      controller: controller,
    );

    content = Column(
      children: [
        Expanded(child: content),
        widget.inputBar ??
            ChatUIKitInputBar(
              onSend: (text) {
                controller.sendTextMessage(text);
              },
            )
      ],
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            title: widget.profile.showName,
          ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: content)),
    );

    return content;
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/widgets/chat_uikit_input_emoji.dart';

import 'package:flutter/material.dart';

class MessagesView extends StatefulWidget {
  MessagesView.arguments(MessagesViewArguments arguments, {super.key})
      : profile = arguments.profile,
        controller = arguments.controller,
        inputBar = arguments.inputBar,
        appBar = arguments.appBar,
        showAvatar = arguments.showAvatar,
        showNickname = arguments.showNickname,
        onItemTap = arguments.onItemTap,
        onItemLongPress = arguments.onItemLongPress,
        onDoubleTap = arguments.onDoubleTap,
        onAvatarTap = arguments.onAvatarTap,
        onNicknameTap = arguments.onNicknameTap,
        focusNode = arguments.focusNode,
        emojiWidget = arguments.emojiWidget;

  const MessagesView({
    required this.profile,
    this.appBar,
    this.inputBar,
    this.controller,
    super.key,
    this.showAvatar = true,
    this.showNickname = true,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onNicknameTap,
    this.focusNode,
    this.emojiWidget,
  });

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final Widget? inputBar;
  final bool showAvatar;
  final bool showNickname;
  final void Function(Message message)? onItemTap;
  final void Function(Message message)? onItemLongPress;
  final void Function(Message message)? onDoubleTap;
  final void Function(ChatUIKitProfile profile)? onAvatarTap;
  final void Function(ChatUIKitProfile profile)? onNicknameTap;
  final FocusNode? focusNode;
  final Widget? emojiWidget;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  late final MessageListViewController controller;
  late final TextEditingController textEditingController;
  late final FocusNode focusNode;
  bool showEmoji = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    controller = MessageListViewController(profile: widget.profile);
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showEmoji = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = MessageListView(
      profile: widget.profile,
      controller: controller,
      showAvatar: widget.showAvatar,
      showNickname: widget.showNickname,
      onItemTap: widget.onItemTap,
      onItemLongPress: widget.onItemLongPress,
      onDoubleTap: widget.onDoubleTap,
      onAvatarTap: widget.onAvatarTap,
      onNicknameTap: widget.onNicknameTap,
    );

    content = Column(
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: content)),
        widget.inputBar ?? inputBar(),
        AnimatedContainer(
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 250),
          height: showEmoji ? 230 : 0,
          child: showEmoji
              ? widget.emojiWidget ?? const ChatInputEmoji()
              : const SizedBox(),
        ),
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
      body: SafeArea(child: content),
    );

    return content;
  }

  Widget inputBar() {
    return ChatUIKitInputBar(
      focusNode: focusNode,
      textEditingController: textEditingController,
      leading: InkWell(
        onTap: () {},
        child: ChatUIKitImageLoader.voiceKeyboard(),
      ),
      trailing: SizedBox(
        child: Row(
          children: [
            if (!showEmoji)
              InkWell(
                onTap: () {
                  focusNode.unfocus();
                  showEmoji = !showEmoji;
                  setState(() {});
                },
                child: ChatUIKitImageLoader.faceKeyboard(),
              ),
            if (showEmoji)
              InkWell(
                onTap: () {
                  focusNode.requestFocus();
                  showEmoji = !showEmoji;
                  setState(() {});
                },
                child: ChatUIKitImageLoader.textKeyboard(),
              ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                String text = textEditingController.text.trim();
                if (text.isNotEmpty) {
                  controller.sendTextMessage(text);
                  textEditingController.clear();
                }
              },
              child: ChatUIKitImageLoader.sendKeyboard(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class MessagesViewArguments implements ChatUIKitViewArguments {
  MessagesViewArguments({
    required this.profile,
    this.controller,
    this.appBar,
    this.inputBar,
    this.attributes,
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
  String? attributes;
}

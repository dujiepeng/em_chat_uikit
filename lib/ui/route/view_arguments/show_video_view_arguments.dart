import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ShowVideoViewArguments implements ChatUIKitViewArguments {
  ShowVideoViewArguments({
    required this.message,
    this.onImageLongPressed,
    this.attributes,
    this.playIcon,
    this.appBar,
    this.enableAppBar = true,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;
  final Widget? playIcon;
  final AppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;

  ShowVideoViewArguments copyWith({
    Message? message,
    void Function(Message message)? onImageLongPressed,
    Widget? playIcon,
    AppBar? appBar,
    bool? enableAppBar,
    String? attributes,
  }) {
    return ShowVideoViewArguments(
      message: message ?? this.message,
      onImageLongPressed: onImageLongPressed ?? this.onImageLongPressed,
      playIcon: playIcon ?? this.playIcon,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ShowImageViewArguments implements ChatUIKitViewArguments {
  ShowImageViewArguments({
    required this.message,
    this.onImageLongPressed,
    this.onImageTap,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;
  final void Function(Message message)? onImageTap;
  final AppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;

  ShowImageViewArguments copyWith({
    Message? message,
    void Function(Message message)? onImageLongPressed,
    void Function(Message message)? onImageTap,
    AppBar? appBar,
    bool? enableAppBar,
    String? attributes,
  }) {
    return ShowImageViewArguments(
      message: message ?? this.message,
      onImageLongPressed: onImageLongPressed ?? this.onImageLongPressed,
      onImageTap: onImageTap ?? this.onImageTap,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}

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
}

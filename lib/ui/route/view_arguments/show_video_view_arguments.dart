import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ShowVideoViewArguments implements ChatUIKitViewArguments {
  ShowVideoViewArguments({
    required this.message,
    this.onImageLongPressed,
    this.attributes,
    this.playIcon,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;
  final Widget? playIcon;

  @override
  String? attributes;
}

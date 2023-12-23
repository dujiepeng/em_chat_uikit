import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitAvatar extends StatefulWidget {
  const ChatUIKitAvatar({
    this.avatarUrl,
    this.size = 32,
    this.cornerRadius,
    super.key,
  });
  final double size;
  final CornerRadius? cornerRadius;
  final String? avatarUrl;

  @override
  State<ChatUIKitAvatar> createState() => _ChatUIKitAvatarState();
}

class _ChatUIKitAvatarState extends State<ChatUIKitAvatar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
        width: widget.size,
        height: widget.size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            CornerRadiusHelper.avatarRadius(
              widget.size,
              cornerRadius: widget.cornerRadius,
            ),
          ),
        ),
        child: ChatUIKitImageLoader.defaultAvatar(
          height: widget.size,
          width: widget.size,
        ));
    return content;
  }
}

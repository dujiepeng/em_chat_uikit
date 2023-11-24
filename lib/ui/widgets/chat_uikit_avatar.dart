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
  late final CornerRadius cornerRadius;
  @override
  void initState() {
    cornerRadius = widget.cornerRadius ?? ChatUIKitSettings.avatarRadius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double circular = 0;
    if (cornerRadius == CornerRadius.extraSmall) {
      circular = widget.size / 16;
    } else if (cornerRadius == CornerRadius.small) {
      circular = widget.size / 8;
    } else if (cornerRadius == CornerRadius.medium) {
      circular = widget.size / 4;
    } else {
      circular = widget.size / 2;
    }

    Widget content = Container(
      width: widget.size,
      height: widget.size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(circular),
      ),
    );
    return content;
  }
}

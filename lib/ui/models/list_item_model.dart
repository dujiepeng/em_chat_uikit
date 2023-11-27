import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitListItemModel with ChatUIKitListItemModelBase {
  ChatUIKitListItemModel(
    this.title, {
    this.index,
    this.enableArrow = true,
    this.onTap,
    this.height = 54,
  });

  final int? index;
  final bool enableArrow;
  final String title;
  final VoidCallback? onTap;
  final double height;

  @override
  String get showName => title;
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitListItemModel with ChatUIKitListItemModelBase, NeedHeight {
  ChatUIKitListItemModel(
    this.title, {
    this.index,
    this.enableArrow = true,
    this.onTap,
  });

  final int? index;
  final bool enableArrow;
  final String title;
  final VoidCallback? onTap;

  @override
  double get itemHeight => 54;
}

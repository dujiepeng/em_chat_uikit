import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

typedef ListViewBuilder = Widget Function(
  BuildContext context,
  List<ChatUIKitListItemModel> list,
);

class AlphabeticalListItemModel with ChatUIKitListItemModel {
  final String alphabetical;
  AlphabeticalListItemModel(this.alphabetical);
  @override
  bool get enableLongPress => false;
  @override
  bool get enableTap => false;
}

class ChatUIKitAlphabeticalView extends StatefulWidget {
  const ChatUIKitAlphabeticalView({
    required this.list,
    required this.controller,
    required this.builder,
    this.enableSorting = true,
    this.alphabeticalBuilder,
    this.targets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#',
    super.key,
  });

  final String targets;
  final ScrollController controller;
  final ListViewBuilder builder;
  final bool enableSorting;

  final Widget Function(BuildContext context, String target)?
      alphabeticalBuilder;
  final List<ChatUIKitListItemModel> list;

  @override
  State<ChatUIKitAlphabeticalView> createState() =>
      _ChatUIKitAlphabeticalViewState();
}

class _ChatUIKitAlphabeticalViewState extends State<ChatUIKitAlphabeticalView> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enableSorting) {
      return widget.builder.call(
        context,
        widget.list,
      );
    }

    return widget.builder.call(
      context,
      sortList(),
    );
  }

  List<ChatUIKitListItemModel> sortList() {
    List<String> targetList = widget.targets.split('');
    debugPrint('targetList: $targetList');
    return [];
  }
}

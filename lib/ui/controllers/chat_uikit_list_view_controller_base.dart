import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

abstract mixin class ChatUIKitListViewControllerBase {
  ValueNotifier<ChatUIKitListViewType> loadingType =
      ValueNotifier(ChatUIKitListViewType.normal);

  bool alphabeticalSorting = false;

  bool hasMore = true;

  Future<void> fetchItemList() async {
    return;
  }

  Future<void> fetchMoreItemList() async {
    return;
  }

  List<ChatUIKitListItemModelBase> list = [];
}

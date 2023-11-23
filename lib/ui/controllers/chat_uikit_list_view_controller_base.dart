import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

abstract mixin class ChatUIKitListViewControllerBase {
  ValueNotifier<ChatUIKitListViewType> loadingType =
      ValueNotifier(ChatUIKitListViewType.normal);

  bool alphabeticalSorting = false;

  bool hasMore = true;

  Future<void> fetchItemList();

  Future<void> fetchMoreItemList();

  List<ChatUIKitListItemModel> list = [];
}

import 'package:em_chat_uikit/chat_uikit.dart';

abstract mixin class ChatUIKitListViewControllerBase {
  bool alphabeticalSorting = false;

  bool hasMore = true;

  Future<List<ChatUIKitListItemModel>> fetchItemList();

  Future<List<ChatUIKitListItemModel>> fetchMoreItemList();
}

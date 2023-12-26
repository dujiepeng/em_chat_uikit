import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/rendering.dart';

class ConversationListViewController extends ChatUIKitListViewControllerBase {
  ConversationListViewController({
    this.pageSize = 50,
    bool search = false,
  });
  final int pageSize;

  String? cursor;

  @override
  Future<void> fetchItemList() async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    try {
      if (items.isEmpty &&
          !ChatUIKitContext.instance.isConversationLoadFinished()) {
        items = await fetchConversations();
      }
      items = await clearEmpty(items);
      List<ConversationInfo> tmp = await mappers(items);
      list.clear();
      list.addAll(tmp);
      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    items = await clearEmpty(items);
    List<ConversationInfo> tmp = await mappers(items);
    list.clear();
    list.addAll(tmp);
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  @override
  Future<List<ChatUIKitListItemModelBase>> fetchMoreItemList() async {
    List<ChatUIKitListItemModelBase> list = [];
    return list;
  }

  Future<List<Conversation>> clearEmpty(List<Conversation> list) async {
    List<Conversation> tmp = [];
    for (var item in list) {
      final latest = await item.latestMessage();
      if (latest != null) {
        tmp.add(item);
      }
    }
    return tmp;
  }

  bool hasFetchPinned = false;
  Future<List<Conversation>> fetchConversations() async {
    List<Conversation> items = [];
    if (!hasFetchPinned) {
      CursorResult<Conversation> result =
          await ChatUIKit.instance.fetchPinnedConversations(pageSize: 50);
      items.addAll(result.data);
      hasFetchPinned = true;
    }
    if (items.isEmpty) {
      CursorResult<Conversation> result =
          await ChatUIKit.instance.fetchConversations(
        pageSize: pageSize,
        cursor: cursor,
      );
      cursor = result.cursor;
      items.addAll(result.data);
      if (result.data.length < pageSize) {
        ChatUIKitContext.instance.setConversationLoadFinished();
        hasMore = false;
      }
    } else {
      try {
        CursorResult<Conversation> result =
            await ChatUIKit.instance.fetchConversations(
          pageSize: pageSize,
          cursor: cursor,
        );
        cursor = result.cursor;
        items.addAll(result.data);
        if (result.data.length < pageSize) {
          ChatUIKitContext.instance.setConversationLoadFinished();
          hasMore = false;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    await updateMuteType(items);

    if (hasMore) {
      List<Conversation> tmp = await fetchConversations();
      items.addAll(tmp);
    }
    return items;
  }

  Future<void> updateMuteType(List<Conversation> items) async {
    try {
      Map<String, ChatSilentModeResult> map =
          await ChatUIKit.instance.fetchSilentModel(conversations: items);
      ChatUIKitContext.instance.addConversationMute(
        map.map((key, value) => MapEntry(key, 1)),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<ConversationInfo>> mappers(
      List<Conversation> conversations) async {
    List<ConversationInfo> list = [];
    for (var item in conversations) {
      ConversationInfo info = await ConversationInfo.fromConversation(item);
      list.add(info);
    }
    return list;
  }
}

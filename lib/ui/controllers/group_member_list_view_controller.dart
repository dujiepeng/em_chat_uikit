import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';
// import 'package:username/username.dart';

class GroupMemberListViewController with ChatUIKitListViewControllerBase {
  GroupMemberListViewController(this.groupId,
      {this.owner, this.pageSize = 200});
  final String groupId;
  final int pageSize;
  final String? owner;
  String? cursor;

  @override
  Future<void> fetchItemList() async {
    try {
      loadingType.value = ChatUIKitListViewType.loading;
      cursor = null;
      CursorResult<String> items =
          await ChatUIKit.instance.fetchGroupMemberList(
        groupId: groupId,
        pageSize: pageSize,
        cursor: cursor,
      );
      cursor = items.cursor;
      if (items.data.length < pageSize) {
        hasMore = false;
      }

      List<String> userIds = items.data;
      if (owner != null) {
        userIds.insert(0, owner!);
      }
      List<ContactItemModel> tmp = mappers(userIds);
      list.clear();
      list.addAll(tmp);

      debugPrint('list length: ${list.length}');
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
  Future<void> fetchMoreItemList() async {
    if (hasMore) {
      try {
        loadingType.value = ChatUIKitListViewType.refresh;
        CursorResult<String> items =
            await ChatUIKit.instance.fetchGroupMemberList(
          groupId: groupId,
          pageSize: pageSize,
          cursor: cursor,
        );
        cursor = items.cursor;
        if (items.data.length < pageSize) {
          hasMore = false;
        }
        List<ContactItemModel> tmp = mappers(items.data);
        list.addAll(tmp);
        loadingType.value = ChatUIKitListViewType.normal;
        // ignore: empty_catches
      } catch (e) {}
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  List<ContactItemModel> mappers(List<String> contacts) {
    List<ContactItemModel> mapperList = [];
    for (var item in contacts) {
      ContactItemModel info = ContactItemModel.fromContact(item);
      mapperList.add(info);
    }
    return mapperList;
  }

  @override
  Future<void> refresh() async {}
}

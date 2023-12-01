import 'package:em_chat_uikit/chat_uikit.dart';
// import 'package:username/username.dart';

class GroupListViewController with ChatUIKitListViewControllerBase {
  GroupListViewController();

  String? cursor;

  @override
  Future<void> fetchItemList() async {
    loadingType.value = ChatUIKitListViewType.loading;

    try {
      List<Group> items = await ChatUIKit.instance.fetchJoinedGroups();
      List<GroupItemModel> tmp = mappers(items);
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
  Future<List<ChatUIKitListItemModelBase>> fetchMoreItemList() async {
    List<ChatUIKitListItemModelBase> list = [];
    return list;
  }

  List<GroupItemModel> mappers(List<Group> groups) {
    List<GroupItemModel> list = [];
    for (var item in groups) {
      GroupItemModel info = GroupItemModel.fromGroup(item);
      list.add(info);
    }
    return list;
  }
}

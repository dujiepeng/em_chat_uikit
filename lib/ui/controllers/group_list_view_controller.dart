import 'package:em_chat_uikit/chat_uikit.dart';
// import 'package:username/username.dart';

class GroupListViewController with ChatUIKitListViewControllerBase {
  GroupListViewController({
    this.pageSize = 20,
  });

  final int pageSize;
  int pageNum = 0;

  @override
  Future<void> fetchItemList() async {
    loadingType.value = ChatUIKitListViewType.loading;
    pageNum = 0;
    try {
      List<Group> items = await ChatUIKit.instance.fetchJoinedGroups(
        pageSize: pageSize,
        pageNum: pageNum,
      );
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
  Future<void> fetchMoreItemList() async {
    if (hasMore == false) return;
    pageNum += 1;
    List<Group> items = await ChatUIKit.instance.fetchJoinedGroups(
      pageSize: pageSize,
      pageNum: pageNum,
    );
    if (items.isEmpty || items.length < pageSize) {
      hasMore = false;
      return;
    }
    List<GroupItemModel> tmp = mappers(items);
    list.addAll(tmp);
    refresh();
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

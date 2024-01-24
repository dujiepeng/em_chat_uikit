import 'package:em_chat_uikit/chat_uikit.dart';
// import 'package:username/username.dart';

class ContactListViewController with ChatUIKitListViewControllerBase {
  ContactListViewController();

  String? cursor;

  @override
  Future<void> fetchItemList() async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<String> items = await ChatUIKit.instance.getAllContacts();
    try {
      if (items.isEmpty && !ChatUIKitContext.instance.isContactLoadFinished()) {
        items = await _fetchContacts();
      }
      for (var element in items) {
        ChatUIKitContext.instance.removeRequest(element);
      }
      List<ContactItemModel> tmp = mappers(items);
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

  Future<List<String>> _fetchContacts() async {
    List<String> result = await ChatUIKit.instance.fetchAllContactIds();
    ChatUIKitContext.instance.setContactLoadFinished();
    return result;
  }

  List<ContactItemModel> mappers(List<String> contacts) {
    List<ContactItemModel> list = [];
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(() {
      List<ChatUIKitProfile> profile = [];
      for (var item in contacts) {
        profile.add(ChatUIKitProfile.contact(id: item));
      }
      return profile;
    }());
    for (var item in contacts) {
      ContactItemModel info = ContactItemModel.fromProfile(map[item]!);
      list.add(info);
    }
    return list;
  }

  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<String> items = await ChatUIKit.instance.getAllContacts();
    for (var element in items) {
      ChatUIKitContext.instance.removeRequest(element);
    }
    List<ContactItemModel> tmp = mappers(items);
    list.clear();
    list.addAll(tmp);
    loadingType.value = ChatUIKitListViewType.normal;
  }
}

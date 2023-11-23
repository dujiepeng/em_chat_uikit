import 'package:em_chat_uikit/chat_uikit.dart';

class ContactListViewController with ChatUIKitListViewControllerBase {
  ContactListViewController();

  String? cursor;

  @override
  Future<void> fetchItemList() async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<String> items = await ChatUIKit.instance.getAllContacts();
    try {
      if (items.isEmpty && !ChatUIKitContext.instance.isContactLoadFinished()) {
        items = await fetchContacts();
      }
      List<ContactItemModel> tmp = mappers(items);
      list.clear();
      list.addAll(tmp);
      loadingType.value = ChatUIKitListViewType.normal;
    } catch (e) {
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  @override
  Future<List<ChatUIKitListItemModel>> fetchMoreItemList() async {
    List<ChatUIKitListItemModel> list = [];
    return list;
  }

  Future<List<String>> fetchContacts() async {
    List<String> result = await ChatUIKit.instance.fetchAllContacts();
    ChatUIKitContext.instance.setContactLoadFinished();
    return result;
  }

  List<ContactItemModel> mappers(List<String> contacts) {
    List<ContactItemModel> list = [];
    for (var item in contacts) {
      ContactItemModel info = ContactItemModel.fromContact(item);
      list.add(info);
    }
    return list;
  }
}

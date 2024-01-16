import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/pages/tool/user_data_store.dart';

class CustomConversationController extends ConversationListViewController {
  @override
  Future<void> fetchItemList() async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<Conversation> items = [];
    for (var conversationId in UserDataStore().unNotifyGroupIds) {
      Conversation conversation = await ChatUIKit.instance.createConversation(
        conversationId: conversationId,
        type: ConversationType.GroupChat,
      );
      items.add(conversation);
    }
    items = await clearEmpty(items);
    List<ConversationInfo> tmp = await mappers(items);
    list.clear();
    list.addAll(tmp);
    list.cast<ConversationInfo>().sort((a, b) {
      return b.lastMessage!.serverTime.compareTo(a.lastMessage!.serverTime);
    });
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    list.cast<ConversationInfo>().removeWhere((element) =>
        !UserDataStore().unNotifyGroupIds.contains(element.profile.id));
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }
}

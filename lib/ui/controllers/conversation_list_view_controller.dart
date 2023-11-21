import 'package:em_chat_uikit/chat_uikit.dart';

class ConversationListViewController with ChatUIKitListViewControllerBase {
  ConversationListViewController({
    this.pageSize = 30,
  });

  final int pageSize;

  String? cursor;

  @override
  Future<List<ChatUIKitListItemModel>> fetchItemList() async {
    CursorResult<Conversation> result =
        await ChatUIKit.instance.fetchConversation(
      cursor: cursor,
      pageSize: pageSize,
    );

    Map<String, ChatSilentModeResult> map =
        await ChatUIKit.instance.fetchSilentModel(
      conversations: result.data,
    );

    throw UnimplementedError();
  }

  @override
  Future<List<ChatUIKitListItemModel>> fetchMoreItemList() {
    throw UnimplementedError();
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';

class MessageListViewController with ChatObserver {
  final ChatUIKitProfile profile;
  final int pageSize;
  bool hasMore = false;
  MessageListViewController({required this.profile, this.pageSize = 30});

  List<Message> moreData = [];
  List<Message> newData = [];

  Future<void> fetchItemList() async {
    List<Message> list = await ChatUIKit.instance.getMessages(
      conversationId: profile.id,
      type: () {
        if (profile.type == ChatUIKitProfileType.groupChat ||
            profile.type == ChatUIKitProfileType.group) {
          return ConversationType.GroupChat;
        } else {
          return ConversationType.Chat;
        }
      }(),
      count: pageSize,
    );
    if (list.length < pageSize) {
      hasMore = false;
    }
    moreData.addAll(list.reversed);
  }
}

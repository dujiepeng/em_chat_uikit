import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

enum MessageLastActionType {
  send,
  receive,
  load,
  none,
}

class MessageListViewController extends ChangeNotifier {
  final ChatUIKitProfile profile;
  final int pageSize;
  late final ConversationType type;
  bool isEmpty = false;
  String? lastMessageId;
  bool hasNew = false;
  MessageLastActionType lastActionType = MessageLastActionType.none;

  final List<Message> moreData = [];
  final List<Message> newData = [];

  MessageListViewController({required this.profile, this.pageSize = 20}) {
    type = () {
      if (profile.type == ChatUIKitProfileType.groupChat ||
          profile.type == ChatUIKitProfileType.group) {
        return ConversationType.GroupChat;
      } else {
        return ConversationType.Chat;
      }
    }();
  }

  Future<bool> fetchItemList() async {
    if (isEmpty) {
      return false;
    }
    List<Message> list = await ChatUIKit.instance.getMessages(
      conversationId: profile.id,
      type: type,
      count: pageSize,
      startId: lastMessageId,
    );
    if (list.length < pageSize) {
      isEmpty = true;
    }
    if (list.isNotEmpty) {
      lastMessageId = list.first.msgId;
      newData.addAll(list.reversed);
      lastActionType = MessageLastActionType.load;
      notifyListeners();
      lastActionType = MessageLastActionType.none;
    }
    return list.isNotEmpty;
  }

  Future<void> sendTextMessage(String text) async {
    Message message = Message.createTxtSendMessage(
      targetId: profile.id,
      chatType: chatType,
      content: text,
    );
    final msg = await ChatUIKit.instance.sendMessage(message: message);
    newData.insert(0, msg);
    hasNew = true;
    lastActionType = MessageLastActionType.send;
    notifyListeners();
    lastActionType = MessageLastActionType.none;
  }

  ChatType get chatType {
    if (profile.type == ChatUIKitProfileType.groupChat ||
        profile.type == ChatUIKitProfileType.group) {
      return ChatType.GroupChat;
    } else {
      return ChatType.Chat;
    }
  }
}

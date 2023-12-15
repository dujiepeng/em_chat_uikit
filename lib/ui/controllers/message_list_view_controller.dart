import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

enum MessageLastActionType {
  send,
  receive,
  load,
  none,
}

class MessageListViewController extends ChangeNotifier with ChatObserver {
  final ChatUIKitProfile profile;
  final int pageSize;
  late final ConversationType type;
  bool isEmpty = false;
  String? lastMessageId;
  bool hasNew = false;
  MessageLastActionType lastActionType = MessageLastActionType.none;

  final List<Message> newData = [];

  MessageListViewController({required this.profile, this.pageSize = 30}) {
    ChatUIKit.instance.addObserver(this);
    type = () {
      if (profile.type == ChatUIKitProfileType.groupChat ||
          profile.type == ChatUIKitProfileType.group) {
        return ConversationType.GroupChat;
      } else {
        return ConversationType.Chat;
      }
    }();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
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
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    List<Message> list = [];
    for (var element in messages) {
      if (element.conversationId == profile.id) {
        list.add(element);
      }
    }
    if (list.isNotEmpty) {
      newData.insertAll(0, list.reversed);
      hasNew = true;
      lastActionType = MessageLastActionType.receive;
      notifyListeners();
    }
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

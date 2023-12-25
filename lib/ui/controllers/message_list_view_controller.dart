import 'dart:io';
import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

enum MessageLastActionType {
  send,
  receive,
  load,
  none,
}

class MessageListViewController extends ChangeNotifier
    with ChatObserver, MessageObserver {
  final ChatUIKitProfile profile;
  final int pageSize;
  late final ConversationType conversationType;
  bool isEmpty = false;
  String? lastMessageId;
  bool hasNew = false;
  MessageLastActionType lastActionType = MessageLastActionType.none;

  final List<Message> msgList = [];

  MessageListViewController({required this.profile, this.pageSize = 30}) {
    ChatUIKit.instance.addObserver(this);
    conversationType = () {
      if (profile.type == ChatUIKitProfileType.groupChat ||
          profile.type == ChatUIKitProfileType.groupMember) {
        return ConversationType.GroupChat;
      } else {
        return ConversationType.Chat;
      }
    }();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    // debugPrintStack(label: "msgListController dispose");

    super.dispose();
  }

  Future<bool> fetchItemList() async {
    if (isEmpty) {
      return false;
    }
    List<Message> list = await ChatUIKit.instance.getMessages(
      conversationId: profile.id,
      type: conversationType,
      count: pageSize,
      startId: lastMessageId,
    );
    if (list.length < pageSize) {
      isEmpty = true;
    }
    if (list.isNotEmpty) {
      lastMessageId = list.first.msgId;
      msgList.addAll(list.reversed);
      lastActionType = MessageLastActionType.load;
      notifyListeners();
    }
    return list.isNotEmpty;
  }

  @override
  void onMessageContentChanged(
    Message message,
    String operatorId,
    int operationTime,
  ) {
    final index =
        msgList.indexWhere((element) => element.msgId == message.msgId);
    if (index != -1) {
      msgList[index] = message;
      notifyListeners();
    }
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
      msgList.insertAll(0, list.reversed);
      hasNew = true;
      lastActionType = MessageLastActionType.receive;
      notifyListeners();
    }
  }

  @override
  void onConversationRead(String from, String to) {
    debugPrint("onConversationRead");
    if (from == profile.id) {
      for (var element in msgList) {
        element.hasReadAck = true;
      }
      notifyListeners();
    }
  }

  @override
  void onMessagesDelivered(List<Message> messages) {
    List<Message> list = msgList
        .where((element1) => messages
            .where((element2) => element1.msgId == element2.msgId)
            .isNotEmpty)
        .toList();
    if (list.isNotEmpty) {
      for (var element in list) {
        element.hasDeliverAck = true;
      }
      notifyListeners();
    }
  }

  @override
  void onMessagesRead(List<Message> messages) {
    List<Message> list = msgList
        .where((element1) => messages
            .where((element2) => element1.msgId == element2.msgId)
            .isNotEmpty)
        .toList();
    if (list.isNotEmpty) {
      for (var element in list) {
        element.hasReadAck = true;
      }
      notifyListeners();
    }
  }

  @override
  void onMessagesRecalled(List<Message> messages) {
    debugPrint("onMessagesRecalled");
  }

  @override
  void onSuccess(String msgId, Message msg) {
    final index = msgList.indexWhere((element) => element.msgId == msgId);
    if (index != -1) {
      msgList[index] = msg;
      notifyListeners();
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    final index = msgList.indexWhere((element) => element.msgId == msgId);
    if (index != -1) {
      msgList[index] = msg;
      notifyListeners();
    }
  }

  @override
  void onProgress(String msgId, int progress) {}

  void addMessages(List<Message> msgs) {
    msgList.insertAll(0, msgs.reversed);
    notifyListeners();
  }

  ChatType get chatType {
    if (profile.type == ChatUIKitProfileType.groupChat ||
        profile.type == ChatUIKitProfileType.groupMember) {
      return ChatType.GroupChat;
    } else {
      return ChatType.Chat;
    }
  }

  Future<void> sendTextMessage(
    String text, {
    Message? replay,
    dynamic mention,
  }) async {
    Message message = Message.createTxtSendMessage(
      targetId: profile.id,
      chatType: chatType,
      content: text,
    );

    if (mention != null) {
      Map<String, dynamic> mentionExt = {};
      if (mention is bool && mention == true) {
        mentionExt[mentionAllKey] = mentionAllValue;
      } else if (mention is List<String>) {
        List<String> mentionList = [];
        for (var userId in mention) {
          {
            mentionList.add(userId);
          }
        }
        if (mentionList.isNotEmpty) {
          mentionExt[mentionUserKey] = mentionList;
        }
      }
      if (mentionExt.isNotEmpty) {
        message.attributes = mentionExt;
      }
    }

    if (replay != null) {
      message.addQuote(replay);
    }

    sendMessage(message);
  }

  Future<void> editMessage(Message message, String content) async {
    TextMessageBody msgBody = TextMessageBody(content: content);
    try {
      Message msg = await ChatUIKit.instance.modifyMessage(
        messageId: message.msgId,
        msgBody: msgBody,
      );
      final index = msgList.indexWhere((element) => msg.msgId == element.msgId);
      if (index != -1) {
        msgList[index] = msg;
        notifyListeners();
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await ChatUIKit.instance.deleteLocalMessageById(
        conversationId: profile.id,
        type: conversationType,
        messageId: messageId,
      );
      msgList.removeWhere((element) => messageId == element.msgId);
      notifyListeners();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> recallMessage(Message message) async {
    int index = msgList.indexWhere((element) => message.msgId == element.msgId);
    if (index != -1) {
      await ChatUIKit.instance.recallMessage(messageId: message.msgId);
      Message recallMsg = ChatUIKitInsertMessageTool.insertRecallMessage(
          conversationId: profile.id,
          type: conversationType,
          messageId: message.msgId,
          info: '撤回一条消息');
      msgList[index] = recallMsg;
      notifyListeners();
    }
  }

  Future<void> sendVoiceMessage(ChatUIKitRecordModel model) async {
    final message = Message.createVoiceSendMessage(
        targetId: profile.id,
        chatType: chatType,
        filePath: model.path,
        duration: model.duration,
        displayName: model.displayName);
    sendMessage(message);
  }

  Future<void> sendImageMessage(String path, {String? name}) async {
    if (path.isEmpty) {
      return;
    }
    bool hasSize = false;
    File file = File(path);
    Image.file(file)
        .image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, synchronousCall) {
      if (!hasSize) {
        hasSize = true;
        Message message = Message.createImageSendMessage(
          targetId: profile.id,
          chatType: chatType,
          filePath: path,
          width: info.image.width.toDouble(),
          height: info.image.height.toDouble(),
          fileSize: file.lengthSync(),
          displayName: name,
        );
        sendMessage(message);
      }
    }));
  }

  Future<void> sendVideoMessage(
    String path, {
    String? name,
    double? width,
    double? height,
    int? duration,
  }) async {
    if (path.isEmpty) {
      return;
    }
    final imageData = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 80,
    );
    if (imageData != null) {
      final directory = await getApplicationCacheDirectory();
      String thumbnailPath =
          '${directory.path}/thumbnail_${Random().nextInt(999999999)}.jpeg';
      final file = File(thumbnailPath);
      file.writeAsBytesSync(imageData);

      final videoFile = File(path);

      Image.file(file)
          .image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((info, synchronousCall) {
        final msg = Message.createVideoSendMessage(
          targetId: profile.id,
          chatType: chatType,
          filePath: path,
          thumbnailLocalPath: file.path,
          width: info.image.width.toDouble(),
          height: info.image.height.toDouble(),
          fileSize: videoFile.lengthSync(),
        );
        sendMessage(msg);
      }));
    }
  }

  Future<void> sendFileMessage(
    String path, {
    String? name,
    int? fileSize,
  }) async {
    final msg = Message.createFileSendMessage(
      targetId: profile.id,
      chatType: chatType,
      filePath: path,
      fileSize: fileSize,
      displayName: name,
    );
    sendMessage(msg);
  }

  Future<void> sendCardMessage(ChatUIKitProfile cardProfile) async {
    Map<String, String> param = {cardContactUserId: cardProfile.id};
    if (profile.name != null) {
      param[cardContactNickname] = cardProfile.name!;
    }
    if (profile.avatarUrl != null) {
      param[cardContactAvatar] = cardProfile.avatarUrl!;
    }

    final message = Message.createCustomSendMessage(
      targetId: profile.id,
      chatType: chatType,
      event: cardMessageKey,
      params: param,
    );
    sendMessage(message);
  }

  Future<void> sendMessage(Message message) async {
    final msg = await ChatUIKit.instance.sendMessage(message: message);
    msgList.insert(0, msg);
    hasNew = true;
    lastActionType = MessageLastActionType.send;
    notifyListeners();
  }

  Future<void> resendMessage(Message message) async {
    msgList.removeWhere((element) => element.msgId == message.msgId);
    final msg = await ChatUIKit.instance.sendMessage(message: message);
    msgList.insert(0, msg);
    hasNew = true;
    lastActionType = MessageLastActionType.send;
    notifyListeners();
  }

// support single chat.
  Future<void> sendConversationsReadAck() async {
    await markAllMessageAsRead();
    if (conversationType == ConversationType.Chat) {
      try {
        final conv = await ChatUIKit.instance.getConversation(
          conversationId: profile.id,
          type: conversationType,
        );
        int unreadCount = await conv?.unreadCount() ?? 0;
        if (unreadCount > 0) {
          await ChatUIKit.instance
              .sendConversationReadAck(conversationId: profile.id);
          for (var element in msgList) {
            element.hasReadAck = true;
          }
        }

        // 因为已读状态是对方看的，所以这个时候不需要刷新ui
        // notifyListeners();
        // ignore: empty_catches
      } catch (e) {
        debugPrint('sendConversationsReadAck: $e');
      }
    }
  }

  Future<void> sendMessageReadAck(Message message) async {
    if (message.chatType == ChatType.Chat &&
        message.direction == MessageDirection.RECEIVE &&
        message.hasReadAck == false) {
      try {
        debugPrint("send read ack");
        await ChatUIKit.instance.sendMessageReadAck(message: message);
        message.hasReadAck = true;
        // 因为已读状态是对方看的，所以这个时候不需要刷新ui
        // notifyListeners();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  Future<void> markAllMessageAsRead() async {
    await ChatUIKit.instance.markConversationAsRead(conversationId: profile.id);
  }

  Future<void> downloadMessage(Message message) async {
    ChatUIKit.instance.downloadAttachment(message: message);
  }
}

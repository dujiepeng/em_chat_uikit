import 'dart:io';
import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

import '../../universal/defines.dart';

enum MessageLastActionType {
  send,
  receive,
  load,
  none,
}

class MessageListViewController extends ChangeNotifier
    with ChatObserver, MessageObserver {
  ChatUIKitProfile profile;
  final int pageSize;
  late final ConversationType conversationType;
  bool isEmpty = false;
  String? lastMessageId;
  bool hasNew = false;
  bool isFetching = false;
  MessageLastActionType lastActionType = MessageLastActionType.none;
  final Message? Function(Message)? willSendHandler;

  final List<Message> msgList = [];
  final Map<String, UserData> userMap = {};

  void clearMessages() {
    msgList.clear();
    lastActionType = MessageLastActionType.none;
    hasNew = false;
    lastMessageId = null;
  }

  MessageListViewController({
    required this.profile,
    this.pageSize = 30,
    this.willSendHandler,
  }) {
    ChatUIKit.instance.addObserver(this);
    conversationType = () {
      if (profile.type == ChatUIKitProfileType.group) {
        return ConversationType.GroupChat;
      } else {
        return ConversationType.Chat;
      }
    }();
    if (ChatUIKit.instance.currentUserId != null) {
      userMap[ChatUIKit.instance.currentUserId!] = UserData(
        nickname: ChatUIKitProvider.instance.currentUserData?.nickname,
        avatarUrl: ChatUIKitProvider.instance.currentUserData?.avatarUrl,
        time: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  void fetchItemList() async {
    if (isEmpty) {
      return;
    }
    if (isFetching) return;
    isFetching = true;
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
      for (var msg in list) {
        UserData? userData = userMap[msg.from!];
        if ((userData?.time ?? 0) < msg.serverTime) {
          userData = UserData(
            nickname: msg.nickname,
            avatarUrl: msg.avatarUrl,
            time: msg.serverTime,
          );
          userMap[msg.from!] = userData;
        }
      }
      msgList.addAll(list.reversed);

      lastActionType = MessageLastActionType.load;
      notifyListeners();
    }
    isFetching = false;
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
        userMap[element.from!] = UserData(
          nickname: element.nickname,
          avatarUrl: element.avatarUrl,
        );
      }
    }
    if (list.isNotEmpty) {
      _clearMention(list);
      msgList.insertAll(0, list.reversed);
      hasNew = true;
      lastActionType = MessageLastActionType.receive;
      notifyListeners();
    }
  }

  @override
  void onConversationRead(String from, String to) {
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
  void onMessagesRecalled(List<Message> recalled, List<Message> replaces) {
    bool needReload = false;
    for (var i = 0; i < recalled.length; i++) {
      int index =
          msgList.indexWhere((element) => recalled[i].msgId == element.msgId);
      if (index != -1) {
        msgList[index] = replaces[i];
        needReload = true;
      }
    }
    if (needReload) {
      notifyListeners();
    }
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

  // @override
  // void onProgress(String msgId, int progress) {}

  // void addMessages(List<Message> msgs) {
  //   msgList.insertAll(0, msgs.reversed);
  //   notifyListeners();
  // }

  void replaceMessage(Message message) {
    final index =
        msgList.indexWhere((element) => element.msgId == message.msgId);
    if (index != -1) {
      msgList[index] = message;
      notifyListeners();
    }
  }

  void playMessage(Message message) {
    if (message.bodyType == MessageType.VOICE) {
      if (!message.voiceHasPlay) {
        message.setVoiceHasPlay(true);
        replaceMessage(message);
      }
    }
  }

  Future<void> _clearMention(List<Message> msgs) async {
    if (profile.type == ChatUIKitProfileType.group) {
      return;
    }
    if (msgs.any((element) => element.hasMention)) {
      clearMentionIfNeed();
    }
  }

  ChatType get chatType {
    if (profile.type == ChatUIKitProfileType.group) {
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
        mentionExt[mentionKey] = mentionAllValue;
      } else if (mention is List<String>) {
        List<String> mentionList = [];
        for (var userId in mention) {
          {
            mentionList.add(userId);
          }
        }
        if (mentionList.isNotEmpty) {
          mentionExt[mentionKey] = mentionList;
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
      try {
        await ChatUIKit.instance.recallMessage(message: message);
        notifyListeners();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  Future<void> reportMessage({
    required Message message,
    required String tag,
    required String reason,
  }) async {
    try {
      ChatUIKit.instance.reportMessage(
        messageId: message.msgId,
        tag: tag,
        reason: reason,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> sendVoiceMessage(ChatUIKitRecordModel model) async {
    final message = Message.createVoiceSendMessage(
      targetId: profile.id,
      chatType: chatType,
      filePath: model.path,
      duration: model.duration,
      displayName: model.displayName,
    );
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
    Map<String, String> param = {cardUserIdKey: cardProfile.id};
    if (profile.name != null) {
      param[cardNicknameKey] = cardProfile.name!;
    }
    if (profile.avatarUrl != null) {
      param[cardAvatarKey] = cardProfile.avatarUrl!;
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
    Message? willSendMsg = message;
    if (willSendHandler != null) {
      willSendMsg = willSendHandler!(willSendMsg);
      if (willSendMsg == null) {
        return Future(() => null);
      }
    }
    final msg = await ChatUIKit.instance.sendMessage(message: willSendMsg);
    userMap[ChatUIKit.instance.currentUserId!] = UserData(
      nickname: ChatUIKitProvider.instance.currentUserData?.nickname,
      avatarUrl: ChatUIKitProvider.instance.currentUserData?.avatarUrl,
    );
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

  void clearMentionIfNeed() {
    if (profile.type == ChatUIKitProfileType.group) {
      ChatUIKit.instance
          .getConversation(
        conversationId: profile.id,
        type: ConversationType.GroupChat,
      )
          .then((conv) {
        if (conv != null) {
          conv.removeMention();
        }
      });
    }
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

  void sendMessageReadAck(Message message) {
    if (message.chatType == ChatType.Chat &&
        message.direction == MessageDirection.RECEIVE &&
        message.hasReadAck == false) {
      ChatUIKit.instance.sendMessageReadAck(message: message).then((value) {
        message.hasReadAck = true;
      }).catchError((error) {});
    }
  }

  Future<void> markAllMessageAsRead() async {
    await ChatUIKit.instance.markConversationAsRead(conversationId: profile.id);
  }

  Future<void> downloadMessage(Message message) async {
    ChatUIKit.instance.downloadAttachment(message: message);
  }
}

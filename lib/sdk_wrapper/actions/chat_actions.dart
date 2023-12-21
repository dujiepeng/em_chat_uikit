import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

mixin ChatActions on ChatWrapper {
  Future<Message> sendMessage({required Message message}) async {
    return checkResult(ChatSDKWrapperActionEvent.sendMessage, () async {
      return Client.getInstance.chatManager.sendMessage(message);
    });
  }

  Future<Message> resendMessage({required Message message}) async {
    return checkResult(ChatSDKWrapperActionEvent.sendMessage, () async {
      return Client.getInstance.chatManager.resendMessage(message);
    });
  }

  Future<bool> sendMessageReadAck({required Message message}) async {
    return checkResult(ChatSDKWrapperActionEvent.sendMessageReadAck, () async {
      return Client.getInstance.chatManager.sendMessageReadAck(message);
    });
  }

  Future<void> sendGroupMessageReadAck({
    required String msgId,
    required String groupId,
    String? content,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.sendGroupMessageReadAck,
        () async {
      return Client.getInstance.chatManager.sendGroupMessageReadAck(
        msgId,
        groupId,
        content: content,
      );
    });
  }

  Future<void> sendConversationReadAck({required String conversationId}) async {
    return checkResult(ChatSDKWrapperActionEvent.sendConversationReadAck,
        () async {
      return await Client.getInstance.chatManager.sendConversationReadAck(
        conversationId,
      );
    });
  }

  Future<void> recallMessage({required String messageId}) async {
    return checkResult(ChatSDKWrapperActionEvent.recallMessage, () async {
      return Client.getInstance.chatManager.recallMessage(messageId);
    });
  }

  Future<Message?> loadMessage({required String messageId}) async {
    return checkResult(ChatSDKWrapperActionEvent.loadMessage, () async {
      return Client.getInstance.chatManager.loadMessage(messageId);
    });
  }

  Future<Conversation> createConversation({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.createConversation, () async {
      Conversation? conv = await Client.getInstance.chatManager
          .getConversation(conversationId, type: type, createIfNeed: true);
      return conv!;
    });
  }

  Future<Conversation?> getConversation({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.getConversation, () async {
      Conversation? conv = await Client.getInstance.chatManager
          .getConversation(conversationId, type: type, createIfNeed: false);
      return conv;
    });
  }

  Future<Conversation?> getThreadConversation({
    required String conversationId,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.getThreadConversation,
        () async {
      return Client.getInstance.chatManager.getThreadConversation(
        conversationId,
      );
    });
  }

  Future<void> markAllConversationsAsRead() async {
    return checkResult(ChatSDKWrapperActionEvent.markAllConversationsAsRead,
        () async {
      Future<void> ret =
          Client.getInstance.chatManager.markAllConversationsAsRead();
      super.onConversationsUpdate();
      return ret;
    });
  }

  Future<void> markConversationAsRead({
    required String conversationId,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.markConversationAsRead,
        () async {
      Conversation? conv = await Client.getInstance.chatManager.getConversation(
        conversationId,
      );
      Future<void>? ret = conv?.markAllMessagesAsRead();
      super.onConversationsUpdate();
      return ret;
    });
  }

  Future<int> getUnreadMessageCount() async {
    return checkResult(ChatSDKWrapperActionEvent.getUnreadMessageCount,
        () async {
      return Client.getInstance.chatManager.getUnreadMessageCount();
    });
  }

  Future<void> updateMessage({required Message message}) async {
    return checkResult(ChatSDKWrapperActionEvent.updateMessage, () async {
      return Client.getInstance.chatManager.updateMessage(message);
    });
  }

  Future<void> importMessages({required List<Message> messages}) async {
    return checkResult(ChatSDKWrapperActionEvent.importMessages, () async {
      return Client.getInstance.chatManager.importMessages(messages);
    });
  }

  Future<void> insertMessage({required Message message}) async {
    return checkResult(ChatSDKWrapperActionEvent.importMessages, () async {
      Conversation? conversation =
          await Client.getInstance.chatManager.getConversation(
        message.conversationId ?? message.from!,
        type: ConversationType.values[message.chatType.index],
        createIfNeed: true,
      );
      await conversation!.insertMessage(message);
    });
  }

  Future<void> downloadAttachment({required Message message}) async {
    return checkResult(ChatSDKWrapperActionEvent.downloadAttachment, () async {
      return Client.getInstance.chatManager.downloadAttachment(message);
    });
  }

  Future<void> downloadThumbnail({required Message message}) async {
    return checkResult(ChatSDKWrapperActionEvent.downloadThumbnail, () async {
      return Client.getInstance.chatManager.downloadThumbnail(message);
    });
  }

  Future<List<Conversation>> getAllConversations() async {
    return checkResult(ChatSDKWrapperActionEvent.loadAllConversations,
        () async {
      return Client.getInstance.chatManager.loadAllConversations();
    });
  }

  Future<CursorResult<Conversation>> fetchConversations({
    String? cursor,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchConversations, () async {
      return Client.getInstance.chatManager.fetchConversation(
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<void> deleteRemoteMessagesWithIds({
    required String conversationId,
    required ConversationType type,
    required List<String> msgIds,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.deleteRemoteMessagesWithIds,
        () async {
      return Client.getInstance.chatManager.deleteRemoteMessagesWithIds(
        conversationId: conversationId,
        type: type,
        msgIds: msgIds,
      );
    });
  }

  Future<void> deleteRemoteMessagesBefore({
    required String conversationId,
    required ConversationType type,
    required int timestamp,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.deleteRemoteMessagesBefore,
        () async {
      return Client.getInstance.chatManager.deleteRemoteMessagesBefore(
        conversationId: conversationId,
        type: type,
        timestamp: timestamp,
      );
    });
  }

  Future<void> deleteLocalConversation({
    required String conversationId,
    bool deleteMessages = true,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.deleteLocalConversation,
        () async {
      await Client.getInstance.chatManager.deleteConversation(
        conversationId,
        deleteMessages: deleteMessages,
      );
    });
  }

  Future<CursorResult<Message>> fetchHistoryMessages({
    required String conversationId,
    required ConversationType type,
    FetchMessageOptions? options,
    String? cursor,
    int pageSize = 50,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchHistoryMessages,
        () async {
      return Client.getInstance.chatManager.fetchHistoryMessagesByOption(
        conversationId,
        type,
        options: options,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<List<Message>> searchLocalMessage({
    required String keywords,
    int timestamp = -1,
    int maxCount = 20,
    String? from,
    SearchDirection direction = SearchDirection.Up,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.searchLocalMessage, () async {
      return Client.getInstance.chatManager.searchMsgFromDB(
        keywords,
        timestamp: timestamp,
        maxCount: maxCount,
        from: from ?? '',
        direction: direction,
      );
    });
  }

  Future<CursorResult<GroupMessageAck>> fetchGroupAckList({
    required String msgId,
    required String groupId,
    String? startAckId,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupAckList, () async {
      return Client.getInstance.chatManager.fetchGroupAcks(
        msgId,
        groupId,
        startAckId: startAckId,
        pageSize: pageSize,
      );
    });
  }

  Future<void> deleteRemoteConversation({
    required String conversationId,
    required ConversationType type,
    bool isDeleteMessage = true,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.deleteRemoteConversation,
        () async {
      return Client.getInstance.chatManager.deleteRemoteConversation(
        conversationId,
        conversationType: type,
        isDeleteMessage: isDeleteMessage,
      );
    });
  }

  Future<void> deleteLocalMessages({required int beforeTime}) async {
    return checkResult(ChatSDKWrapperActionEvent.deleteLocalMessages, () async {
      return Client.getInstance.chatManager.deleteMessagesBefore(
        beforeTime,
      );
    });
  }

  Future<void> reportMessage({
    required String messageId,
    required String tag,
    required String reason,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.reportMessage, () async {
      return Client.getInstance.chatManager.reportMessage(
        messageId: messageId,
        tag: tag,
        reason: reason,
      );
    });
  }

  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.addReaction, () async {
      return Client.getInstance.chatManager.addReaction(
        messageId: messageId,
        reaction: reaction,
      );
    });
  }

  Future<void> deleteReaction({
    required String messageId,
    required String reaction,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.deleteReaction, () async {
      return Client.getInstance.chatManager.removeReaction(
        messageId: messageId,
        reaction: reaction,
      );
    });
  }

  Future<Map<String, List<MessageReaction>>> fetchReactionList({
    required List<String> messageIds,
    required ChatType type,
    String? groupId,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchReactionList, () async {
      return Client.getInstance.chatManager.fetchReactionList(
        messageIds: messageIds,
        chatType: type,
        groupId: groupId,
      );
    });
  }

  Future<CursorResult<MessageReaction>> fetchReactionDetail({
    required String messageId,
    required String reaction,
    String? cursor,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchReactionDetail, () async {
      return Client.getInstance.chatManager.fetchReactionDetail(
        messageId: messageId,
        reaction: reaction,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<Message> translateMessage({
    required Message msg,
    required List<String> languages,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.translateMessage, () async {
      return Client.getInstance.chatManager.translateMessage(
        msg: msg,
        languages: languages,
      );
    });
  }

  Future<List<TranslateLanguage>> fetchSupportedLanguages() async {
    return checkResult(ChatSDKWrapperActionEvent.fetchSupportedLanguages,
        () async {
      return Client.getInstance.chatManager.fetchSupportedLanguages();
    });
  }

  Future<CursorResult<Conversation>> fetchPinnedConversations({
    String? cursor,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchPinnedConversations,
        () async {
      return Client.getInstance.chatManager.fetchPinnedConversations(
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<void> pinConversation({
    required String conversationId,
    required bool isPinned,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.pinConversation, () async {
      await Client.getInstance.chatManager.pinConversation(
        conversationId: conversationId,
        isPinned: isPinned,
      );
      super.onConversationsUpdate();
    });
  }

  Future<Message> modifyMessage({
    required String messageId,
    required TextMessageBody msgBody,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.modifyMessage, () async {
      return Client.getInstance.chatManager.modifyMessage(
        messageId: messageId,
        msgBody: msgBody,
      );
    });
  }

  Future<List<Message>> fetchCombineMessageDetail({
    required Message message,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchCombineMessageDetail,
        () async {
      return Client.getInstance.chatManager.fetchCombineMessageDetail(
        message: message,
      );
    });
  }

  Future<List<Message>> getMessages({
    required String conversationId,
    required ConversationType type,
    SearchDirection direction = SearchDirection.Up,
    String? startId,
    int count = 30,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.getMessages, () async {
      final conversation = await createConversation(
        conversationId: conversationId,
        type: type,
      );
      return conversation.loadMessages(
        startMsgId: startId ?? '',
        loadCount: count,
        direction: direction,
      );
    });
  }

  Future<void> deleteLocalMessageById({
    required String conversationId,
    required ConversationType type,
    required String messageId,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.getMessages, () async {
      final conversation = await getConversation(
        conversationId: conversationId,
        type: type,
      );
      return conversation!.deleteMessage(messageId);
    });
  }
}

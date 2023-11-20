import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatActions on ChatWrapper {
  Future<Message> sendMessage({required Message message}) async {
    return Client.getInstance.chatManager.sendMessage(message);
  }

  Future<Message> resendMessage({required Message message}) async {
    return Client.getInstance.chatManager.resendMessage(message);
  }

  Future<bool> sendMessageReadAck({required Message message}) async {
    return Client.getInstance.chatManager.sendMessageReadAck(message);
  }

  Future<void> sendGroupMessageReadAck({
    required String msgId,
    required String groupId,
    String? content,
  }) async {
    return Client.getInstance.chatManager.sendGroupMessageReadAck(
      msgId,
      groupId,
      content: content,
    );
  }

  Future<void> sendConversationReadAck({required String conversationId}) async {
    await Client.getInstance.chatManager.sendConversationReadAck(
      conversationId,
    );
  }

  Future<void> recallMessage({required String messageId}) async {
    return Client.getInstance.chatManager.recallMessage(messageId);
  }

  Future<Message?> loadMessage({required String messageId}) async {
    return Client.getInstance.chatManager.loadMessage(messageId);
  }

  Future<Conversation?> createConversation({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
  }) {
    return Client.getInstance.chatManager.getConversation(
      conversationId,
      type: type,
    );
  }

  Future<Conversation?> getThreadConversation({
    required String conversationId,
  }) {
    return Client.getInstance.chatManager.getThreadConversation(
      conversationId,
    );
  }

  Future<void> markAllConversationsAsRead() async {
    return Client.getInstance.chatManager.markAllConversationsAsRead();
  }

  Future<int> getUnreadMessageCount() async {
    return Client.getInstance.chatManager.getUnreadMessageCount();
  }

  Future<void> updateMessage({required Message message}) async {
    return Client.getInstance.chatManager.updateMessage(message);
  }

  Future<void> importMessages({required List<Message> messages}) async {
    return Client.getInstance.chatManager.importMessages(messages);
  }

  Future<void> downloadAttachment({required Message message}) async {
    return Client.getInstance.chatManager.downloadAttachment(message);
  }

  Future<void> downloadThumbnail({required Message message}) async {
    return Client.getInstance.chatManager.downloadThumbnail(message);
  }

  Future<List<Conversation>> getAllConversations() async {
    return Client.getInstance.chatManager.loadAllConversations();
  }

  Future<CursorResult<Conversation>> fetchConversation({
    String? cursor,
    int pageSize = 20,
  }) async {
    return Client.getInstance.chatManager.fetchConversation(
      cursor: cursor,
      pageSize: pageSize,
    );
  }

  Future<void> deleteRemoteMessagesWithIds({
    required String conversationId,
    required ConversationType type,
    required List<String> msgIds,
  }) async {
    return Client.getInstance.chatManager.deleteRemoteMessagesWithIds(
      conversationId: conversationId,
      type: type,
      msgIds: msgIds,
    );
  }

  Future<void> deleteRemoteMessagesBefore({
    required String conversationId,
    required ConversationType type,
    required int timestamp,
  }) async {
    return Client.getInstance.chatManager.deleteRemoteMessagesBefore(
      conversationId: conversationId,
      type: type,
      timestamp: timestamp,
    );
  }

  Future<void> deleteLocalConversation({
    required String conversationId,
    bool deleteMessages = true,
  }) async {
    await Client.getInstance.chatManager.deleteConversation(
      conversationId,
      deleteMessages: deleteMessages,
    );
  }

  // Future<CursorResult<Message>> fetchHistoryMessages({
  //   required String conversationId,
  //   EMConversationType type = EMConversationType.Chat,
  //   int pageSize = 20,
  //   EMSearchDirection direction = EMSearchDirection.Up,
  //   String? startMsgId,
  // }) async {
  //   return Client.getInstance.chatManager.fetchHistoryMessages(
  //     conversationId: conversationId,
  //     type: type,
  //     pageSize: pageSize,
  //     direction: direction,
  //     startMsgId: startMsgId ?? '',
  //   );
  // }

  Future<CursorResult<Message>> fetchHistoryMessages({
    required String conversationId,
    required EMConversationType type,
    FetchMessageOptions? options,
    String? cursor,
    int pageSize = 50,
  }) async {
    return Client.getInstance.chatManager.fetchHistoryMessagesByOption(
      conversationId,
      type,
      options: options,
      cursor: cursor,
      pageSize: pageSize,
    );
  }

  Future<List<Message>> searchLocalMessage({
    required String keywords,
    int timestamp = -1,
    int maxCount = 20,
    String? from,
    EMSearchDirection direction = EMSearchDirection.Up,
  }) async {
    return Client.getInstance.chatManager.searchMsgFromDB(
      keywords,
      timestamp: timestamp,
      maxCount: maxCount,
      from: from ?? '',
      direction: direction,
    );
  }

  Future<CursorResult<GroupMessageAck>> fetchGroupAckList({
    required String msgId,
    required String groupId,
    String? startAckId,
    int pageSize = 20,
  }) async {
    return Client.getInstance.chatManager.fetchGroupAcks(
      msgId,
      groupId,
      startAckId: startAckId,
      pageSize: pageSize,
    );
  }

  Future<void> deleteRemoteConversation({
    required String conversationId,
    required ConversationType type,
    bool isDeleteMessage = true,
  }) async {
    return Client.getInstance.chatManager.deleteRemoteConversation(
      conversationId,
      conversationType: type,
      isDeleteMessage: isDeleteMessage,
    );
  }

  Future<void> deleteLocalMessages(int beforeTime) async {
    return Client.getInstance.chatManager.deleteMessagesBefore(
      beforeTime,
    );
  }

  Future<void> reportMessage({
    required String messageId,
    required String tag,
    required String reason,
  }) async {
    return Client.getInstance.chatManager.reportMessage(
      messageId: messageId,
      tag: tag,
      reason: reason,
    );
  }

  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    return Client.getInstance.chatManager.addReaction(
      messageId: messageId,
      reaction: reaction,
    );
  }

  Future<void> deleteReaction({
    required String messageId,
    required String reaction,
  }) async {
    return Client.getInstance.chatManager.removeReaction(
      messageId: messageId,
      reaction: reaction,
    );
  }

  Future<Map<String, List<MessageReaction>>> fetchReactionList({
    required List<String> messageIds,
    required ChatType type,
    String? groupId,
  }) async {
    return Client.getInstance.chatManager.fetchReactionList(
      messageIds: messageIds,
      chatType: type,
      groupId: groupId,
    );
  }

  Future<CursorResult<MessageReaction>> fetchReactionDetail({
    required String messageId,
    required String reaction,
    String? cursor,
    int pageSize = 20,
  }) async {
    return Client.getInstance.chatManager.fetchReactionDetail(
      messageId: messageId,
      reaction: reaction,
      cursor: cursor,
      pageSize: pageSize,
    );
  }

  Future<Message> translateMessage({
    required Message msg,
    required List<String> languages,
  }) async {
    return Client.getInstance.chatManager.translateMessage(
      msg: msg,
      languages: languages,
    );
  }

  Future<List<TranslateLanguage>> fetchSupportedLanguages() async {
    return Client.getInstance.chatManager.fetchSupportedLanguages();
  }

  Future<CursorResult<Conversation>> fetchPinnedConversations({
    String? cursor,
    int pageSize = 20,
  }) async {
    return Client.getInstance.chatManager.fetchPinnedConversations(
      cursor: cursor,
      pageSize: pageSize,
    );
  }

  Future<void> pinConversation({
    required String conversationId,
    required bool isPinned,
  }) async {
    return Client.getInstance.chatManager.pinConversation(
      conversationId: conversationId,
      isPinned: isPinned,
    );
  }

  Future<Message> modifyMessage({
    required String messageId,
    required TextMessageBody msgBody,
  }) async {
    return Client.getInstance.chatManager.modifyMessage(
      messageId: messageId,
      msgBody: msgBody,
    );
  }

  Future<List<Message>> fetchCombineMessageDetail({
    required Message message,
  }) async {
    return Client.getInstance.chatManager.fetchCombineMessageDetail(
      message: message,
    );
  }
}

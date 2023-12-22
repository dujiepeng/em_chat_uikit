import 'package:em_chat_uikit/chat_uikit.dart';

class ChatUIKitInsertMessageTool {
  static insertCreateGroupMessage({
    required Group group,
    ChatUIKitProfile? creator,
    int? timestamp,
  }) async {
    int time = timestamp ?? DateTime.now().millisecondsSinceEpoch - 1;
    Message timeMsg = Message.createCustomSendMessage(
      targetId: group.groupId,
      event: alertTimeMessageEventKey,
      chatType: ChatType.GroupChat,
    );
    timeMsg.serverTime = time;
    timeMsg.localTime = time;
    timeMsg.status = MessageStatus.SUCCESS;

    await ChatUIKit.instance.insertMessage(
      message: timeMsg,
    );
    Message alertMsg = Message.createCustomSendMessage(
      targetId: group.groupId,
      event: alertCreateGroupMessageEventKey,
      chatType: ChatType.GroupChat,
      params: {
        alertCreateGroupMessageOwnerKey: creator?.showName ?? group.owner ?? '',
        alertCreateGroupMessageGroupNameKey: group.name ?? group.groupId,
      },
    );
    alertMsg.conversationId = group.groupId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    await ChatUIKit.instance.insertMessage(message: alertMsg);
  }

  static Message insertRecallMessage({
    required String conversationId,
    required ConversationType type,
    required String messageId,
    String? info,
    int? timestamp,
  }) {
    int time = timestamp ?? DateTime.now().millisecondsSinceEpoch - 1;

    Message alertMsg = Message.createCustomSendMessage(
      targetId: conversationId,
      event: alertRecallNameKey,
      chatType: ChatType.values[type.index],
      params: {
        alertRecallNameKey: info ?? '',
      },
    );
    alertMsg.conversationId = conversationId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(message: alertMsg);
    return alertMsg;
  }
}
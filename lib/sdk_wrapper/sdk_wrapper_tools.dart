import 'package:em_chat_uikit/chat_uikit.dart';

class SDKWrapperTools {
  static Message insertRecallMessage({
    required Message recalledMessage,
    int? timestamp,
  }) {
    int time = timestamp ?? recalledMessage.serverTime;
    Message alertMsg = Message.createCustomSendMessage(
      targetId: recalledMessage.conversationId!,
      event: alertRecalledKey,
      chatType: recalledMessage.chatType,
      params: {
        if (recalledMessage.bodyType == MessageType.TXT)
          alertRecallInfoKey: recalledMessage.textContent,
        alertRecallMessageTypeKey: recalledMessage.bodyType.index.toString(),
        alertRecallMessageDirectionKey: recalledMessage.direction.index.toString(),
      },
    );
    alertMsg.conversationId = recalledMessage.conversationId;
    alertMsg.serverTime = time;
    alertMsg.localTime = time;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(message: alertMsg);
    return alertMsg;
  }
}

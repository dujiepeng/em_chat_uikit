import 'package:em_chat_uikit/chat_uikit.dart';

abstract mixin class ChatObserver implements ChatUIKitObserverBase {
  void onMessagesReceived(List<Message> messages) {}
  void onCmdMessagesReceived(List<Message> messages) {}
  void onMessagesRead(List<Message> messages) {}
  void onGroupMessageRead(List<GroupMessageAck> groupMessageAcks) {}
  void onReadAckForGroupMessageUpdated() {}
  void onMessagesDelivered(List<Message> messages) {}
  void onMessagesRecalled(List<Message> messages) {}
  void onConversationsUpdate() {}
  void onConversationRead(String from, String to) {}
  void onMessageReactionDidChange(List<MessageReactionEvent> events) {}
  void onMessageContentChanged(
      Message message, String operatorId, int operationTime) {}
}

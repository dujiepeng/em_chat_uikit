import 'package:flutter/foundation.dart';
import '../chat_sdk_wrapper.dart';

mixin ChatWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatManager.addEventHandler(
      sdkEventKey,
      ChatEventHandle(
        onMessagesReceived: onMessagesReceived,
        onCmdMessagesReceived: onCmdMessagesReceived,
        onMessagesRead: onMessagesRead,
        onGroupMessageRead: onGroupMessageRead,
        onReadAckForGroupMessageUpdated: onReadAckForGroupMessageUpdated,
        onMessagesDelivered: onMessagesDelivered,
        onMessagesRecalled: onMessagesRecalled,
        onConversationsUpdate: onConversationsUpdate,
        onConversationRead: onConversationRead,
        onMessageReactionDidChange: onMessageReactionDidChange,
        onMessageContentChanged: onMessageContentChanged,
      ),
    );
  }

  @protected
  void onCmdMessagesReceived(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onCmdMessagesReceived(messages);
    }
  }

  @protected
  void onMessagesRead(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onMessagesRead(messages);
    }
  }

  @protected
  void onGroupMessageRead(List<GroupMessageAck> groupMessageAcks) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onGroupMessageRead(groupMessageAcks);
    }
  }

  @protected
  void onReadAckForGroupMessageUpdated() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onReadAckForGroupMessageUpdated();
    }
  }

  @protected
  void onMessagesDelivered(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onMessagesDelivered(messages);
    }
  }

  @protected
  void onMessagesRecalled(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onMessagesRecalled(messages);
    }
  }

  void onConversationsUpdate() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onConversationsUpdate();
    }
  }

  @protected
  void onConversationRead(String from, String to) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onConversationRead(from, to);
    }
  }

  @protected
  void onMessageReactionDidChange(List<MessageReactionEvent> events) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onMessageReactionDidChange(events);
    }
  }

  @protected
  void onMessageContentChanged(
      Message message, String operatorId, int operationTime) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver)
          .onMessageContentChanged(message, operatorId, operationTime);
    }
  }

  @protected
  void onMessagesReceived(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ChatObserver).onMessagesReceived(messages);
    }
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';

mixin MultiWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.addMultiDeviceEventHandler(
      sdkEventKey,
      MultiDeviceEventHandler(
        onContactEvent: _onContactEvent,
        onGroupEvent: _onGroupEvent,
        onChatThreadEvent: _onChatThreadEvent,
        onRemoteMessagesRemoved: _onRemoteMessagesRemoved,
        onConversationEvent: _onConversationEvent,
      ),
    );
  }

  void _onContactEvent(MultiDevicesEvent event, String userId, String? ext) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MultiObserver).onContactEvent(event, userId, ext);
    }
  }

  void _onGroupEvent(
      MultiDevicesEvent event, String groupId, List<String>? userIds) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MultiObserver).onGroupEvent(event, groupId, userIds);
    }
  }

  void _onChatThreadEvent(
      MultiDevicesEvent event, String chatThreadId, List<String> userIds) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MultiObserver)
          .onChatThreadEvent(event, chatThreadId, userIds);
    }
  }

  void _onRemoteMessagesRemoved(String conversationId, String deviceId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MultiObserver)
          .onRemoteMessagesRemoved(conversationId, deviceId);
    }
  }

  void _onConversationEvent(
      MultiDevicesEvent event, String conversationId, ConversationType type) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MultiObserver)
          .onConversationEvent(event, conversationId, type);
    }
  }
}

extension MultiWrapperAction on MultiWrapper {}

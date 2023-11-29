import 'package:flutter/foundation.dart';
import '../chat_sdk_wrapper.dart';

mixin MultiWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.addMultiDeviceEventHandler(
      sdkEventKey,
      MultiDeviceEventHandler(
        onContactEvent: onContactEvent,
        onGroupEvent: onGroupEvent,
        onChatThreadEvent: onChatThreadEvent,
        onRemoteMessagesRemoved: onRemoteMessagesRemoved,
        onConversationEvent: onConversationEvent,
      ),
    );
  }

  @protected
  void onContactEvent(MultiDevicesEvent event, String userId, String? ext) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MultiObserver) {
        observer.onContactEvent(event, userId, ext);
      }
    }
  }

  @protected
  void onGroupEvent(
      MultiDevicesEvent event, String groupId, List<String>? userIds) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MultiObserver) {
        observer.onGroupEvent(event, groupId, userIds);
      }
    }
  }

  @protected
  void onChatThreadEvent(
      MultiDevicesEvent event, String chatThreadId, List<String> userIds) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MultiObserver) {
        observer.onChatThreadEvent(event, chatThreadId, userIds);
      }
    }
  }

  @protected
  void onRemoteMessagesRemoved(String conversationId, String deviceId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MultiObserver) {
        observer.onRemoteMessagesRemoved(conversationId, deviceId);
      }
    }
  }

  @protected
  void onConversationEvent(
      MultiDevicesEvent event, String conversationId, ConversationType type) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is MultiObserver) {
        observer.onConversationEvent(event, conversationId, type);
      }
    }
  }
}

extension MultiWrapperAction on MultiWrapper {}

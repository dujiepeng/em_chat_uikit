import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';

mixin ContactWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.contactManager.addEventHandler(
      sdkEventKey,
      ContactEventHandler(
        onContactAdded: onContactAdded,
        onContactDeleted: onContactDeleted,
        onContactInvited: onContactInvited,
        onFriendRequestAccepted: onFriendRequestAccepted,
        onFriendRequestDeclined: onFriendRequestDeclined,
      ),
    );
  }

  @protected
  void onContactAdded(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ContactObserver).onContactAdded(userId);
    }
  }

  @protected
  void onContactDeleted(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ContactObserver).onContactDeleted(userId);
    }
  }

  @protected
  void onContactInvited(String userId, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ContactObserver).onContactInvited(userId, reason);
    }
  }

  @protected
  void onFriendRequestAccepted(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ContactObserver).onFriendRequestAccepted(userId);
    }
  }

  @protected
  void onFriendRequestDeclined(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ContactObserver).onFriendRequestDeclined(userId);
    }
  }
}

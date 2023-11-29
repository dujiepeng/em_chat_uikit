import 'package:flutter/foundation.dart';
import '../chat_sdk_wrapper.dart';

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
        onContactInvited: onReceiveFriendRequest,
        onFriendRequestAccepted: onFriendRequestAccepted,
        onFriendRequestDeclined: onFriendRequestDeclined,
      ),
    );
  }

  @protected
  void onContactAdded(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onContactAdded(userId);
      }
    }
  }

  @protected
  void onContactDeleted(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onContactDeleted(userId);
      }
    }
  }

  @protected
  void onReceiveFriendRequest(String userId, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onReceiveFriendRequest(userId, reason);
      }
    }
  }

  @protected
  void onFriendRequestAccepted(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onFriendRequestAccepted(userId);
      }
    }
  }

  @protected
  void onFriendRequestDeclined(String userId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ContactObserver) {
        observer.onFriendRequestDeclined(userId);
      }
    }
  }
}

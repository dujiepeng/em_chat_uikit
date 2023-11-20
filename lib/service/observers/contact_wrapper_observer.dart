import 'package:em_chat_uikit/chat_uikit.dart';
abstract mixin class ContactObserver implements ChatUIKitObserverBase {
  void onContactAdded(String userId) {}
  void onContactDeleted(String userId) {}
  void onContactInvited(String userId, String? reason) {}
  void onFriendRequestAccepted(String userId) {}
  void onFriendRequestDeclined(String userId) {}
}

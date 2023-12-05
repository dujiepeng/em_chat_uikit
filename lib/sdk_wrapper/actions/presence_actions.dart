import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

mixin PresenceActions on PresenceWrapper {
  Future<void> publishPresence(
    String description,
  ) {
    return checkResult(ChatSDKWrapperActionEvent.getGroupId, () {
      return Client.getInstance.presenceManager.publishPresence(description);
    });
  }

  Future<List<Presence>> subscribe({
    required List<String> members,
    required int expiry,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.subscribe, () {
      return Client.getInstance.presenceManager.subscribe(
        members: members,
        expiry: expiry,
      );
    });
  }

  Future<void> unsubscribe({
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.unsubscribe, () {
      return Client.getInstance.presenceManager.unsubscribe(members: members);
    });
  }

  Future<List<String>> fetchSubscribedMembers({
    int pageNum = 1,
    int pageSize = 20,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchSubscribedMembers, () {
      return Client.getInstance.presenceManager.fetchSubscribedMembers(
        pageNum: pageNum,
        pageSize: pageSize,
      );
    });
  }

  Future<List<Presence>> fetchPresenceStatus({
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchPresenceStatus, () {
      return Client.getInstance.presenceManager.fetchPresenceStatus(
        members: members,
      );
    });
  }
}

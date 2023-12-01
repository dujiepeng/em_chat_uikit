import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitContactActions on ChatSDKWrapper {
  @override
  Future<void> acceptContactRequest({required String userId}) async {
    await super.acceptContactRequest(userId: userId);
    ChatUIKitContext.instance.removeRequest(userId);
  }

  @override
  Future<void> declineContactRequest({required String userId}) async {
    await super.declineContactRequest(userId: userId);
    ChatUIKitContext.instance.removeRequest(userId);
  }
}

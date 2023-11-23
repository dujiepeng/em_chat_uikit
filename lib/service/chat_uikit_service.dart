import 'package:em_chat_uikit/chat_uikit.dart';

class ChatUIKit extends ChatSDKWrapper {
  static ChatUIKit? _instance;
  static ChatUIKit get instance {
    return _instance ??= ChatUIKit();
  }

  ChatUIKit() : super() {
    ChatUIKitContext.instance;
    ChatUIKitContext.instance.currentUserId = currentUserId();
  }

  @override
  Future<void> login({
    required String userId,
    required String password,
  }) async {
    try {
      await super.login(userId: userId, password: password);
      ChatUIKitContext.instance.currentUserId = userId;
    } catch (e) {
      rethrow;
    }
  }
}

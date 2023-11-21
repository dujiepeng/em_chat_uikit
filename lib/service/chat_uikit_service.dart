import 'package:em_chat_uikit/chat_uikit.dart';

import 'custom/chat_uikit_notification_wrapper.dart';

class ChatUIKit extends ChatSDKWrapper with CustomNotificationActions {
  static ChatUIKit? _instance;
  static ChatUIKit get instance {
    return _instance ??= ChatUIKit();
  }

  ChatUIKit() : super() {
    ChatUIKitContext.instance;
  }
}

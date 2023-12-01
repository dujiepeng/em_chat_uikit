import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitContactObservers on ChatSDKWrapper {
  @override
  void onReceiveFriendRequest(String userId, String? reason) {
    // 回调好友通知之前需要先存储好友请求数据
    if (ChatUIKitContext.instance.addRequest(userId, reason)) {
      super.onReceiveFriendRequest(userId, reason);
    }
  }
}

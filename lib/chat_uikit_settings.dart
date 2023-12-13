import 'package:em_chat_uikit/chat_uikit.dart';

class ChatUIKitSettings {
  static CornerRadius inputBarRadius = CornerRadius.large;
  static CornerRadius avatarRadius = CornerRadius.large;
  static CornerRadius searchBarRadius = ChatUIKitSettings.avatarRadius;
  static CornerRadius alertRadius = CornerRadius.medium;
  static ChatUIKitRectangleType alertRectangleType =
      ChatUIKitRectangleType.filletCorner;

  static bool showConversationListAvatar = true;
  static String? conversationListMuteImage;

  /// 时间显示间隔时长
  static int timeLabelDisplayIntervalDuration = 300;
}

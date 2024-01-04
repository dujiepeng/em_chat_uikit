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

  /// 撤回消息的时间限制，单位秒
  static int recallExpandTime = 120;

  static List<String> reportReason = [
    '不受欢迎的商业内容或垃圾内容',
    '色情或露骨内容,',
    '虐待儿童',
    '仇恨言论或过于写实的暴力内容',
    '宣扬恐怖主义',
    '骚扰或欺凌',
    '自杀或自残',
    '虚假信息',
    '其他'
  ];
}

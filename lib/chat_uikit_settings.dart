import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

enum CornerRadius { extraSmall, small, medium, large }

class ChatUIKitSettings {
  static CornerRadius avatarRadius = CornerRadius.medium;
  static CornerRadius searchBarRadius = ChatUIKitSettings.avatarRadius;
  static String? avatarPlaceholder;
  static CornerRadius alertRadius = CornerRadius.medium;
  static ChatUIKitRectangleType alertRectangleType =
      ChatUIKitRectangleType.filletCorner;

  static bool showConversationListAvatar = true;
  static bool showConversationListUnreadCount = true;
  static String? conversationListMuteImage;

  /// 撤回消息的时间限制，单位秒
  static int recallExpandTime = 120;

  static Map<String, String> reportMessageReason(BuildContext context) {
    return {
      'tag1': '不受欢迎的商业内容或垃圾内容',
      'tag2': '色情或露骨内容',
      'tag3': '虐待儿童',
      'tag4': '仇恨言论或过于写实的暴力内容',
      'tag5': '宣扬恐怖主义',
      'tag6': '骚扰或欺凌',
      'tag7': '自杀或自残',
      'tag8': '虚假信息',
      'tag9': '其他',
    };
  }
}

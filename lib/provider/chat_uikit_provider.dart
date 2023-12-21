import 'package:em_chat_uikit/chat_uikit.dart';

typedef ChatUIKitProviderGroupMembersHandler = List<ChatUIKitProfile> Function(
    String groupId, List<ChatUIKitProfile> profiles);

typedef ChatUIKitProviderContactsHandler = List<ChatUIKitProfile> Function(
  List<ChatUIKitProfile> profiles,
);

typedef ChatUIKitProviderConversationsHandler = List<ChatUIKitProfile> Function(
  List<ChatUIKitProfile> profiles,
);

class ChatUIKitProvider {
  static ChatUIKitProvider? _instance;
  static ChatUIKitProvider get instance {
    _instance ??= ChatUIKitProvider._internal();
    return _instance!;
  }

  ChatUIKitProvider._internal();

  ChatUIKitProviderGroupMembersHandler? groupMembersHandler;
  ChatUIKitProviderContactsHandler? contactsHandler;
  ChatUIKitProviderConversationsHandler? conversationsHandler;

  ChatUIKitProfile conversationProfile(
      String conversationId, ConversationType type) {
    ChatUIKitProfile? profile =
        ChatUIKitContext.instance.conversationsCache[conversationId];
    if (profile == null) {
      if (type == ConversationType.GroupChat) {
        profile = ChatUIKitProfile.groupChat(id: conversationId);
      } else {
        profile = ChatUIKitProfile.singleChat(id: conversationId);
      }
      List<ChatUIKitProfile>? list = conversationsHandler?.call([profile]);
      if (list?.isNotEmpty == true) {
        var result = {for (var element in list!) element.id: element};
        ChatUIKitContext.instance.conversationsCache.addAll(result);
        profile = result[profile.id] ?? profile;
      }
    }
    return profile;
  }

  ChatUIKitProfile contactProfile(String userId) {
    ChatUIKitProfile? profile = ChatUIKitContext.instance.contactsCache[userId];
    if (profile == null) {
      profile = ChatUIKitProfile.contact(id: userId);
      List<ChatUIKitProfile>? list = contactsHandler?.call([profile]);
      if (list?.isNotEmpty == true) {
        var result = {for (var element in list!) element.id: element};
        ChatUIKitContext.instance.contactsCache.addAll(result);
        profile = result[profile.id] ?? profile;
      }
    }
    return profile;
  }

  ChatUIKitProfile groupMemberProfile(String groupId, String userId) {
    if (ChatUIKitContext.instance.groupMembersCache[groupId] == null) {
      ChatUIKitContext.instance.groupMembersCache[groupId] = {};
    }

    ChatUIKitProfile? profile =
        ChatUIKitContext.instance.groupMembersCache[groupId]?[userId];

    if (profile == null) {
      profile = ChatUIKitProfile.groupMember(id: userId);
      List<ChatUIKitProfile>? list =
          groupMembersHandler?.call(groupId, [profile]);
      if (list?.isNotEmpty == true) {
        var result = {for (var element in list!) element.id: element};
        ChatUIKitContext.instance.groupMembersCache[groupId]?.addAll(result);
        profile = result[profile.id] ?? profile;
      }
    }
    return profile;
  }
}

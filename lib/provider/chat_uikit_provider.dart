import 'package:em_chat_uikit/chat_uikit.dart';

abstract mixin class ChatUIKitProviderObserver {
  void onContactProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {}

  void onConversationProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {}

  void onGroupMemberProfilesUpdate(
    String groupId,
    Map<String, ChatUIKitProfile> map,
  ) {}
}

typedef ChatUIKitProviderGroupMembersHandler = List<ChatUIKitProfile>? Function(
    String groupId, List<ChatUIKitProfile> profiles);

typedef ChatUIKitProviderContactsHandler = List<ChatUIKitProfile>? Function(
  List<ChatUIKitProfile> profiles,
);

typedef ChatUIKitProviderConversationsHandler = List<ChatUIKitProfile>?
    Function(
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

  // 缓存 profile, 不需要存；
  final Map<String, ChatUIKitProfile> _conversationsCache = {};
  // 缓存 profile, 不需要存；
  final Map<String, ChatUIKitProfile> _contactsCache = {};
// 缓存 profile, 不需要存；
  final Map<String, Map<String, ChatUIKitProfile>> _groupMembersCache = {};

  final List<ChatUIKitProviderObserver> _observers = [];

  UserData? currentUserData;

  void addObserver(ChatUIKitProviderObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(ChatUIKitProviderObserver observer) {
    _observers.remove(observer);
  }

  void clearAllObservers() {
    _observers.clear();
  }

  void clearContactCache() {
    _contactsCache.clear();
  }

  void clearConversationCache() {
    _conversationsCache.clear();
  }

  void clearGroupMemberCache() {
    _groupMembersCache.clear();
  }

  void clearAllCache() {
    _contactsCache.clear();
    _conversationsCache.clear();
    _groupMembersCache.clear();
  }

  Map<String, ChatUIKitProfile> conversationProfiles(
      Map<String, ConversationType> map) {
    List<ChatUIKitProfile> ret = [];
    List<ChatUIKitProfile> needProviders = [];
    for (var conversationId in map.keys) {
      ChatUIKitProfile? profile = _conversationsCache[conversationId];
      if (profile == null) {
        if (map[conversationId] == ConversationType.GroupChat) {
          profile = ChatUIKitProfile.groupChat(id: conversationId);
        } else {
          profile = ChatUIKitProfile.singleChat(id: conversationId);
        }
        needProviders.add(profile);
      }
      ret.add(profile);
    }

    if (needProviders.isNotEmpty) {
      List<ChatUIKitProfile>? tmp = conversationsHandler?.call(needProviders);
      if (tmp?.isNotEmpty == true) {
        var result = {for (var element in tmp!) element.id: element};
        _conversationsCache.addAll(result);
        ret.removeWhere((element) => result.keys.contains(element.id));
        ret.addAll(result.values);
      }
    }

    return {for (var element in ret) element.id: element};
  }

  ChatUIKitProfile conversationProfile(
    String conversationId,
    ConversationType type,
  ) {
    ChatUIKitProfile? profile = _conversationsCache[conversationId];
    if (profile == null) {
      if (type == ConversationType.GroupChat) {
        profile = ChatUIKitProfile.groupChat(id: conversationId);
      } else {
        profile = ChatUIKitProfile.singleChat(id: conversationId);
      }
      conversationsHandler?.call([profile]);
    }
    return profile;
  }

  Map<String, ChatUIKitProfile> contactProfiles(List<String> list) {
    List<ChatUIKitProfile> ret = [];
    List<ChatUIKitProfile> needProviders = [];
    for (var userId in list) {
      ChatUIKitProfile? profile = _contactsCache[userId];
      if (profile == null) {
        profile = ChatUIKitProfile.contact(id: userId);
        needProviders.add(profile);
      }
      ret.add(profile);
    }

    if (needProviders.isNotEmpty) {
      List<ChatUIKitProfile>? tmp = contactsHandler?.call(needProviders);
      if (tmp?.isNotEmpty == true) {
        var result = {for (var element in tmp!) element.id: element};
        _contactsCache.addAll(result);
        ret.removeWhere((element) => result.keys.contains(element.id));
        ret.addAll(result.values);
      }
    }

    return {for (var element in ret) element.id: element};
  }

  ChatUIKitProfile contactProfile(String userId) {
    Map<String, ChatUIKitProfile> map = contactProfiles([userId]);
    return map.values.first;
  }

  Map<String, ChatUIKitProfile> groupMemberProfiles(
      String groupId, List<String> list) {
    List<ChatUIKitProfile> ret = [];
    List<ChatUIKitProfile> needProviders = [];
    for (var userId in list) {
      if (_groupMembersCache[groupId] == null) {
        _groupMembersCache[groupId] = {};
      }
      ChatUIKitProfile? profile = _groupMembersCache[groupId]![userId];
      if (profile == null) {
        profile = ChatUIKitProfile.groupMember(id: userId);
        needProviders.add(profile);
      }
      ret.add(profile);
    }

    if (needProviders.isNotEmpty) {
      List<ChatUIKitProfile>? tmp =
          groupMembersHandler?.call(groupId, needProviders);
      if (tmp?.isNotEmpty == true) {
        var result = {for (var element in tmp!) element.id: element};
        _groupMembersCache[groupId] = result;
        ret.removeWhere((element) => result.keys.contains(element.id));
        ret.addAll(result.values);
      }
    }

    return {for (var element in ret) element.id: element};
  }

  ChatUIKitProfile groupMemberProfile(String groupId, String userId) {
    Map<String, ChatUIKitProfile> map = groupMemberProfiles(groupId, [userId]);
    return map.values.first;
  }

  void addContactProfiles(List<ChatUIKitProfile> list) {
    var result = {for (var element in list) element.id: element};
    _contactsCache.addAll(result);

    for (var observer in _observers) {
      observer.onContactProfilesUpdate(result);
    }
  }

  void addConversationProfiles(List<ChatUIKitProfile> list) {
    var result = {for (var element in list) element.id: element};
    _conversationsCache.addAll(result);

    for (var observer in _observers) {
      observer.onConversationProfilesUpdate(result);
    }
  }

  void addGroupMemberProfiles(String groupId, List<ChatUIKitProfile> list) {
    var result = {for (var element in list) element.id: element};
    _groupMembersCache[groupId]?.addAll(result);

    for (var observer in _observers) {
      observer.onGroupMemberProfilesUpdate(groupId, result);
    }
  }
}

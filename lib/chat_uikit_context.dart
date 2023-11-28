import 'dart:convert';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String convLoadFinishedKey =
    'EaseChatUIKit_conversation_load_more_finished';
const String contactLoadFinishedKey =
    'EaseChatUIKit_contact_load_more_finished';
const String muteMapKey = 'EaseChatUIKit_conversation_mute_map';

class ChatUIKitContext {
  late SharedPreferences sharedPreferences;
  String? _currentUserId;
  Map<String, dynamic> cachedMap = {};
  Map<String, ChatUIKitProfile> conversationsCache = {};
  Map<String, ChatUIKitProfile> contactsCache = {};
  ChatUIKitProfile? currentUserProfile;

  static ChatUIKitContext? _instance;
  static ChatUIKitContext get instance {
    _instance ??= ChatUIKitContext._internal();
    return _instance!;
  }

  set currentUserId(String? userId) {
    if (_currentUserId != userId) {
      cachedMap.clear();
    }
    _currentUserId = userId;
    if (_currentUserId?.isNotEmpty == true) {
      String? cache = sharedPreferences.getString(_currentUserId!);
      if (cache != null) {
        cachedMap = json.decode(cache);
      }
    }
  }

  ChatUIKitContext._internal() {
    init();
  }

  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void _updateStore() {
    sharedPreferences.setString(_currentUserId!, json.encode(cachedMap));
  }
}

extension ContactLoad on ChatUIKitContext {
  bool isContactLoadFinished() {
    return cachedMap[contactLoadFinishedKey] ??= false;
  }

  void setContactLoadFinished() {
    cachedMap[contactLoadFinishedKey] = true;
    _updateStore();
  }
}

extension ConversationFirstLoad on ChatUIKitContext {
  bool isConversationLoadFinished() {
    return cachedMap[convLoadFinishedKey] ??= false;
  }

  void setConversationLoadFinished() {
    cachedMap[convLoadFinishedKey] = true;
    _updateStore();
  }
}

extension ConversationMute on ChatUIKitContext {
  void addConversationMute(Map<String, int> map) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    tmpMap.addAll(map);
    cachedMap[muteMapKey] = tmpMap;
    _updateStore();
  }

  bool conversationIsMute(String conversationId) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    return tmpMap?.containsKey(conversationId) ?? false;
  }

  void deleteConversationMute(List<String> list) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    for (var element in list) {
      tmpMap.remove(element);
    }
    cachedMap[muteMapKey] = tmpMap;
    _updateStore();
  }
}

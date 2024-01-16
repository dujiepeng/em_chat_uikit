import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:em_chat_uikit_example/pages/tool/remote_avatars.dart';
import 'package:flutter/material.dart';

class UserProviderWidget extends StatefulWidget {
  const UserProviderWidget({required this.child, super.key});
  final Widget child;

  @override
  State<UserProviderWidget> createState() => _UserProviderWidgetState();
}

class _UserProviderWidgetState extends State<UserProviderWidget> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();

    ChatUIKitProvider.instance.contactsHandler = _contactsHandler;
    ChatUIKitProvider.instance.conversationsHandler = _conversationsHandler;
    ChatUIKitProvider.instance.groupMembersHandler = _groupMembersHandler;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  List<ChatUIKitProfile>? _contactsHandler(
    List<ChatUIKitProfile> profiles,
  ) {
    List<ChatUIKitProfile> list = [];
    for (var i = 0; i < profiles.length; i++) {
      list.add(
        profiles[i].copy(
            name: '${profiles[i].id}_nick',
            avatarUrl: RemoteAvatars.getRandomAvatar),
      );
    }
    return list;
  }

  List<ChatUIKitProfile>? _conversationsHandler(
    List<ChatUIKitProfile> profiles,
  ) {
    List<ChatUIKitProfile> list = [];
    for (var i = 0; i < profiles.length; i++) {
      list.add(
        profiles[i].copy(
            name: '${profiles[i].id}_nick',
            avatarUrl: RemoteAvatars.getRandomAvatar),
      );
    }
    return list;
  }

  List<ChatUIKitProfile>? _groupMembersHandler(
    String groupId,
    List<ChatUIKitProfile> profiles,
  ) {
    return null;
  }
}

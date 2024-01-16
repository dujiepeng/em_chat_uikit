import 'dart:convert';
import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/pages/tool/user_data_store.dart';

import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  ChatUIKitProfile? selected;
  ConversationListViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = ConversationListViewController(willShowHandler: handler);
  }

  List<ConversationInfo> handler(List<ConversationInfo> conversations) {
    int time = 0;
    List<ConversationInfo> needRemove = [];
    for (var info in conversations) {
      if (UserDataStore().unNotifyGroupIds.contains(info.profile.id)) {
        needRemove.add(info);
      }
    }

    for (var element in needRemove) {
      time = max(element.lastMessage!.serverTime, time);
    }

    conversations.removeWhere((element) => needRemove.contains(element));

    int index = conversations
        .lastIndexWhere((element) => element.lastMessage!.serverTime > time);

    if (needRemove.isNotEmpty) {
      conversations.insert(
        index + 1,
        ConversationInfo(
          profile: ChatUIKitProfile(
            id: '群助手',
          ),
          attribute: json.encode({
            'custom': time,
          }),
        ),
      );
    }

    return conversations;
  }

  @override
  Widget build(BuildContext context) {
    return ConversationsView(
      onLongPress: (context, info, defaultActions) {
        if (info.profile.type == ChatUIKitProfileType.groupChat) {
          return defaultActions +
              [
                ChatUIKitBottomSheetItem(
                  label: '接收但不提醒(Demo测试)',
                  type: ChatUIKitBottomSheetItemType.normal,
                  onTap: () async {
                    UserDataStore().unNotifyGroupIds.add(info.profile.id);
                    Navigator.pop(context);
                    controller!.reload();
                  },
                )
              ];
        }
        return defaultActions;
      },
      controller: controller,
      listViewItemBuilder: (context, info) {
        if (info.attribute != null) {
          int timestamp = json.decode(info.attribute!)['custom'];
          return FutureBuilder(
            future: ChatUIKit.instance.appointNewMessageConversationCount(
                UserDataStore().unNotifyGroupIds),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int count = snapshot.data as int;
                return ChatUIKitConversationListViewItem(
                  info,
                  subTitleLabel: count == 0 ? '暂无群聊有新消息' : '有$count个群聊有新消息',
                  timestamp: timestamp,
                );
              } else {
                return ChatUIKitConversationListViewItem(
                  info,
                  subTitleLabel: '暂无群聊有新消息',
                  timestamp: timestamp,
                );
              }
            },
          );
        }
        return null;
      },
    );
  }
}

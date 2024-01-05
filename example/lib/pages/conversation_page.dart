import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(Object context) {
    return const ConversationsView();
  }

/*
  @override
  Widget build(BuildContext context) {
    Widget content = ConversationsView(
      // enableAppBar: false,
      appBar: ChatUIKitAppBar(
        title: '会话',
        // titleTextStyle: TextStyle(color: Colors.white),
        showBackButton: false,
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'createGroup') {
              Navigator.of(context)
                  .pushNamed(ChatUIKitRouteNames.createGroupView,
                      arguments: CreateGroupViewArguments())
                  .then((value) {
                if (value != null && value is Group) {
                  Navigator.of(context).pushNamed(
                    ChatUIKitRouteNames.messagesView,
                    arguments: MessagesViewArguments(
                      profile: ChatUIKitProfile.groupChat(
                        id: value.groupId,
                        name: value.name,
                      ),
                    ),
                  );
                }
              });
            } else if (value == 'newConversation') {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.95,
                    child: const SelectContactView(
                      backText: '新会话',
                    ),
                  );
                },
              ).then((profile) {
                if (profile != null) {
                  Navigator.of(context).pushNamed(
                    ChatUIKitRouteNames.messagesView,
                    arguments: MessagesViewArguments(
                      profile: profile,
                    ),
                  );
                }
              });
            }
          },
          offset: const Offset(0, 40),
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'createGroup',
                child: Text('创建群组'),
              ),
              const PopupMenuItem<String>(
                value: 'newConversation',
                child: Text('发起新会话'),
              ),
              const PopupMenuItem<String>(
                value: 'addContact',
                child: Text('添加联系人'),
              ),
            ];
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );

    return content;
  }
  */
}

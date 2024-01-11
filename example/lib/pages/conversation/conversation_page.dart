import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  ChatUIKitProfile? selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return MessagesView(
    //   onItemTap: (message) {
    //     if (message.bodyType == MessageType.FILE) {
    //       Navigator.of(context).push(
    //         MaterialPageRoute(
    //           builder: (context) => DownloadFileWidget(
    //             message: message,
    //             key: ValueKey(message.localTime),
    //           ),
    //         ),
    //       );
    //       return true;
    //     }
    //     return null;
    //   },
    //   profile: ChatUIKitProfile.contact(id: 'du005'),
    // );
    return const ConversationsView();
  }
}

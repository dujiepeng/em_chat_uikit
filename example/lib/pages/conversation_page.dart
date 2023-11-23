import 'dart:math';

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
    // sendMessages();
  }

  @override
  Widget build(BuildContext context) {
    return const ConversationView();
  }

  void sendMessages() async {
    for (var i = 0; i < 1000; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      final msg = Message.createTxtSendMessage(
        targetId: 'user_id_${Random().nextInt(100).toString()}',
        content: Random().nextInt(100).toString(),
      );
      Client.getInstance.chatManager.sendMessage(msg);
    }
  }
}

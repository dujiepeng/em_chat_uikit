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
  Widget build(Object context) {
    return MessagesView(
      profile: ChatUIKitProfile.contact(id: 'du005'),
    );
  }
}

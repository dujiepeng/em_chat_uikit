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
  Widget build(BuildContext context) {
    Widget content = const ConversationsView(
      enableAppBar: false,
    );

    content = Scaffold(
      appBar: AppBar(
        title: const Text('会话'),
      ),
      body: content,
    );

    return content;
  }
}

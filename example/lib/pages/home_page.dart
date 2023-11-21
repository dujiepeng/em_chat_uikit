import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements ProfileProvider {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatUIKit.instance.setAllSilentMode(enable: true);
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

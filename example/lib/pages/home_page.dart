import 'package:em_chat_uikit_example/pages/contact_page.dart';
import 'package:em_chat_uikit_example/pages/conversation_page.dart';
import 'package:em_chat_uikit_example/pages/my_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _pages(BuildContext context) {
    return [const ConversationPage(), const ContactPage(), const MyPage()];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            label: '会话',
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: '联系人',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: '我',
            icon: Icon(Icons.person),
          )
        ],
      ),
    );

    return content;
  }

  @override
  bool get wantKeepAlive => true;
}

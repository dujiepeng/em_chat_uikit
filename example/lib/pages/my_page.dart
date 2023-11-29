import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showChatUIKitDialog(
                title: 'Logout',
                context: context,
                items: [
                  ChatUIKitDialogItem.cancel(
                    label: 'CANCEL',
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  ChatUIKitDialogItem.confirm(
                    label: 'LOGOUT',
                    onTap: () async {
                      Navigator.of(context).pop();
                      ChatUIKit.instance.logout().then((value) {
                        Navigator.of(context).popAndPushNamed('/login');
                      });
                    },
                  ),
                ],
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

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
              showChatUIKitBottomSheet(
                title: 'Sign in & Sign up',
                context: context,
                items: [
                  ChatUIKitBottomSheetItem.normal(
                    label: 'Login',
                  ),
                  ChatUIKitBottomSheetItem.normal(
                    label: 'Register',
                    onTap: () async {
                      return Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            child: const Text('Bottom Sheet'),
          ),
          ElevatedButton(
            onPressed: () {
              showChatUIKitDialog(
                borderType: ChatUIKitRectangleType.filletCorner,
                title: 'Sign in & Sign up',
                content: 'Input your userId and password.',
                context: context,
                hintsText: ['UserId', 'Password'],
                items: [
                  ChatUIKitDialogItem.inputsConfirm(
                    label: 'SIGN IN',
                    onInputsTap: (inputs) async {
                      return Navigator.of(context).pop(inputs);
                    },
                  ),
                  ChatUIKitDialogItem.confirm(
                    label: 'SIGN IN',
                    onTap: () async {
                      return Navigator.of(context).pop();
                    },
                  ),
                  ChatUIKitDialogItem.cancel(
                    label: 'CANCEL',
                    onTap: () async {
                      return Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            child: const Text('Dialog'),
          ),
          ElevatedButton(
            onPressed: () {
              showChatUIKitDialog(
                borderType: ChatUIKitRectangleType.filletCorner,
                title: 'Sign in & Sign up',
                content: 'Input your userId and password.',
                context: context,
                hintsText: ['UserId', 'Password'],
                items: [
                  ChatUIKitDialogItem.inputsConfirm(
                    label: 'SIGN IN',
                    onInputsTap: (inputs) async {
                      return Navigator.of(context).pop(inputs);
                    },
                  ),
                  ChatUIKitDialogItem.cancel(
                    label: 'CANCEL',
                    onTap: () async {
                      return Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            child: const Text('Dialog'),
          ),
        ],
      ),
    );
  }
}

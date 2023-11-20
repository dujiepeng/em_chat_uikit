import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ChatUIKitTheme(
          // color: ChatUIKitColor.dark(),
          child: child!,
        );
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showBottom(context);
                    },
                    child: const Text('Click me'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(context);
                    },
                    child: const Text('Click me'),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> showDialog(BuildContext context) async {
    List<ChatUIKitDialogItem> list = [];
    list.add(
      ChatUIKitDialogItem.cancel(
        label: 'Cancel',
        onTap: () async {
          Navigator.of(context).pop(false);
        },
      ),
    );
    list.add(
      ChatUIKitDialogItem.inputsConfirm(
        label: 'Confirm',
        onInputsTap: (List<String> inputs) async {
          Navigator.of(context).pop(inputs);
        },
      ),
    );

    dynamic ret = await showChatUIKitDialog(
      title: 'title',
      content: 'content',
      context: context,
      borderType: ChatUIKitRectangleType.filletCorner,
      hintsText: ['Username', 'Password'],
      items: list,
    );

    debugPrint('dialog ret: $ret');
  }

  Future<void> showBottom(BuildContext context) async {
    List<ChatUIKitBottomSheetItem> list = [];
    list.add(
      ChatUIKitBottomSheetItem(
        label: 'title1',
        type: ChatUIKitBottomSheetItemType.normal,
        onTap: () async {
          Navigator.of(context).pop(true);
        },
      ),
    );
    list.add(
      ChatUIKitBottomSheetItem(
        label: 'title2',
        type: ChatUIKitBottomSheetItemType.normal,
        onTap: () async {
          Navigator.of(context).pop();
        },
      ),
    );
    list.add(
      ChatUIKitBottomSheetItem(
        label: 'title3',
        type: ChatUIKitBottomSheetItemType.destructive,
        onTap: () async {
          Navigator.of(context).pop('aa');
        },
      ),
    );
    dynamic ret = await showChatUIKitBottomSheet(
      context: context,
      items: list,
    );
    debugPrint('bottom ret: $ret');
  }
}

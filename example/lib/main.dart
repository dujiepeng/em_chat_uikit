import 'package:em_chat_uikit/em_chat_uikit.dart';

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
      ChatUIKitDialogItem(
        label: 'title1',
        type: ChatUIKitDialogItemType.destructive,
        onTap: () async {
          Navigator.of(context).pop(true);
        },
      ),
    );
    list.add(
      ChatUIKitDialogItem(
        label: 'title2',
        type: ChatUIKitDialogItemType.cancel,
        onTap: () async {
          Navigator.of(context).pop();
        },
      ),
    );
    list.add(
      ChatUIKitDialogItem(
        label: 'title3',
        type: ChatUIKitDialogItemType.confirm,
        onTap: () async {
          Navigator.of(context).pop('asb');
        },
      ),
    );

    dynamic ret = await showChatUIKitDialog(
      context: context,
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
    dynamic ret = await showChatUIkitBottomSheet(
      context: context,
      items: list,
    );
    debugPrint('bottom ret: $ret');
  }
}

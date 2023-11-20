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
              return ElevatedButton(
                onPressed: () {
                  List<ChatUIKitBottomSheetItem> list = [];
                  list.add(
                    ChatUIKitBottomSheetItem(
                      label: 'title1',
                      type: ChatUIKitBottomSheetItemType.normal,
                      onTap: () async {
                        return true;
                      },
                    ),
                  );
                  list.add(
                    ChatUIKitBottomSheetItem(
                      label: 'title2',
                      type: ChatUIKitBottomSheetItemType.normal,
                      onTap: () async {
                        return true;
                      },
                    ),
                  );
                  list.add(
                    ChatUIKitBottomSheetItem(
                      label: 'title3',
                      type: ChatUIKitBottomSheetItemType.destructive,
                      onTap: () async {
                        return true;
                      },
                    ),
                  );
                  showChatUIkitBottomSheet(
                    context: context,
                    items: list,
                    // title: 'titletitletitletitletitletitletitletitletitletitle',
                  );
                },
                child: const Text('Click me'),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/pages/home_page.dart';
import 'package:em_chat_uikit_example/pages/login_page.dart';
import 'package:em_chat_uikit_example/pages/welcome_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLight = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLight = !isLight;
    ChatUIKitSettings.avatarRadius = CornerRadius.medium;
    return MaterialApp(
      builder: EasyLoading.init(builder: (context, child) {
        return ChatUIKitTheme(
          color: isLight ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
          child: child!,
        );
      }),
      home: const WelcomePage(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            if (settings.name == '/home') {
              return const HomePage();
            } else if (settings.name == '/login') {
              return const LoginPage();
            } else {
              return const WelcomePage();
            }
          },
        );
      },
    );
  }
}

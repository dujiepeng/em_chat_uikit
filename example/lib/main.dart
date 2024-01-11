import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/home_page.dart';
import 'package:em_chat_uikit_example/login_page.dart';
import 'package:em_chat_uikit_example/pages/help/download_page.dart';
import 'package:em_chat_uikit_example/pages/me/change_avatar_page.dart';
import 'package:em_chat_uikit_example/pages/me/personal_info_page.dart';
import 'package:em_chat_uikit_example/welcome_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatUIKit.instance.init(appkey: appKey, debugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLight = true;
  final FlutterLocalization _localization = FlutterLocalization.instance;
  @override
  void initState() {
    super.initState();
    _localization.init(mapLocales: [
      const MapLocale('zh', ChatUIKitLocal.zh),
      const MapLocale('en', ChatUIKitLocal.en),
    ], initLanguageCode: 'zh');
  }

  @override
  Widget build(BuildContext context) {
    // isLight = !isLight;
    ChatUIKitSettings.avatarRadius = CornerRadius.medium;

    return MaterialApp(
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      builder: EasyLoading.init(builder: (context, child) {
        return ChatUIKitTheme(
          color: isLight ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
          child: child!,
        );
      }),
      home: const WelcomePage(),
      onGenerateRoute: (settings) {
        RouteSettings newSettings = settings;
        if (settings.name == ChatUIKitRouteNames.messagesView) {
          MessagesViewArguments arguments =
              settings.arguments as MessagesViewArguments;
          arguments = arguments.copyWith(
            onItemTap: (ctx, message) {
              if (message.bodyType == MessageType.FILE) {
                Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (context) => DownloadFileWidget(
                      message: message,
                      key: ValueKey(message.localTime),
                    ),
                  ),
                );
                return true;
              }
              return false;
            },
          );

          newSettings = RouteSettings(
            name: settings.name,
            arguments: arguments,
          );
        }

        return ChatUIKitRoute.generateRoute(newSettings) ??
            MaterialPageRoute(
              builder: (context) {
                if (settings.name == '/home') {
                  return const HomePage();
                } else if (settings.name == '/login') {
                  return const LoginPage();
                } else if (settings.name == '/personal_info') {
                  return const PersonalInfoPage();
                } else if (settings.name == '/change_avatar') {
                  return const ChangeAvatarPage();
                } else {
                  return const WelcomePage();
                }
              },
            );
      },
    );
  }
}

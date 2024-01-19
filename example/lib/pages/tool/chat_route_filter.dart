import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/pages/help/download_page.dart';
import 'package:flutter/material.dart';

class ChatRouteFilter {
  static RouteSettings chatRouteSettings(RouteSettings settings) {
    // 拦截 ChatUIKitRouteNames.messagesView
    if (settings.name == ChatUIKitRouteNames.messagesView) {
      return messagesView(settings);
    }
    return settings;
  }

  // 为 MessagesView 添加文件点击下载
  static RouteSettings messagesView(RouteSettings settings) {
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

    return RouteSettings(name: settings.name, arguments: arguments);
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

typedef ChatUIKitWidgetBuilder = Widget Function(
    BuildContext context, Object? arguments);

class ChatUIKitRoute {
  static final Map<String, ChatUIKitWidgetBuilder> _uikitRoutes =
      <String, ChatUIKitWidgetBuilder>{
    ContactDetailsView.routeName: (context, arguments) =>
        ContactDetailsView.arguments(arguments as ContactDetailsViewArguments),
    GroupChangeOwnerView.routeName: (context, arguments) =>
        GroupChangeOwnerView.arguments(
            arguments as GroupChangeOwnerViewArguments),
    GroupDetailsView.routeName: (context, arguments) =>
        GroupDetailsView.arguments(arguments as GroupDetailsViewArguments),
    ChangeInfoView.routeName: (context, arguments) =>
        ChangeInfoView.arguments(arguments as ChangeInfoViewArguments),
    NewRequestView.routeName: (context, arguments) =>
        NewRequestView.arguments(arguments as NewRequestViewArguments),
    GroupView.routeName: (context, arguments) =>
        GroupView.arguments(arguments as GroupViewArguments),
  };

  static Route? generateRoute<T extends Object>(RouteSettings settings) {
    ChatUIKitWidgetBuilder? builder = _uikitRoutes[settings.name];
    if (builder != null) {
      final route = MaterialPageRoute(
        builder: (context) {
          return builder(context, settings.arguments);
        },
        settings: settings,
      );

      return route;
    }
    return null;
  }
}

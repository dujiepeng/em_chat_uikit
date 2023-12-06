import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitWidgetBuilder = Widget Function(
    BuildContext context, Object? arguments);

class ChatUIKitRoute {
  static final Map<String, ChatUIKitWidgetBuilder> _uikitRoutes =
      <String, ChatUIKitWidgetBuilder>{
    ChatUIKitRouteNames.changeInfoView: (context, arguments) {
      return ChangeInfoView.arguments(arguments as ChangeInfoViewArguments);
    },
    ChatUIKitRouteNames.contactDetailsView: (context, arguments) {
      return ContactDetailsView.arguments(
          arguments as ContactDetailsViewArguments);
    },
    ChatUIKitRouteNames.contactView: (context, arguments) {
      return ContactView.arguments(arguments as ContactViewArguments);
    },
    ChatUIKitRouteNames.groupChangeOwnerView: (context, arguments) {
      return GroupChangeOwnerView.arguments(
          arguments as GroupChangeOwnerViewArguments);
    },
    ChatUIKitRouteNames.groupDetailsView: (context, arguments) {
      return GroupDetailsView.arguments(arguments as GroupDetailsViewArguments);
    },
    ChatUIKitRouteNames.newRequestView: (context, arguments) {
      return NewRequestView.arguments(arguments as NewRequestViewArguments);
    },
    ChatUIKitRouteNames.groupView: (context, arguments) {
      return GroupView.arguments(arguments as GroupViewArguments);
    },
    ChatUIKitRouteNames.newChatView: (context, arguments) {
      return NewChatView.arguments(arguments as NewChatViewArguments);
    },
    ChatUIKitRouteNames.newRequestDetailsView: (context, arguments) {
      return NewRequestDetailsView.arguments(
          arguments as NewRequestDetailsViewArguments);
    },
    ChatUIKitRouteNames.searchContactsView: (context, arguments) {
      return SearchContactsView.arguments(
          arguments as SearchContactsViewArguments);
    }
  };

  static Route? generateRoute<T extends Object>(RouteSettings settings) {
    if (settings.arguments is ChatUIKitViewArguments) {
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
    } else {
      return null;
    }
  }
}

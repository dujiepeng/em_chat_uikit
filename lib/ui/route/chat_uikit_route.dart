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
    ChatUIKitRouteNames.contactsView: (context, arguments) {
      return ContactsView.arguments(arguments as ContactsViewArguments);
    },
    ChatUIKitRouteNames.groupChangeOwnerView: (context, arguments) {
      return GroupChangeOwnerView.arguments(
          arguments as GroupChangeOwnerViewArguments);
    },
    ChatUIKitRouteNames.groupDetailsView: (context, arguments) {
      return GroupDetailsView.arguments(arguments as GroupDetailsViewArguments);
    },
    ChatUIKitRouteNames.newRequestsView: (context, arguments) {
      return NewRequestsView.arguments(arguments as NewRequestsViewArguments);
    },
    ChatUIKitRouteNames.groupsView: (context, arguments) {
      return GroupsView.arguments(arguments as GroupsViewArguments);
    },
    ChatUIKitRouteNames.selectContactsView: (context, arguments) {
      return SelectContactView.arguments(
          arguments as SelectContactViewArguments);
    },
    ChatUIKitRouteNames.newRequestDetailsView: (context, arguments) {
      return NewRequestDetailsView.arguments(
          arguments as NewRequestDetailsViewArguments);
    },
    ChatUIKitRouteNames.searchContactsView: (context, arguments) {
      return SearchContactsView.arguments(
          arguments as SearchContactsViewArguments);
    },
    ChatUIKitRouteNames.groupMembersView: (context, arguments) {
      return GroupMembersView.arguments(arguments as GroupMembersViewArguments);
    },
    ChatUIKitRouteNames.groupAddMembersView: (context, arguments) {
      return GroupAddMembersView.arguments(
          arguments as GroupAddMembersViewArguments);
    },
    ChatUIKitRouteNames.groupDeleteMembersView: (context, arguments) {
      return GroupDeleteMembersView.arguments(
          arguments as GroupDeleteMembersViewArguments);
    },
    ChatUIKitRouteNames.searchGroupMembersView: (context, arguments) {
      return SearchGroupMembersView.arguments(
          arguments as SearchGroupMembersViewArguments);
    },
    ChatUIKitRouteNames.messagesView: (context, arguments) {
      return MessagesView.arguments(arguments as MessagesViewArguments);
    },
    ChatUIKitRouteNames.conversationsView: (context, arguments) {
      return ConversationsView.arguments(
          arguments as ConversationsViewArguments);
    },
    ChatUIKitRouteNames.showImageView: (context, arguments) {
      return ShowImageView.arguments(arguments as ShowImageViewArguments);
    },
    ChatUIKitRouteNames.showVideoView: (context, arguments) {
      return ShowVideoView.arguments(arguments as ShowVideoViewArguments);
    },
    ChatUIKitRouteNames.currentUserInfoView: (context, arguments) {
      return CurrentUserInfoView.arguments(
          arguments as CurrentUserInfoViewArguments);
    },
    ChatUIKitRouteNames.createGroupView: (context, arguments) {
      return CreateGroupView.arguments(arguments as CreateGroupViewArguments);
    },
    ChatUIKitRouteNames.groupMentionView: (context, arguments) {
      return GroupMentionView.arguments(arguments as GroupMentionViewArguments);
    },
    ChatUIKitRouteNames.reportMessageView: ((context, arguments) {
      return ReportMessageView.arguments(
          arguments as ReportMessageViewArguments);
    }),
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

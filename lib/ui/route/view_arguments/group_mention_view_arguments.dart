import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupMentionViewArguments implements ChatUIKitViewArguments {
  GroupMentionViewArguments({
    required this.groupId,
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.attributes,
  });

  final String groupId;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;

  @override
  String? attributes;
}
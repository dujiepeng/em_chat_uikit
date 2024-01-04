import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class CreateGroupViewArguments implements ChatUIKitViewArguments {
  CreateGroupViewArguments({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.enableAppBar = true,
    this.willCreateHandler,
    this.createGroupInfo,
    this.attributes,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel model)? onItemTap;
  final void Function(ContactItemModel model)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final WillCreateHandler? willCreateHandler;
  final CreateGroupInfo? createGroupInfo;
  @override
  String? attributes;
}

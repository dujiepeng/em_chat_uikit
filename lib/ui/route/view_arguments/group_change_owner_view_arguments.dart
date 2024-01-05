import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupChangeOwnerViewArguments implements ChatUIKitViewArguments {
  GroupChangeOwnerViewArguments({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.attributes,
  });

  final String groupId;

  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel model)? onItemTap;
  final void Function(ContactItemModel model)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;

  @override
  String? attributes;

  GroupChangeOwnerViewArguments copyWith({
    String? groupId,
    GroupMemberListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(ContactItemModel model)? onItemTap,
    void Function(ContactItemModel model)? onItemLongPress,
    String? fakeSearchHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableAppBar,
    String? attributes,
  }) {
    return GroupChangeOwnerViewArguments(
      groupId: groupId ?? this.groupId,
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onItemTap: onItemTap ?? this.onItemTap,
      onItemLongPress: onItemLongPress ?? this.onItemLongPress,
      fakeSearchHideText: fakeSearchHideText ?? this.fakeSearchHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}

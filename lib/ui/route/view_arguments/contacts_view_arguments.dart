import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ContactsViewArguments implements ChatUIKitViewArguments {
  ContactsViewArguments({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.attributes,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  @override
  String? attributes;

  ContactsViewArguments copyWith({
    ContactListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onTap,
    void Function(BuildContext context, ContactItemModel model)? onLongPress,
    String? fakeSearchHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableAppBar,
    String? attributes,
  }) {
    return ContactsViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      fakeSearchHideText: fakeSearchHideText ?? this.fakeSearchHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}

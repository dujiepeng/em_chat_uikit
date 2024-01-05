import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ConversationsViewArguments implements ChatUIKitViewArguments {
  ConversationsViewArguments({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.beforeWidgets,
    this.afterWidgets,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.enableAppBar = true,
    this.attributes,
  });

  final ConversationListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ConversationInfo> data)? onSearchTap;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;
  final ChatUIKitListItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ConversationInfo model)? onTap;
  final void Function(BuildContext context, ConversationInfo model)?
      onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  @override
  String? attributes;

  ConversationsViewArguments copyWith({
    ConversationListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ConversationInfo> data)? onSearchTap,
    List<NeedAlphabeticalWidget>? beforeWidgets,
    List<NeedAlphabeticalWidget>? afterWidgets,
    ChatUIKitListItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ConversationInfo model)? onTap,
    void Function(BuildContext context, ConversationInfo model)? onLongPress,
    String? fakeSearchHideText,
    Widget? listViewBackground,
    bool? enableAppBar,
    String? attributes,
  }) {
    return ConversationsViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      beforeWidgets: beforeWidgets ?? this.beforeWidgets,
      afterWidgets: afterWidgets ?? this.afterWidgets,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      fakeSearchHideText: fakeSearchHideText ?? this.fakeSearchHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}

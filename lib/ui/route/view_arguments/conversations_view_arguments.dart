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
}

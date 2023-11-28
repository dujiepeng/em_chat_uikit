import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({
    this.listViewItemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    super.key,
  });

  final ConversationListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ConversationItemModel> data)? onSearchTap;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;
  final ChatUIKitListItemBuilder? listViewItemBuilder;
  final void Function(ConversationItemModel)? onItemTap;
  final void Function(ConversationItemModel)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  late ConversationListViewController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ConversationListViewController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            title: 'Chats',
            subTitle: 'Online',
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              fontSize: theme.font.titleLarge.fontSize,
              fontWeight: FontWeight.w900,
            ),
            autoBackButton: true,
            leading: const ChatUIKitAvatar(size: 32),
            trailing: IconButton(
              iconSize: 24,
              color: theme.color.isDark
                  ? theme.color.neutralColor95
                  : theme.color.neutralColor3,
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {},
            ),
          ),
      body: ConversationListView(
        controller: controller,
        itemBuilder: widget.listViewItemBuilder,
        beforeWidgets: widget.beforeWidgets,
        afterWidgets: widget.afterWidgets,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        onTap: widget.onItemTap ??
            (ConversationItemModel model) {
              pushToMessageInfoPage();
            },
        onLongPress: widget.onItemLongPress ??
            (ConversationItemModel model) {
              longPressed(model);
            },
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  void onSearchTap(List<ConversationItemModel> data) {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SearchView(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop();
            debugPrint('onTap: ${profile.id}');
          },
          searchHideText: '搜索',
          searchData: list,
        );
      },
    );
  }

  void pushToMessageInfoPage() {}

  void longPressed(ConversationItemModel model) {
    showChatUIKitBottomSheet(
      cancelTitle: '取消',
      context: context,
      items: [
        ChatUIKitBottomSheetItem.normal(
          label: model.noDisturb ? '取消静音' : '静音',
          onTap: () async {
            final type = model.profile.type == ChatUIKitProfileType.groupChat
                ? ConversationType.GroupChat
                : ConversationType.Chat;

            if (model.noDisturb) {
              ChatUIKit.instance.clearChatUIKitSilentMode(
                conversationId: model.profile.id,
                type: type,
              );
            } else {
              ChatUIKit.instance.setChatUIKitSilentMode(
                conversationId: model.profile.id,
                type: type,
              );
            }

            Navigator.of(context).pop();
          },
        ),
        ChatUIKitBottomSheetItem.normal(
          label: model.pinned ? '取消置顶' : '置顶',
          onTap: () async {
            ChatUIKit.instance.pinConversation(
              conversationId: model.profile.id,
              isPinned: !model.pinned,
            );
            Navigator.of(context).pop();
          },
        ),
        if (model.unreadCount > 0)
          ChatUIKitBottomSheetItem.normal(
            label: '标记已读',
            onTap: () async {
              ChatUIKit.instance.markConversationAsRead(
                conversationId: model.profile.id,
              );
              Navigator.of(context).pop();
            },
          ),
        ChatUIKitBottomSheetItem.destructive(
          label: '删除会话',
          onTap: () async {
            ChatUIKit.instance.deleteLocalConversation(
              conversationId: model.profile.id,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

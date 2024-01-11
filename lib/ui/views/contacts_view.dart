import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ContactsView extends StatefulWidget {
  ContactsView.arguments(
    ContactsViewArguments arguments, {
    super.key,
  })  : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        fakeSearchHideText = arguments.fakeSearchHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        beforeItems = arguments.beforeItems,
        afterItems = arguments.afterItems,
        loadErrorMessage = arguments.loadErrorMessage,
        title = arguments.title,
        attributes = arguments.attributes;

  const ContactsView({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.beforeItems,
    this.afterItems,
    this.title,
    this.attributes,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<ChatUIKitListViewMoreItem>? beforeItems;
  final List<ChatUIKitListViewMoreItem>? afterItems;
  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  final String? title;
  final String? attributes;

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> with ContactObserver {
  late final ContactListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? ContactListViewController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            title: widget.title ?? 'Contacts',
            titleTextStyle: TextStyle(
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              fontSize: theme.font.titleLarge.fontSize,
              fontWeight: FontWeight.w900,
            ),
            showBackButton: false,
            leading: Container(
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: ChatUIKitAvatar(
                size: 32,
                avatarUrl:
                    ChatUIKitProvider.instance.currentUserData?.avatarUrl,
              ),
            ),
            trailing: IconButton(
              iconSize: 24,
              color: theme.color.isDark
                  ? theme.color.neutralColor95
                  : theme.color.neutralColor3,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: addContact,
            ),
          ),
      body: SafeArea(
        child: ContactListView(
          controller: controller,
          itemBuilder: widget.listViewItemBuilder,
          beforeWidgets: widget.beforeItems ?? beforeWidgets,
          afterWidgets: widget.afterItems,
          searchHideText: widget.fakeSearchHideText,
          background: widget.listViewBackground,
          onTap: widget.onTap ?? tapContactInfo,
          onLongPress: widget.onLongPress,
          onSearchTap: widget.onSearchTap ?? onSearchTap,
          errorMessage: widget.loadErrorMessage,
        ),
      ),
    );

    return content;
  }

  List<ChatUIKitListViewMoreItem> get beforeWidgets {
    return [
      ChatUIKitListViewMoreItem(
        title: ChatUIKitLocal.contactsViewNewRequests.getString(context),
        onTap: () {
          Navigator.of(context).pushNamed(
            ChatUIKitRouteNames.newRequestsView,
            arguments: NewRequestsViewArguments(
              attributes: widget.attributes,
            ),
          );
        },
        trailing: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: ChatUIKitBadge(ChatUIKitContext.instance.requestList().length),
        ),
      ),
      ChatUIKitListViewMoreItem(
        title: ChatUIKitLocal.contactsViewGroups.getString(context),
        onTap: () {
          Navigator.of(context)
              .pushNamed(
            ChatUIKitRouteNames.groupsView,
            arguments: GroupsViewArguments(),
          )
              .then((value) {
            ChatUIKit.instance.onConversationsUpdate();
          });
        },
      ),
    ];
  }

  void onSearchTap(List<ContactItemModel> data) {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SearchContactsView(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop();
          },
          searchHideText: ChatUIKitLocal.contactsViewSearch.getString(context),
          searchData: list,
        );
      },
    );
  }

  void tapContactInfo(BuildContext context, ContactItemModel model) {
    Navigator.of(context)
        .pushNamed(
      ChatUIKitRouteNames.contactDetailsView,
      arguments: ContactDetailsViewArguments(
        profile: model.profile,
        actions: [
          ChatUIKitActionItem(
            title: ChatUIKitLocal.contactDetailViewSend.getString(context),
            icon: 'assets/images/chat.png',
            onTap: (context) {
              Navigator.of(context).pushNamed(
                ChatUIKitRouteNames.messagesView,
                arguments: MessagesViewArguments(
                  profile: model.profile,
                  attributes: widget.attributes,
                ),
              );
            },
          ),
        ],
      ),
    )
        .then(
      (value) {
        ChatUIKit.instance.onConversationsUpdate();
      },
    );
  }

  void addContact() async {
    String? userId = await showChatUIKitDialog(
      borderType: ChatUIKitRectangleType.filletCorner,
      title: ChatUIKitLocal.contactsAddContactAlertTitle.getString(context),
      content:
          ChatUIKitLocal.contactsAddContactAlertSubTitle.getString(context),
      context: context,
      hintsText: [
        ChatUIKitLocal.contactsAddContactAlertHintText.getString(context)
      ],
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.contactsAddContactAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.inputsConfirm(
          label: ChatUIKitLocal.contactsAddContactAlertButtonConfirm
              .getString(context),
          onInputsTap: (inputs) async {
            Navigator.of(context).pop(inputs.first);
          },
        ),
      ],
    );

    if (userId?.isNotEmpty == true) {
      try {
        await ChatUIKit.instance.sendContactRequest(userId: userId!);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);

    super.dispose();
  }

  @override
  // 用于更新好友请求未读数
  void onContactRequestReceived(String userId, String? reason) {
    safeSetState(() {});
  }

  // 用户更新好友请求未读数
  @override
  void onContactAdded(String userId) {
    if (mounted) {
      setState(() {});
      controller.reload();
    }
  }

  // 用于更新删除好友后的列表刷新
  @override
  void onContactDeleted(String userId) {
    if (mounted) {
      controller.reload();
    }
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

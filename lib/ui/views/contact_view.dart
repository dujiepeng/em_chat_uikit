import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/widgets/chat_uikit_badge.dart';

import 'package:flutter/material.dart';

class ContactView extends StatefulWidget {
  const ContactView({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.loadErrorMessage,
    this.onAddContactError,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel)? onItemTap;
  final void Function(ContactItemModel)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final void Function(ChatError error)? onAddContactError;

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> with ContactObserver {
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
            title: 'Contacts',
            titleTextStyle: TextStyle(
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              fontSize: theme.font.titleLarge.fontSize,
              fontWeight: FontWeight.w900,
            ),
            autoBackButton: false,
            leading: Container(
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: const ChatUIKitAvatar(size: 32),
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
        beforeWidgets: beforeWidgets,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        onTap: widget.onItemTap ?? tapContactInfo,
        onLongPress: widget.onItemLongPress ?? longContactInfo,
        onSearchTap: widget.onSearchTap ?? onSearchTap,
        errorMessage: widget.loadErrorMessage,
      )),
    );

    return content;
  }

  List<ChatUIKitListMoreItem> get beforeWidgets {
    return [
      ChatUIKitListMoreItem(
        title: '新请求',
        onTap: () {
          Navigator.maybeOf(context)?.push(MaterialPageRoute(
            builder: (context) {
              return const NewRequestView();
            },
          )).then((value) {
            setState(() {});
          });
        },
        trailing: () {
          if (ChatUIKitContext.instance.requestList().isNotEmpty == true) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ChatUIKitBadge(
                  ChatUIKitContext.instance.requestList().length),
            );
          } else {
            return const SizedBox();
          }
        }(),
      ),
      ChatUIKitListMoreItem(
        title: '群聊',
        onTap: () {
          Navigator.maybeOf(context)?.push(MaterialPageRoute(
            builder: (context) {
              return const GroupView();
            },
          ));
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
            debugPrint('onTap: ${profile.id}');
          },
          searchHideText: '搜索联系人',
          searchData: list,
        );
      },
    );
  }

  void tapContactInfo(ContactItemModel info) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ContactDetailsView(
          profile: info.profile,
        );
      },
    ));
  }

  void longContactInfo(ContactItemModel info) {
    debugPrint('longContactInfo');
  }

  void addContact() async {
    String? userId = await showChatUIKitDialog(
      borderType: ChatUIKitRectangleType.filletCorner,
      title: '添加联系人',
      content: '通过用户ID添加联系人',
      context: context,
      hintsText: ['输入用户ID'],
      items: [
        ChatUIKitDialogItem.cancel(
          label: '取消',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.inputsConfirm(
          label: '添加',
          onInputsTap: (inputs) async {
            Navigator.of(context).pop(inputs.first);
          },
        ),
      ],
    );

    if (userId?.isNotEmpty == true) {
      ChatUIKit.instance.sendContactRequest(userId: userId!);
    }
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onReceiveFriendRequest(String userId, String? reason) {
    setState(() {});
  }
}

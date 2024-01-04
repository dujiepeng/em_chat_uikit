import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/pages/contact_page.dart';
import 'package:em_chat_uikit_example/pages/conversation_page.dart';
import 'package:em_chat_uikit_example/pages/my_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        ChatObserver,
        ContactObserver,
        ChatSDKActionEventsObserver,
        ChatUIKitEventsObservers {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);

    ChatUIKitProvider.instance.contactsHandler = _contactsHandler;
    ChatUIKitProvider.instance.conversationsHandler = _conversationsHandler;
    ChatUIKitProvider.instance.groupMembersHandler = _groupMembersHandler;
  }

  void _contactsHandler(
    List<ChatUIKitProfile> profiles,
  ) {
    debugPrint('contactsHandler: ${profiles.length}');
    List<ChatUIKitProfile> list = [];
    for (var i = 0; i < profiles.length; i++) {
      list.add(profiles[i].copy(name: '${profiles[i].id}_nick'));
    }
    ChatUIKitProvider.instance.addContactProfiles(list);
  }

  void _conversationsHandler(
    List<ChatUIKitProfile> profiles,
  ) {
    debugPrint('_conversationsHandler: ${profiles.length}');
    List<ChatUIKitProfile> list = [];
    for (var i = 0; i < profiles.length; i++) {
      list.add(profiles[i].copy(name: '${profiles[i].id}_nick'));
    }
    ChatUIKitProvider.instance.addConversationProfiles(list);
  }

  void _groupMembersHandler(
    String groupId,
    List<ChatUIKitProfile> profiles,
  ) {}

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  List<Widget> _pages(BuildContext context) {
    return [
      const ConversationPage(),
      const ContactPage(),
      const MyPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        selectedLabelStyle: TextStyle(
          fontSize: ChatUIKitTheme.of(context).font.labelExtraSmall.fontSize,
          fontWeight:
              ChatUIKitTheme.of(context).font.labelExtraSmall.fontWeight,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: ChatUIKitTheme.of(context).font.labelExtraSmall.fontSize,
          fontWeight:
              ChatUIKitTheme.of(context).font.labelExtraSmall.fontWeight,
        ),
        backgroundColor: ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.neutralColor1
            : ChatUIKitTheme.of(context).color.neutralColor98,
        selectedItemColor: ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.primaryColor6
            : ChatUIKitTheme.of(context).color.primaryColor5,
        unselectedItemColor: ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.neutralColor3
            : ChatUIKitTheme.of(context).color.neutralColor5,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: [
          CustomBottomNavigationBarItem(
            label: '会话',
            image: 'assets/images/chat.png',
            unreadCountWidget: FutureBuilder(
              future: ChatUIKit.instance.getUnreadMessageCount(),
              builder: (context, snapshot) {
                return ChatUIKitBadge(
                  snapshot.hasData ? snapshot.data ?? 0 : 0,
                  textColor: theme.color.neutralColor98,
                  backgroundColor: theme.color.isDark
                      ? theme.color.errorColor6
                      : theme.color.errorColor5,
                );
              },
            ),
            borderColor: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
            isSelect: _currentIndex == 0,
            imageSelectColor: theme.color.primaryColor5,
            imageUnSelectColor: theme.color.neutralColor5,
          ),
          CustomBottomNavigationBarItem(
            label: '联系人',
            image: 'assets/images/contact.png',
            unreadCountWidget: ChatUIKitBadge(
              ChatUIKit.instance.contactRequestCount(),
              textColor: theme.color.neutralColor98,
              backgroundColor: theme.color.isDark
                  ? theme.color.errorColor6
                  : theme.color.errorColor5,
            ),
            isSelect: _currentIndex == 1,
            borderColor: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
            imageSelectColor: theme.color.primaryColor5,
            imageUnSelectColor: theme.color.neutralColor5,
          ),
          CustomBottomNavigationBarItem(
            label: '我',
            image: 'assets/images/me.png',
            isSelect: _currentIndex == 2,
            imageSelectColor: theme.color.primaryColor5,
            imageUnSelectColor: theme.color.neutralColor5,
          )
        ],
      ),
    );

    return content;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onChatUIKitEventsReceived(ChatUIKitEvent events) {
    if (events == ChatUIKitEvent.groupIdCopied ||
        events == ChatUIKitEvent.userIdCopied) {
      EasyLoading.showSuccess('复制成功');
    } else if (events == ChatUIKitEvent.messageDownloading) {
      EasyLoading.showInfo('下载中');
    } else if (events == ChatUIKitEvent.noCameraPermission ||
        events == ChatUIKitEvent.noRecordPermission ||
        events == ChatUIKitEvent.noStoragePermission) {
      EasyLoading.showError('权限不足');
    } else if (events == ChatUIKitEvent.voiceTypeNotSupported) {
      EasyLoading.showError('语音格式不支持');
    }
  }

  @override
  // 用于刷新消息未读数
  void onMessagesReceived(List<Message> messages) {
    setState(() {});
  }

  @override
  // 用于刷新好友申请未读数
  void onContactRequestReceived(String username, String? reason) {
    setState(() {});
  }

  @override
  // 用于刷新消息和联系人未读数
  void onEventEnd(ChatSDKWrapperActionEvent event) {
    if (event == ChatSDKWrapperActionEvent.acceptContactRequest ||
        event == ChatSDKWrapperActionEvent.declineContactRequest ||
        event == ChatSDKWrapperActionEvent.markConversationAsRead ||
        event == ChatSDKWrapperActionEvent.setSilentMode ||
        event == ChatSDKWrapperActionEvent.clearSilentMode) {
      setState(() {});
    }
  }
}

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem({
    required this.image,
    required super.label,
    this.imageUnSelectColor,
    this.imageSelectColor,
    this.unreadCountWidget,
    this.isSelect = false,
    this.borderColor,
  }) : super(
          icon: Stack(
            children: [
              SizedBox(
                width: 76,
                height: 34,
                child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                      color: isSelect ? imageSelectColor : imageUnSelectColor,
                    )),
              ),
              Positioned(
                  top: 0,
                  left: 36,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: borderColor ?? Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: unreadCountWidget ?? const SizedBox(),
                  ))
            ],
          ),
        );

  final String image;
  final Widget? unreadCountWidget;
  final Color? imageUnSelectColor;
  final Color? imageSelectColor;
  final Color? borderColor;
  final bool isSelect;
}

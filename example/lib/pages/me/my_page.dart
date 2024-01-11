import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        body: _buildContent());

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = ChatUIKitAvatar(
      avatarUrl: ChatUIKitProvider.instance.currentUserData?.avatarUrl,
      size: 100,
    );

    Widget name = Text(
      ChatUIKitProvider.instance.currentUserData?.nickname ??
          ChatUIKit.instance.currentUserId() ??
          '',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: theme.font.headlineLarge.fontSize,
        fontWeight: theme.font.headlineLarge.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor100
            : theme.color.neutralColor1,
      ),
    );

    Widget easeId = Text(
      'ID: ${ChatUIKit.instance.currentUserId()}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: theme.font.bodySmall.fontSize,
        fontWeight: theme.font.bodySmall.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
      ),
    );

    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        easeId,
        const SizedBox(width: 2),
        InkWell(
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: ChatUIKit.instance.currentUserId() ?? ''));
          },
          child: Icon(
            Icons.file_copy_sharp,
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
      ],
    );

    Widget content = Column(
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        row,
      ],
    );

    content = ListView(
      children: [
        content,
        const SizedBox(height: 20),
        const Text('设置'),
        ListItem(
          imageWidget: Image.asset('assets/images/online.png'),
          title: '在线状态',
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/personal.png'),
          title: '个人信息',
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/settings.png'),
          title: '通用',
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/notifications.png'),
          title: '消息通知',
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/secret.png'),
          title: '隐私',
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/info.png'),
          title: '关于',
          trailing: 'Easemob UIKit v2.0.0',
          enableArrow: true,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            ChatUIKit.instance.logout();
          },
          child: Text(
            '退出登录',
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
            ),
          ),
        ),
      ],
    );

    content = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
      child: content,
    );

    return content;
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    required this.imageWidget,
    required this.title,
    this.trailing,
    this.enableArrow = false,
    super.key,
  });

  final Widget imageWidget;
  final String title;
  final String? trailing;
  final bool enableArrow;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = SizedBox(
      height: 54,
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: imageWidget,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: theme.font.titleMedium.fontSize,
              fontWeight: theme.font.titleMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor100
                  : theme.color.neutralColor1,
            ),
          ),
          Expanded(child: Container()),
          Text(
            trailing ?? '',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: theme.font.labelMedium.fontSize,
              fontWeight: theme.font.labelMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
            ),
          ),
          if (enableArrow) const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
    return content;
  }
}

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        title: '个人信息',
        titleTextStyle: TextStyle(
          fontSize: theme.font.titleMedium.fontSize,
          fontWeight: theme.font.titleMedium.fontWeight,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                '头像',
                style: TextStyle(
                  fontSize: theme.font.titleMedium.fontSize,
                  fontWeight: theme.font.titleMedium.fontWeight,
                ),
              ),
              trailing: ChatUIKitAvatar(
                avatarUrl:
                    ChatUIKitProvider.instance.currentUserData?.avatarUrl,
                size: 40,
              ),
              onTap: pushChangeAvatarPage,
            ),
            Divider(
              height: 0.5,
              indent: 16,
              color: theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor9,
            ),
            ListTile(
              title: Text(
                '昵称',
                style: TextStyle(
                  fontSize: theme.font.titleMedium.fontSize,
                  fontWeight: theme.font.titleMedium.fontWeight,
                ),
              ),
              trailing: Text(
                ChatUIKitProvider.instance.currentUserData?.nickname ??
                    ChatUIKit.instance.currentUserId() ??
                    '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: theme.font.labelLarge.fontSize,
                  fontWeight: theme.font.labelLarge.fontWeight,
                  color: theme.color.isDark
                      ? theme.color.neutralColor7
                      : theme.color.neutralColor5,
                ),
              ),
              onTap: pushChangeNicknamePage,
            ),
            Divider(
              height: 0.5,
              indent: 16,
              color: theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor9,
            )
          ],
        ),
      ),
    );
  }

  void pushChangeAvatarPage() {
    Navigator.of(context).pushNamed('/change_avatar').then((value) {
      setState(() {});
    });
  }

  void pushChangeNicknamePage() {
    Navigator.of(context)
        .pushNamed(
      ChatUIKitRouteNames.changeInfoView,
      arguments: ChangeInfoViewArguments(
        title: '修改昵称',
        inputTextCallback: () {
          return Future(
            () {
              return ChatUIKitProvider.instance.currentUserData?.nickname ??
                  ChatUIKit.instance.currentUserId() ??
                  '';
            },
          );
        },
      ),
    )
        .then(
      (value) {
        if (value is String) {
          UserData? data = ChatUIKitProvider.instance.currentUserData;
          if (data == null) {
            data = UserData(nickname: value);
          } else {
            data = data.copyWith(nickname: value);
          }
          ChatUIKitProvider.instance.currentUserData = data;
          setState(() {});
        }
      },
    );
  }
}

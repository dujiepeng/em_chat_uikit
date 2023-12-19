import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentUserInfoView extends StatefulWidget {
  CurrentUserInfoView.arguments(CurrentUserInfoViewArguments arguments,
      {super.key})
      : profile = arguments.profile;

  const CurrentUserInfoView({
    required this.profile,
    super.key,
  });
  final ChatUIKitProfile profile;
  @override
  State<CurrentUserInfoView> createState() => _CurrentUserInfoViewState();
}

class _CurrentUserInfoViewState extends State<CurrentUserInfoView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        appBar: const ChatUIKitAppBar(
          showBackButton: true,
        ),
        body: _buildContent());

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = ChatUIKitAvatar(
      avatarUrl: widget.profile.avatarUrl,
      size: 100,
    );

    Widget name = Text(
      widget.profile.showName,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: theme.font.headlineLarge.fontSize,
        fontWeight: theme.font.headlineLarge.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor100
            : theme.color.neutralColor1,
      ),
    );

    Widget easeId = Text(
      '环信ID: ${widget.profile.id}',
      overflow: TextOverflow.ellipsis,
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
            Clipboard.setData(ClipboardData(text: widget.profile.id));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('复制成功'),
              ),
            );
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
        const SizedBox(height: 20),
      ],
    );

    return content;
  }
}
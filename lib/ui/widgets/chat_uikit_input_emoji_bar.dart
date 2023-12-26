import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/custom/chat_uikit_emoji_data.dart';
import 'package:flutter/material.dart';

typedef EmojiClick = void Function(String emoji);

class ChatUIKitInputEmojiBar extends StatelessWidget {
  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  final VoidCallback? deleteOnTap;

  const ChatUIKitInputEmojiBar({
    super.key,
    this.crossAxisCount = 8,
    this.mainAxisSpacing = 2.0,
    this.crossAxisSpacing = 2.0,
    this.childAspectRatio = 1.0,
    this.bigSizeRatio = 0.0,
    this.emojiClicked,
    this.deleteOnTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = GridView.custom(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 60),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, position) {
          return _getEmojiItemContainer(position);
        },
        childCount: ChatUIKitEmojiData.listSize,
      ),
    );

    content = Stack(
      children: [
        content,
        Positioned(
          right: 20,
          width: 36,
          bottom: 20,
          height: 36,
          child: InkWell(
            onTap: () {
              deleteOnTap?.call();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                boxShadow: ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitShadow.darkSmall
                    : ChatUIKitShadow.lightSmall,
                borderRadius: BorderRadius.circular(24),
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor3
                    : ChatUIKitTheme.of(context).color.neutralColor98),
              ),
              child: ChatUIKitImageLoader.emojiDelete(
                size: 40,
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor98
                    : ChatUIKitTheme.of(context).color.neutralColor3),
              ),
            ),
          ),
        ),
      ],
    );

    return content;
  }

  _getEmojiItemContainer(int index) {
    var emoji = ChatUIKitEmojiData.emojiList[index];
    return ChatExpression(emoji, bigSizeRatio, emojiClicked);
  }
}

class ChatExpression extends StatelessWidget {
  final String emoji;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  const ChatExpression(
    this.emoji,
    this.bigSizeRatio,
    this.emojiClicked, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Text(
      emoji,
      style: const TextStyle(fontSize: 30),
    );
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.all(bigSizeRatio),
        ),
      ),
      onPressed: () {
        emojiClicked?.call(emoji);
      },
      child: icon,
    );
  }
}

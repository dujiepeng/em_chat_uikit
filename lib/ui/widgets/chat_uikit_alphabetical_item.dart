import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/widgets.dart';

class ChatUIKitAlphabeticalItem extends StatelessWidget {
  const ChatUIKitAlphabeticalItem({
    required this.model,
    super.key,
  });

  final AlphabeticalItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 6, top: 6),
      height: model.itemHeight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(model.alphabetical,
            style: TextStyle(
              fontWeight: theme.font.titleSmall.fontWeight,
              fontSize: theme.font.titleSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            )),
      ),
    );
  }
}

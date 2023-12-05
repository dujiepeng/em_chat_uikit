import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChangeInfoViewArguments {
  const ChangeInfoViewArguments({
    required this.title,
    this.hint,
    this.inputTextCallback,
  });

  final String title;
  final String? hint;
  final Future<String?> Function()? inputTextCallback;
}

class ChangeInfoView extends StatefulWidget {
  static const routeName = '/ChangeInfoView';

  ChangeInfoView.arguments(ChangeInfoViewArguments arguments, {super.key})
      : title = arguments.title,
        hint = arguments.hint,
        inputTextCallback = arguments.inputTextCallback;

  const ChangeInfoView({
    required this.title,
    this.hint,
    this.inputTextCallback,
    super.key,
  });
  final String title;
  final String? hint;
  final Future<String?> Function()? inputTextCallback;

  @override
  State<ChangeInfoView> createState() => _ChangeInfoViewState();
}

class _ChangeInfoViewState extends State<ChangeInfoView> {
  final TextEditingController controller = TextEditingController();

  String? originalStr;

  ValueNotifier<bool> isChanged = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      controller.text != originalStr
          ? isChanged.value = true
          : isChanged.value = false;
    });

    widget.inputTextCallback?.call().then((value) {
      originalStr = value ?? '';
      controller.text = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            child: Text(
              '取消',
              style: TextStyle(
                fontWeight: theme.font.labelMedium.fontWeight,
                fontSize: theme.font.labelMedium.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralColor95
                    : theme.color.neutralColor3,
              ),
            ),
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
          child: ValueListenableBuilder(
            valueListenable: isChanged,
            builder: (context, value, child) {
              return InkWell(
                onTap: () {
                  if (value) {
                    Navigator.of(context).pop(controller.text);
                  }
                },
                child: Text(
                  '确认',
                  style: TextStyle(
                    fontWeight: theme.font.labelMedium.fontWeight,
                    fontSize: theme.font.labelMedium.fontSize,
                    color: value
                        ? (theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5)
                        : (theme.color.isDark
                            ? theme.color.neutralColor5
                            : theme.color.neutralColor6),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1,
              ),
            ),
            trailing: SizedBox(
              width: 200,
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontWeight: theme.font.titleMedium.fontWeight,
                  fontSize: theme.font.titleMedium.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                ),
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor7,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            height: borderHeight,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
            margin: const EdgeInsets.only(left: 16),
          )
        ],
      ),
    );

    return content;
  }
}

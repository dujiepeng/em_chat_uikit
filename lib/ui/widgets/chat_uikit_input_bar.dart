import 'package:flutter/material.dart';

class ChatUIKitInputBar extends StatefulWidget {
  const ChatUIKitInputBar({this.onSend, super.key});

  final void Function(String text)? onSend;

  @override
  State<ChatUIKitInputBar> createState() => _ChatUIKitInputBarState();
}

class _ChatUIKitInputBarState extends State<ChatUIKitInputBar> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        Expanded(child: _buildInputField()),
        _buildSendButton(),
      ],
    );

    return content;
  }

  Widget _buildInputField() {
    return TextField(
      controller: _textEditingController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Type a message',
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
          onPressed: () {
            final value = _textEditingController.text;
            if (value.trim().isNotEmpty) {
              widget.onSend?.call(value);
              _textEditingController.clear();
            }
          },
          child: const Text('Send')),
    );
  }
}

import 'package:flutter/widgets.dart';

class MessageListShareUserData extends InheritedWidget {
  const MessageListShareUserData(
      {super.key, required super.child, required this.data});

  final Map<String, UserData> data;

  static MessageListShareUserData? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MessageListShareUserData>();
  }

  @override
  bool updateShouldNotify(covariant MessageListShareUserData oldWidget) {
    return oldWidget.data != data;
  }
}

class UserData {
  const UserData({this.nickname, this.avatarUrl});

  final String? nickname;
  final String? avatarUrl;
}

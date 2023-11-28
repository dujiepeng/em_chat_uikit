abstract mixin class ChatUIKitTimeTool {
  static String getChatTimeStr(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute}';
    } else if (dateTime.year == now.year) {
      return '${dateTime.month}:${dateTime.day}';
    } else {
      return '${dateTime.year}:${dateTime.month}:${dateTime.day}';
    }
  }
}

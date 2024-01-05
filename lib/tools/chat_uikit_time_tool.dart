abstract mixin class ChatUIKitTimeTool {
  static String getChatTimeStr(int time, {bool needTime = false}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute}';
    } else if (dateTime.year == now.year) {
      if (needTime) {
        return '${dateTime.month} ${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
      } else {
        return '${dateTime.month} ${dateTime.day}';
      }
    } else {
      if (needTime) {
        return '${dateTime.year} ${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
      } else {
        return '${dateTime.year} ${dateTime.month}-${dateTime.day}';
      }
    }
  }
}

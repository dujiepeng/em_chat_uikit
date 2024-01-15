abstract mixin class ChatUIKitTimeTool {
  static String getChatTimeStr(int time, {bool needTime = false}) {
    return getEnTime(time, needTime: needTime);
  }

  static String getEnTime(int time, {bool needTime = false}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute}';
    } else {
      if (needTime) {
        return '${getMTM(dateTime.month)} ${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
      } else {
        return '${getMTM(dateTime.month)} ${dateTime.day}';
      }
    }
  }

  static String getMTM(int mouth) {
    switch (mouth) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return '';
  }
}

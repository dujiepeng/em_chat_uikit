import 'package:shared_preferences/shared_preferences.dart';

class ChatUIKitContext {
  static ChatUIKitContext? _instance;
  static ChatUIKitContext get instance {
    _instance ??= ChatUIKitContext._internal();
    return _instance!;
  }

  late SharedPreferences sharedPreferences;
  ChatUIKitContext._internal() {
    init();
  }

  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}

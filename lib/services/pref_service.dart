import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesService {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
      print('prefs is setup Successfully');
    } catch (e) {
      print('Failed to initialize preferences: $e');
    }
  }

  static bool get isOnBoardingSeen =>
      prefs!.getBool('isOnBoardingSeen') ?? false;

  static set isOnBoardingSeen(bool value) =>
      prefs!.setBool('isOnBoardingSeen', value);

  static bool get isLogin => prefs!.getBool('isLogin') ?? false;

  static set isLogin(bool value) => prefs!.setBool('isLogin', value);

  static const String _textColorKey = 'text_color';

  static Future<void> saveTextColor(int colorValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_textColorKey, colorValue);
  }

  static Future<int?> getTextColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_textColorKey);
  }

  static String get profileImage =>
      prefs!.getString('profileImage') ??
      "https://icons.veryicon.com/png/o/system/crm-android-app-icon/app-icon-person.png";

  static set profileImage(String value) =>
      prefs!.setString('profileImage', value);
}

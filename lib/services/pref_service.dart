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
}

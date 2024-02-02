import 'package:shared_preferences/shared_preferences.dart';

class LocalPreference {
  static SharedPreferences? _preferences;

  static const _keyprofile = "photoList";

  //----------------------------------
  static Future clearAllPreference() => _preferences!.clear();

  //----------------------------------
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
  //--------------------------------------------------------------
  static Future setPhotos(List<String>? val) async =>
      await _preferences!.setStringList(_keyprofile, val!);
  static List<String>? getPhotos() => _preferences?.getStringList(_keyprofile);
  static Future<bool>? deletePhotos() => _preferences?.remove(_keyprofile);

  //--------------------------------------------------------------
}

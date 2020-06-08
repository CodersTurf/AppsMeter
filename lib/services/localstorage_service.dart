import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences preferences;
  LocalStorageService();
  Future<SharedPreferences> getPreferences() async {
    if (preferences == null) {
      return await SharedPreferences.getInstance();
    } else {
      return await Future.delayed(Duration(seconds: 0), () {
        return preferences;
      });
    }
  }

  Future<bool> saveValue(String key, List<String> value) async {
    var prefObj = await getPreferences();
    return await prefObj.setStringList(key, value);
  }
 Future<bool> getBoolValue(String key) async {
    var prefObj = await getPreferences();
    return prefObj.getBool(key);
  }
  Future<bool> saveKeyPairBoolValue(String key, bool value) async {
    var prefObj = await getPreferences();
    return await prefObj.setBool(key, value);
  }

  Future<List<String>> getValue(String key) async {
    var prefObj = await getPreferences();
    var vals = prefObj.getStringList(key);
    if (vals == null) {
      vals = new List<String>();
    }
    return vals;
  }
}

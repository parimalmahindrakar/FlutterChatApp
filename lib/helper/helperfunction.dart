import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{

  static String sharedPreferencesUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferencesUserNameKey = "USERNAMEKEY";
  static String sharedPreferencesUserEmailKey = "USERMAILKEY";


//  saving the data to the shared preferences
  static Future<bool> saveUserLoggedInSharePreference(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencesUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameInSharePreference(String uname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, uname);
  }
  static Future<bool> saveUserEmailInSharePreference(String uemail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserEmailKey, uemail);
  }

//  getting the data to the shared preferences
  static Future<bool> getUserLoggedInSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferencesUserLoggedInKey);
  }
  static Future<String> getUserNameInSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferencesUserNameKey);
  }
  static Future<String> getUserEmailInSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferencesUserEmailKey);
  }





}


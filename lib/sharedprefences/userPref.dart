import 'package:shared_preferences/shared_preferences.dart';


class UserPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Setters
  static Future<void> setUid(String value) async {
    await _prefs!.setString('uid', value);
  }

  static Future<void> setName(String value) async {
    await _prefs!.setString('name', value);
  }

  static Future<void> setEmail(String value) async {
    await _prefs!.setString('email', value);
  }
  

  static Future<void> setDob(DateTime? value) async {
    await _prefs!.setString('dob', value.toString());
  }

  static Future<void> setProfileUrl(String value) async {
    await _prefs!.setString('profileUrl', value);
  }

  static Future<void> setGender(String value) async {
    await _prefs!.setString('gender', value);
  }

  static Future<void> setLocation(String value) async {
    await _prefs!.setString('location', value);
  }

  static Future<void> setIsEmailVerified(bool value) async {
    await _prefs!.setBool('isEmailVerified', value);
  }

  static Future<void> setPhoneNumber(String value) async {
    await _prefs!.setString('phoneNumber', value);
  }

  static Future<void> setIsPhoneNumberVerified(bool value) async {
    await _prefs!.setBool('isPhoneNumberVerified', value);
  }

  static Future<void> setCreatedOn(DateTime value) async {
    await _prefs!.setString('createdOn', value.toString());
  }

  static Future<void> setAccountStatus(bool value) async {
    await _prefs!.setBool('accountStatus', value);
  }


 static Future<void> setAccountType(String value) async {
    await _prefs!.setString('accountType', value);
  }


  // Getters
  static String? getUid() {
    return _prefs!.getString('uid');
  }

  static String? getName() {
    return _prefs!.getString('name');
  }

  static String? getEmail() {
    return _prefs!.getString('email');
  }

  static DateTime? getDob() {
    final dobString = _prefs!.getString('dob');
    return dobString != null ? DateTime.parse(dobString) : null;
  }

  static String? getProfileUrl() {
    return _prefs!.getString('profileUrl');
  }

  static String? getGender() {
    return _prefs!.getString('gender');
  }

  static String? getLocation() {
    return _prefs!.getString('location');
  }

  static bool? getIsEmailVerified() {
    return _prefs!.getBool('isEmailVerified');
  }

  static String? getPhoneNumber() {
    return _prefs!.getString('phoneNumber');
  }

  static bool? getIsPhoneNumberVerified() {
    return _prefs!.getBool('isPhoneNumberVerified');
  }

  static DateTime? getCreatedOn() {
    final createdOnString = _prefs!.getString('createdOn');
    return createdOnString != null ? DateTime.parse(createdOnString) : null;
  }

  static bool? getAccountStatus() {
    return _prefs!.getBool('accountStatus');
  }

    static String? getAccountType() {
    return _prefs!.getString('accountType');
  }



}

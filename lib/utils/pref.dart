import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/auth/verify_otp_response.dart';
import '../data/model/home/home_response.dart';

/// shared preference storage
class Prefs {
  JsonCodec codec = const JsonCodec();
  SharedPreferences? _sharedPreferences;

  static const String _PROFILE_ID = "profile_id";
  static const String _PHONE_NUMBER = "phone_number";
  static const String _AUTH_TOKEN = "auth_token";
  static const String _USER_ID = "user_id";
  static const String _LAYOUT_ID = "layout_id";
  static const String _COMPANY_BASE_URL = "company_base_url";
  static const String _CUSTOMER_NOTE = "customer_note";
  static const String _SORT_ID = "sort_id";
  static const String _FILTER_CATEGORY_ID = "filter_category_id";
  static const String _FCM_TOKEN = "fcm_token";

  static const String _IS_LOGGED_IN = "is_logged_in";
  static const String _IS_DARK_MODE = "is_dark_mode";
  static const String _IS_BASE_FETCHED = "is_base_url_fetched";
  static const String userData = "user_data";
  static const String deviceId = "device_id";
  static const String addressId = "address_id";
  static const String providerCategoryId = "provider_category_id";
  static const String providerId = "provider_id";
  static const String areaList = "area_list";
  static const String selectedLocation = "selected-location";
  static const String onboardViewed = "onboard_viewed";

  Prefs();

  set sharedPreferences(SharedPreferences value) {
    _sharedPreferences = value;
  }

  ///saving  the phone number as a String
  void setUserProfileId({String? profileId}) {
    _sharedPreferences!.setString(_PROFILE_ID, profileId!);
  }

  ///get method  for phone number
  String? getUserProfileId() => _sharedPreferences!.getString(_PROFILE_ID);

  ///saving  the phone number as a String
  void setUserPhoneNumber({String? phoneNumber}) {
    _sharedPreferences!.setString(_PHONE_NUMBER, phoneNumber!);
  }

  ///get method  for phone number
  String? getUserPhoneNumber() => _sharedPreferences!.getString(_PHONE_NUMBER);

  ///saving  the auth token as a String
  void setAuthToken({String? token}) {
    _sharedPreferences!.setString(_AUTH_TOKEN, token!);
  }

  ///get method  for auth token
  String? getAuthToken() => _sharedPreferences?.getString(_AUTH_TOKEN);

  ///saving  the auth token as a String
  void setUserId({String? userId}) {
    _sharedPreferences!.setString(_USER_ID, userId!);
  }

  ///get method  for auth token
  String? getUserId() => _sharedPreferences!.getString(_USER_ID);

  ///saving  the auth token as a String
  void setSelectedLocation({String? location}) {
    _sharedPreferences!.setString(selectedLocation, location!);
  }

  ///get method  for auth token
  String? getSelectedLocation() => _sharedPreferences!.getString(selectedLocation);

  ///saving  layout id
  void saveLayoutId({String? layoutId}) {
    _sharedPreferences!.setString(_LAYOUT_ID, layoutId!);
  }

  ///get method  layout id
  String? getLayoutId() => _sharedPreferences!.getString(_LAYOUT_ID);

  ///saving  layout id
  void saveCompanyBaseUrl({String? baseUrl}) {
    _sharedPreferences!.setString(_COMPANY_BASE_URL, baseUrl!);
  }

  ///get method  for auth token
  String? getCompanyBaseUrl() => _sharedPreferences!.getString(_COMPANY_BASE_URL);

  ///saving  layout id
  void saveCustomerNote({String? customerNote}) {
    _sharedPreferences!.setString(_CUSTOMER_NOTE, customerNote!);
  }

  ///get method  for auth token
  String? getCustomerNote() => _sharedPreferences!.getString(_CUSTOMER_NOTE);

  ///saving  layout id
  void saveSortId({String? sortId}) {
    _sharedPreferences!.setString(_SORT_ID, sortId!);
  }

  ///get method  for auth token
  String? getSortId() => _sharedPreferences!.getString(_SORT_ID);

  ///saving  layout id
  void saveFilterCategoryId({String? categoryId}) {
    _sharedPreferences!.setString(_FILTER_CATEGORY_ID, categoryId!);
  }

  ///get method  for auth token
  String? getFilterCategoryId() => _sharedPreferences!.getString(_FILTER_CATEGORY_ID);

  ///saving  the auth token as a String
  void setFcmToken({String? token}) async {
    await _sharedPreferences!.setString(_FCM_TOKEN, token!);
  }

  ///get method  for auth token
  String? getFcmToken() => _sharedPreferences!.getString(_FCM_TOKEN);

  ///after login set isLoggedIn true
  ///before logout set isLoggedIn false
  void setIsLoggedIn(bool status) {
    _sharedPreferences!.setBool(_IS_LOGGED_IN, status);
  }

  ///checking that is logged in or not
  bool? isLoggedIn() =>
      _sharedPreferences!.getBool(_IS_LOGGED_IN) != null && _sharedPreferences!.getBool(_IS_LOGGED_IN) == true
          ? true
          : false;

 void setIsOnboardViewed(bool status) {
    _sharedPreferences!.setBool(onboardViewed, status);
  }

  ///checking that is logged in or not
  bool? isOnboardViewed() =>
      _sharedPreferences!.getBool(onboardViewed) != null && _sharedPreferences!.getBool(onboardViewed) == true
          ? true
          : false;

  void setDarkMode(bool status) {
    _sharedPreferences!.setBool(_IS_DARK_MODE, status);
  }

  ///checking that is logged in or not
  bool? isDarkMode() =>
      _sharedPreferences!.getBool(_IS_DARK_MODE) != null && _sharedPreferences!.getBool(_IS_DARK_MODE) == true
          ? true
          : false;

  void setBaseUrlFetched(bool status) {
    _sharedPreferences!.setBool(_IS_BASE_FETCHED, status);
  }

  ///checking that is logged in or not
  bool isBaseUrlFetched() =>
      _sharedPreferences!.getBool(_IS_BASE_FETCHED) != null && _sharedPreferences!.getBool(_IS_BASE_FETCHED) == true
          ? true
          : false;

  /// for clearing the data in preference
  void clearPrefs() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  ///  save user data
  void saveUserData(User result) {
    String jsonString = jsonEncode(result);
    _sharedPreferences!.setString(userData, jsonString);
  }

  /// get user data
  User getUserData() {
    Map<String, dynamic> resultMap = jsonDecode(_sharedPreferences!.getString(userData)!);
    var result = User.fromJson(resultMap);
    return result;
  }

  void saveAreaList({required List<GetArea> getAreaList}) {
    String jsonString = jsonEncode(getAreaList);
    _sharedPreferences!.setString(areaList, jsonString);
  }

  List<GetArea> getAreaList() {
    List<dynamic> decodedList = jsonDecode(_sharedPreferences!.getString(areaList)!);
    List<GetArea> result = decodedList.map((json) => GetArea.fromJson(json)).toList();
    return result;
  }

  ///saving  the device ID
  void setDeviceId({String? id}) async {
    await _sharedPreferences!.setString(deviceId, id!);
  }

  String? getDeviceId() => _sharedPreferences!.getString(deviceId);

  ///saving  the address ID
  void setAddressId({String? id}) async {
    await _sharedPreferences!.setString(deviceId, id!);
  }

  String? getAddressId() => _sharedPreferences!.getString(deviceId);

  ///saving provider Category id
  void setProviderCategoryId({String? id}) async {
    await _sharedPreferences!.setString(providerCategoryId, id!);
  }

  ///get method  for provider Category
  String? getProviderCategoryId() => _sharedPreferences!.getString(providerCategoryId);

  ///saving provider  id
  void setProviderId({String? id}) async {
    await _sharedPreferences!.setString(providerId, id!);
  }

  ///get method  for provider
  String? getProviderId() => _sharedPreferences!.getString(providerId);
}

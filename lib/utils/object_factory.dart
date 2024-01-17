import 'package:shared_preferences/shared_preferences.dart';

import '../data/client/api_client.dart';
import 'pref.dart';

/// it is a hub that connecting pref,repo,client
/// used to reduce imports in pages
class ObjectFactory {
  static final _objectFactory = ObjectFactory._internal();

  ObjectFactory._internal();

  factory ObjectFactory() => _objectFactory;

  ///Initialisation of Objects
  final Prefs _prefs = Prefs();
  final ApiClient _apiClient = ApiClient();

  ///
  /// Getters of Objects
  ///

  Prefs get prefs => _prefs;

  ApiClient get apiClient => _apiClient;

  ///
  /// Setters of Objects
  ///

  void setPrefs(SharedPreferences sharedPreferences) {
    _prefs.sharedPreferences = sharedPreferences;
  }
}

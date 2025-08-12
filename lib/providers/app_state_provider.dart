import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier{
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  bool _hasSeenOnboarding = false;
  bool _isInitialized = false;

  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get isInitialized => _isInitialized;

  Future<void> initializeApp() async{
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool(hasSeenOnboardingKey) ?? false;
    _isInitialized = true;
    notifyListeners();
  }
Future <void> setOnboardingComplete() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hasSeenOnboardingKey, true);
    _hasSeenOnboarding = true;
    notifyListeners();
}
}
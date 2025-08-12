import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const String isLoggedInKey = 'is_logged_in';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String passwordKey = 'user_password';


  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userEmail;
  String? _userName;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  String? get userEmail => _userEmail;

  String? get userName => _userName;

  String? get errorMessage => _errorMessage;

  Future<void> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;
    if (isLoggedIn) {
      _userEmail = prefs.getString(userEmailKey);
      _userName = prefs.getString(userNameKey);
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters long');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(isLoggedInKey, true);
      await prefs.setString(userEmailKey, email);
      await prefs.setString(userNameKey, email.split('@')[0]);

      _isLoggedIn = true;
      _userEmail = email;
      _userName = email.split('@')[0];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }


  Future<bool> signUp(String name, String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters long');
      }
      if (name.isEmpty) {
        throw Exception('Name can\'t be empty');
      }
      if (!email.contains('@')) {
        throw Exception('Please enter a valid email');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(isLoggedInKey, true);
      await prefs.setString(userEmailKey, email);
      await prefs.setString(userNameKey, name);

      _isLoggedIn = true;
      _userEmail = email;
      _userName = email.split('@')[0];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }


  Future<bool> resetPassword(String email,) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      if (!email.contains('@')) {
        throw Exception('Please enter a valid email');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
}) async {
    try{
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      final savedPassword = prefs.getString(passwordKey) ?? '123456';

      if(currentPassword != savedPassword){
        throw Exception('Current password is incorrect');
      }
      if(newPassword.length < 6){
        throw Exception('New password must be at least 6 characters long');
      }

      if(newPassword == currentPassword){
        throw Exception('New password must be different from current password ');
      }

      await prefs.setString(passwordKey, newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch(e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async{
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoggedInKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userNameKey);

    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    _isLoading = false;
    notifyListeners();

  }

  void clearError(){
    _errorMessage = null;
    notifyListeners();
  }
}

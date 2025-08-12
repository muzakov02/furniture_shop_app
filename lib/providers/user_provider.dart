import 'package:flutter/widgets.dart';
import 'package:furniture_shop_app/models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;

  User? get user => _user;

  void setUser(User user){
    _user = user;
    notifyListeners();
  }
  void updateUser({
    String? name,
    String? email, String? phone,
    String? profileImage,
}){
    if (_user == null) return;

    _user = _user!.copyWith(
      name:name,
      email:email,
      phone:phone,
      profileImage:profileImage,
    );
    notifyListeners();
  }
  void clearUser(){
    _user = null;
    notifyListeners();
  }
}
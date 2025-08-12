import 'package:flutter/cupertino.dart';

class WishlistProvider with ChangeNotifier {
  final Set<String> _wishlistIds = {};

  Set<String> get wishlistIds => _wishlistIds;

  bool isInWishlist(String furnitureId) => _wishlistIds.contains(furnitureId);

  void toggleWishlist(String furnitureId) {
    if (_wishlistIds.contains(furnitureId)) {
      _wishlistIds.remove(furnitureId);
    } else {
      _wishlistIds.add(furnitureId);
    }
    notifyListeners();
  }
  void removeFromWishlist(String furnitureId){
    _wishlistIds.remove(furnitureId);
    notifyListeners();
  }
  void clear(){
    _wishlistIds.clear();
    notifyListeners();
  }
}

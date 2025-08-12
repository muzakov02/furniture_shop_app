import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total => _items.fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );

  int get itemCount => _items.length;

  void addToCart(CartItem cartItem) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.furniture.id == cartItem.furniture.id &&
          item.selectedColor == cartItem.selectedColor,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += cartItem.quantity;
    } else {
      items.add(cartItem);
    }
    notifyListeners();
  }

  void removeFromCart(String furnitureId, {String? selectColor}) {
    if (selectColor != null) {
      _items.removeWhere((item) =>
          item.furniture.id == furnitureId &&
          item.selectedColor == selectColor);
    } else {
      _items.removeWhere((item) => item.furniture.id == furnitureId);
    }
    notifyListeners();
  }

  void updateQuantity(String furnitureId, int quantity) {
    final index = _items.indexWhere(
            (item) => item.furniture.id == furnitureId,
      );

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

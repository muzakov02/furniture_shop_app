import 'package:furniture_shop_app/models/furniture.dart';

class CartItem{
  final Furniture furniture;
  int quantity;
  final String selectedColor;

  CartItem({
    required this.furniture,
    required this.quantity,
    required this.selectedColor,


  });

  double get totalPrice{
    if(furniture.hasSpecialOffer){
      return furniture.getDiscountedPrice(20)*quantity;
    }
    return furniture.price* quantity;
  }
  double  get untilPrice{
    if (furniture.hasSpecialOffer){
      return furniture.getDiscountedPrice(20);
    }
    return furniture.price;
  }
}
class Furniture {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final List<String> images;
  final String description;
  final List<String> colors;
  bool isFavorite;
  final List<String> specialOfferIds;

  Furniture({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.images,
    required this.description,
    required this.colors,
    this.isFavorite = false,
    this.specialOfferIds = const[],
  });

  double getDiscountedPrice(double discountedPrice){
    return price - (price * discountedPrice/100);
  }

  bool get hasSpecialOffer => specialOfferIds.isNotEmpty;


}
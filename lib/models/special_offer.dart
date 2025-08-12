class SpecialOffer{
  final String id;
  final String title;
  final String description;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final List<String>?  applicableCategories;
  final List<String>? applicableProductIds;
  final double?  minimumPurcheseAmount;
  final bool isActive;

const SpecialOffer({
    required this.id,
  required this.title,
  required this.description,
  required this.discountPercentage,
  required this.startDate,
  required this.endDate,
   this.applicableCategories,
   this.applicableProductIds,
  this.minimumPurcheseAmount,
  this.isActive = true,

});

bool isApplicableToProduct(String productId, String category, double price, List<String> productSpecialOfferIds){
  if(!isActive){
    return false;
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(endDate.year, endDate.month, endDate.day);

  if (today.isBefore(start)|| today.isAfter(end)){
    return false;
  }

  final isEligible = productSpecialOfferIds.contains(id);
  return isEligible;
}

}
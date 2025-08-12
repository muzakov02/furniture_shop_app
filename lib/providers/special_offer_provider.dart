import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/furniture.dart';
import 'package:furniture_shop_app/models/special_offer.dart';

class SpecialOfferProvider with ChangeNotifier {
  final List<SpecialOffer> _specialOffers = [
    SpecialOffer(
      id: 'summer_sale',
      title: 'Summer sale',
      description: 'Get 20% off on all summer collection items',
      discountPercentage: 20,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      applicableCategories: ['Chair', 'Sofa'],
    ),
    SpecialOffer(
      id: 'premium_discount',
      title: 'Premium Furniture Deal',
      description: ' 30% off on premium furniture',
      discountPercentage: 30,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      minimumPurcheseAmount: 599.0,
    ),
    SpecialOffer(
      id: 'storage_special',
      title: 'Storage Solutions',
      description: ' 25% off on all storage items',
      discountPercentage: 25,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      applicableCategories: ['Storage'],
    ),
  ];

  List<SpecialOffer> get specialOffers {
    final offers = [..._specialOffers];
    debugPrint('NUmber of offers: ${offers.length}');
    for (final offer in offers) {
      debugPrint('Offers: ${offer.title}');
    }
    return offers;
  }

  SpecialOffer? getOfferById(String id) {
    try {
      return _specialOffers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      debugPrint('Offer with id $id not found');
      return null;
    }
  }

  List<SpecialOffer> getApplicableOffers(Furniture furniture) {
    final offers = _specialOffers
        .where(
          (offer) => offer.isApplicableToProduct(
            furniture.id,
            furniture.category,
            furniture.price,
            furniture.specialOfferIds,
          ),
        )
        .toList();
    return offers;
  }

  SpecialOffer? getBestOffer(Furniture furniture) {
    final applicableOffers = getApplicableOffers(furniture);

    if (applicableOffers.isEmpty) return null;

    return applicableOffers.reduce((curr, next) =>
        curr.discountPercentage > next.discountPercentage ? curr : next);
  }

  double getDiscountedPrice(Furniture furniture) {
    final bestOffer = getBestOffer(furniture);
    if (bestOffer == null) return furniture.price;

    return furniture.price -
        (furniture.price * bestOffer.discountPercentage / 100);
  }
}

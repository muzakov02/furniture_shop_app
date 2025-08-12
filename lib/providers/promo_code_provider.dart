import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/promo_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoCodeProvider with ChangeNotifier {
  List<PromoCode> _promoCodes = [];
  final String _storageKey = 'promo_codes';

  List<PromoCode> get promoCodes => _promoCodes;

  List<PromoCode> get availablePromoCodes =>
      _promoCodes.where((code) => !code.isUsed && !code.isExpired).toList();

  List<PromoCode> get usedPromoCodes =>
      _promoCodes.where((code) => !code.isUsed && code.isExpired).toList();

  PromoCodeProvider() {
    _loadPromoCodes();
  }

  Future<void> _loadPromoCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedCodes = prefs.getString(_storageKey);

    if (storedCodes != null) {
      final List<dynamic> decodedCodes = jsonDecode(storedCodes);
      _promoCodes =
          decodedCodes.map((method) => PromoCode.fromJson(method)).toList();
    } else {
      await _addSamplePromoCodes();
    }
    notifyListeners();
  }

  Future<void> _addSamplePromoCodes() async {
    final now = DateTime.now();
    final sampleCodes = [
      PromoCode(
        code: 'WELCOME20',
        discount: '20% OFF',
        description: 'Get 20 % off on your first purchase ',
        validUntil: now.add(const Duration(days: 30)),
        isPercentage: true,
      ),
      PromoCode(
        code: 'FREESHIP',
        discount: 'FREE',
        description: 'Free shipping on orders above \$50',
        validUntil: now.add(const Duration(days: 45)),
        isPercentage: false,
      ),
      PromoCode(
        code: 'SUMMER30',
        discount: '30% OFF',
        description: 'Summer special discount on all outdoor furniture ',
        validUntil: now.add(const Duration(days: 60)),
        isPercentage: true,
      ),
      PromoCode(
        code: 'NEWYEAR50',
        discount: '50% OFF',
        description: 'New Year special discount ',
        validUntil: now.add(const Duration(days: 5)),
        isPercentage: true,
        isUsed: false,
      ),
      PromoCode(
        code: 'FLASH25',
        discount: '25% OFF',
        description: 'Flash sale discount on all times ',
        validUntil: now.add(const Duration(days: 2)),
        isPercentage: true,
      ),
    ];

    _promoCodes.addAll(sampleCodes);
    await _savePromoCodes();
  }

  Future<void> _savePromoCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedCodes =
    jsonEncode(_promoCodes.map((code) => code.toJson()).toList());
    await prefs.setString(_storageKey, encodedCodes);
  }

  Future<bool> addPromoCode(String code) async {
    if (_promoCodes
        .any((promoCodes) => promoCodes.code == code.toUpperCase())) {
      return false;
    }
    final validCodes = {
      'WELCOME20': PromoCode(
        code: 'WELCOME20',
        discount: '20% OFF',
        description: 'Get 20 % off on your first purchase',
        validUntil: DateTime.now().add(const Duration(days: 30)),
        isPercentage: true,
      ),
      'FREESHIP': PromoCode(
        code: 'FREESHIP',
        discount: 'FREE',
        description: 'Free shipping on orders above \$50',
        validUntil: DateTime.now().add(const Duration(days: 45)),
        isPercentage: false,
      ),
      'SUMMER30': PromoCode(
        code: 'SUMMER30',
        discount: '30% OFF',
        description: 'Summer special discount on all outdoor furniture ',
        validUntil: DateTime.now().add(const Duration(days: 60)),
        isPercentage: true,
      ),
    };
    final upperCode = code.toUpperCase();
    if (validCodes.containsKey(upperCode)) {
      _promoCodes.add(validCodes[upperCode]!);
      await _savePromoCodes();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> markPromoCodesUsed(String code) async {
    final index = _promoCodes.indexWhere((promoCodes) =>
    promoCodes.code == code);
    if (index != -1) {
      final updatedCode = PromoCode(
        code: _promoCodes[index].code,
        discount: _promoCodes[index].discount,
        description: _promoCodes[index].description,
        validUntil: _promoCodes[index].validUntil,
        isPercentage: _promoCodes[index].isPercentage,
        isUsed: true,
      );
      _promoCodes[index] = updatedCode;
      await _savePromoCodes();
      notifyListeners();
    }
  }
  double calculateDiscount(String code, double amount) {
    final promoCode = _promoCodes.firstWhere((promo)=> promo.code == code && !promo.isUsed && !promo.isExpired,
    orElse: ()=> throw Exception('Invalid or expired promo code '),
    );

    if(promoCode.isPercentage){
      final percentage = double.parse(promoCode.discount.replaceAll(RegExp(r'[^0-9.]'), ''));
      return (amount*percentage)/100;
    } else {
      return double.parse(
        promoCode.discount.replaceAll(RegExp(r'[^0-9.]'), '')
      );
    }

  }
}

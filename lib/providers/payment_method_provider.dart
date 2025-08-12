import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/payment_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PaymentMethodProvider extends ChangeNotifier {
  List<PaymentMethod> _paymentMethods = [];
  final String _storageKey = 'payment_methods';
  final _uuid = const Uuid();

  List<PaymentMethod> get paymentMethods => _paymentMethods;

  PaymentMethod? get defaultPaymentMethod {
    if (_paymentMethods.isEmpty) return null;
    return _paymentMethods.firstWhere(
          (method) => method.isDefault,
      orElse: () => _paymentMethods.first,
    );
  }

  PaymentMethodProvider() {
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedMethods = prefs.getString(_storageKey);

      if (storedMethods != null) {
        final List<dynamic> decodedMethods = jsonDecode(storedMethods);
        _paymentMethods = decodedMethods
            .map((method) => PaymentMethod.fromJson(method))
            .toList();
      } else {
        await _addSamplePaymentMethod();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading payment methods: $e');
    }
  }

  Future<void> _addSamplePaymentMethod() async {
    final sampleMethod = PaymentMethod(
      id: _uuid.v4(),
      cardType: 'Visa',
      cardNumber: '**** **** **** 1234',
      expiryDate: '12/25',
      cardHolderName: 'John Doe',
      cardColor: '0XFF1A237E',
      isDefault: true,
    );

    _paymentMethods.add(sampleMethod);
    await _savePaymentMethod();
  }

  Future<void> _savePaymentMethod() async{
    try{
      final prefs = await SharedPreferences.getInstance();
      final String encodedMethods = jsonEncode(_paymentMethods.map((method)=> method.toJson()).toList());
      await prefs.setString(_storageKey, encodedMethods);
    } catch (e){
      debugPrint('Error saving payment methods: $e');
    }
  }
  Future<void> addPaymentMethod(PaymentMethod method) async {
    final newMethod = method.copyWith(id: _uuid.v4());

    if(_paymentMethods.isEmpty || method.isDefault) {
      _paymentMethods = _paymentMethods.map((m)=> m.copyWith(isDefault: false)).toList();
    }
    _paymentMethods.add(newMethod);
    await _savePaymentMethod();
    notifyListeners();
  }
  Future<void> updatePaymentMethod(PaymentMethod method) async{
    final index = _paymentMethods.indexWhere((m)=> m.id == method.id);
    if(index != -1) {
      if(method.isDefault) {
        _paymentMethods = _paymentMethods.map((m)=> m.id == method.id? method : m.copyWith(isDefault: false)).toList();
      } else {
        if(_paymentMethods[index].isDefault && !method.isDefault && _paymentMethods.length >1) {
          final newDefault = _paymentMethods.firstWhere((m)=> m.id !=method.id);
          final defaultIndex = _paymentMethods.indexOf(newDefault);
          _paymentMethods[defaultIndex] = newDefault.copyWith(isDefault: true);
        }
        _paymentMethods[index] = method;
      }
      await _savePaymentMethod();
      notifyListeners();
    }
  }
  Future<void> deletePaymentMethod(String id) async{
    final index = _paymentMethods.indexWhere((m)=> m.id == id);
    if(index != -1){
      final wasDefault = _paymentMethods[index].isDefault;
      _paymentMethods.removeAt(index);

      if(wasDefault && _paymentMethods.isNotEmpty){
        _paymentMethods[0] = _paymentMethods[0].copyWith(isDefault: true);
      }
      await _savePaymentMethod();
      notifyListeners();
    }
  }
  Future<void> setDefaultPaymentMethod(String id) async{
    final index = _paymentMethods.indexWhere((m)=> m.id == id);
    if(index != -1){
      _paymentMethods = _paymentMethods.map((m)=> m.id == id? m.copyWith(isDefault: true) : m.copyWith(isDefault: false)).toList();
      await _savePaymentMethod();
      notifyListeners();
    }
  }
}
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/shipping_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ShippingAddressProvider extends ChangeNotifier {
  List<ShippingAddress> _addresses = [];
  final String _storageKey = 'shipping_addresses';
  final _uuid = const Uuid();

  List<ShippingAddress> get addresses => _addresses;

  ShippingAddress? get defaultAddress {
    if (_addresses.isEmpty) return null;
    return _addresses.firstWhere(
          (address) => address.isDefault,
      orElse: () => _addresses.first,
    );
  }

  ShippingAddressProvider() {
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storageAddresses = prefs.getString(_storageKey);

    if (storageAddresses != null) {
      final List<dynamic> decodedAddresses = jsonDecode(storageAddresses);
      _addresses = decodedAddresses
          .map((address) => ShippingAddress.fromJson(address))
          .toList();
    } else {
      await _addSampleAddresses();
    }
    notifyListeners();
  }

  Future<void> _addSampleAddresses() async {
    final sampleAddresses = [
      ShippingAddress(
        id: _uuid.v4(),
        name: 'Home',
        address: '123 Main Street, Apt 4B',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        phone: '+1 (123) 456-7890',
        isDefault: true,
      ),
      ShippingAddress(
        id: _uuid.v4(),
        name: 'Office',
        address: '456 Business Ave, Suite 200',
        city: 'New York',
        state: 'NY',
        zipCode: '10002',
        phone: '+1 (123) 456-7891',
      ),
    ];
    _addresses.addAll(sampleAddresses);
    await _saveAddresses();
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedAddresses = jsonEncode(
        _addresses.map((address) => address.toJson()).toList());
    await prefs.setString(_storageKey, encodedAddresses);
  }

  Future<void> addAddresses(ShippingAddress address) async {
    final newAddress = address.copyWith(id: _uuid.v4());

    if (_addresses.isEmpty || address.isDefault) {
      _addresses =
          _addresses.map((addr) => addr.copyWith(isDefault: false)).toList();
    }

    _addresses.add(newAddress);
    await _saveAddresses();
    notifyListeners();
  }

  Future<void> updateAddress(ShippingAddress address) async {
    final index = _addresses.indexWhere((addr) => addr.id == address.id);
    if (index != -1) {
      if (address.isDefault) {
        _addresses = _addresses
            .map((addr) =>
        addr.id == address.id
            ? address
            : addr.copyWith(isDefault: false))
            .toList();
      } else {
        if(_addresses[index].isDefault && !address.isDefault && _addresses.length >1){
          final newDefault = _addresses.firstWhere((addr)=> addr.id != address.id);
          final defaultIndex = _addresses.indexOf(newDefault);
          _addresses[defaultIndex] = newDefault.copyWith(isDefault: true);
        }
        _addresses[index] = address;
      }
      await   _saveAddresses();
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String id) async{
    final index = _addresses.indexWhere((addr)=> addr.id == id);
    if(index != -1){
      final wasDefault = _addresses[index].isDefault;
      _addresses.removeAt(index);

      if(wasDefault && _addresses.isNotEmpty){
        _addresses[0] = _addresses[0].copyWith(isDefault: true);
      }
      await   _saveAddresses();
      notifyListeners();
    }
  }
  Future<void> setDefaultaddress(String id) async{
final index = _addresses.indexWhere((addr)=> addr.id==id);
if(index != 1){
  _addresses = _addresses
      .map((addr)=> addr.id==id
  ? addr.copyWith(isDefault: true)
      :addr.copyWith(isDefault: false))
      .toList();

  await _saveAddresses();
  notifyListeners();
}
  }
}

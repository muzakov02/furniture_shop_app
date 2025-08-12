import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:furniture_shop_app/models/furniture.dart';
import 'package:furniture_shop_app/models/order.dart';
import 'package:furniture_shop_app/models/shipping_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  final String _storageKey = 'orders';
  final _uuid = const Uuid();

  List<Order> get orders => _orders;

  List<Order> get activeOrders =>
      _orders.where((order) => order.isActive).toList();

  List<Order> get completedOrders =>
      _orders.where((order) => order.isCompleted).toList();

  List<Order> get cancelledOrders =>
      _orders.where((order) => order.isCancelled).toList();

  OrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedOrders = prefs.getString(_storageKey);

    if (storedOrders != null) {
      final List<dynamic> decodedOrders = jsonDecode(storedOrders);
      _orders = decodedOrders.map((order) => Order.fromJson(order)).toList();
    } else {
      await _addSampleOrders();
    }
    notifyListeners();
  }

  Future<void> _addSampleOrders() async {
    final sampleFurniture = Furniture(
      id: '1',
      name: 'Modern Sofa',
      category: 'Sofa',
      price: 599.99,
      imageUrl: 'assets/images/sofa1.png',
      images: ['assets/images/sofa1.png'],
      description: 'A comfortable modern sofa',
      colors: ['Gray', 'Blue'],
    );
    final sampleAddress = ShippingAddress(
      id: '1',
      name: 'Home',
      address: '123 Main Street',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      phone: '+1 (123) 456-7890',
      isDefault: true,
    );
    final now = DateTime.now();
    final sampleOrders = [
      Order(
        id: _uuid.v4(),
        items: [
          OrderItem(
            furniture: sampleFurniture,
            quantity: 1,
            price: 599.99,
          ),
        ],
        orderDate: now.subtract(const Duration(days: 2)),
        status: OrderStatus.processing,
        subtotal: 599.99,
        shippingCost: 0,
        discount: 0,
        total: 599.99,
        shippingAddress: sampleAddress,
        estimatedDelivery: now.add(const Duration(days: 5)),
      ),
      Order(
        id: _uuid.v4(),
        items: [
          OrderItem(
            furniture: sampleFurniture,
            quantity: 1,
            price: 599.99,
          ),
        ],
        orderDate: now.subtract(const Duration(days: 15)),
        status: OrderStatus.cancelled,
        subtotal: 599.99,
        shippingCost: 0,
        discount: 0,
        total: 599.99,
        shippingAddress: sampleAddress,
      ),
    ];

    _orders.addAll(sampleOrders);
    await _saveOrders();
  }

  Future<void> _saveOrders() async{
    final prefs = await SharedPreferences.getInstance();
    final String encodedOrders = jsonEncode(_orders.map((order)=> order.toJson()).toList());
    await prefs.setString(_storageKey, encodedOrders);
  }

  Future<void> addOrder(Order order) async{
    final newOrder = order.copyWith(
      id: _uuid.v4(),
      orderDate: DateTime.now(),
      status: OrderStatus.processing,
      estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
    );

    _orders.add(newOrder);
    await _saveOrders();
    notifyListeners();
  }
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async{
    final index = _orders.indexWhere((order)=> order.id == orderId);
    if(index != -1) {
      _orders[index]= _orders[index].copyWith(status: newStatus);

      if(newStatus == OrderStatus.shipped){
        _orders[index] =  _orders[index].copyWith(
          trackingNumber: 'TRK${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      await _saveOrders();
      notifyListeners();
    }
  }
  Future<void> cancelOrder(String orderId) async{
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }
  Order? getOrderById(String orderId){
    try{
       return _orders.firstWhere((order)=>order.id == orderId);
    } catch(e){
      return null;
    }
  }
}

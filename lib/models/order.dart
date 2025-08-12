import 'package:furniture_shop_app/models/furniture.dart';
import 'package:furniture_shop_app/models/shipping_address.dart';

enum OrderStatus {
  processing,
  confirmed,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderItem {
  final Furniture furniture;
  final int quantity;
  final double price;

  OrderItem({
    required this.furniture,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'furniture': {
        'id': furniture.id,
        'name': furniture.name,
        'category': furniture.category,
        'price': furniture.price,
        'imageUrl': furniture.imageUrl,
        'images': furniture.images,
        'description': furniture.description,
        'colors': furniture.colors,
      }
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      furniture: Furniture(
        id: json['furniture']['id'],
        name: json['furniture']['name'],
        category: json['furniture']['category'],
        price: json['furniture']['price'],
        imageUrl: json['furniture']['imageUrl'],
        images: List<String>.from(json['furniture']['images']),
        description: json['furniture']['description'],
        colors: List<String>.from(json['furniture']['colors']),
      ),
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}

class Order {
  final String id;
  final List<OrderItem> items;
  final DateTime orderDate;
  final OrderStatus status;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;
  final ShippingAddress shippingAddress;
  final String? promoCode;
  final String? tracingNumber;
  final DateTime? estimatedDelivery;
  final String? paymentMethod;

  Order({
    required this.id,
    required this.items,
    required this.orderDate,
    required this.status,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.total,
    required this.shippingAddress,
    this.promoCode,
    this.tracingNumber,
    this.estimatedDelivery,
    this.paymentMethod,
  });

  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;

  bool get isCompleted => status == OrderStatus.delivered;

  bool get isCancelled => status == OrderStatus.cancelled;

  Order copyWith({
    String? id,
    List<OrderItem>? items,
    DateTime? orderDate,
    OrderStatus? status,
    double? subtotal,
    double? shippingCost,
    double? discount,
    double? total,
    ShippingAddress? shippingAddress,
    String? promoCode,
    String? trackingNumber,
    DateTime? estimatedDelivery,
    String? payment,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      promoCode: promoCode ?? this.promoCode,
      tracingNumber: tracingNumber ?? this.tracingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toString(),
      'orderDate': orderDate.toIso8601String(),
      'status': status.toString(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'discount': discount,
      'total': total,
      'shippingAddress': shippingAddress.toJson(),
      'promoCode': promoCode,
      'trackingNumber': tracingNumber,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      orderDate: DateTime.parse(json['orderDate']),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      subtotal: json['subtotal'],
      shippingCost: json['shippingCost'],
      discount: json['discount'],
      total: json['total'],
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      promoCode: json['promoCode'],
      tracingNumber: json['tracingNumber'],
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'])
          : null,
      paymentMethod: json['paymentMethod'],
    );
  }
}

import 'package:flutter/material.dart';
enum NotificationType {
  order (Icons.shopping_bag_outlined, Colors.blue),
  promotion (Icons.local_offer_outlined, Colors.orange),
  newArrival (Icons.new_releases_outlined, Colors.green),
  delivery (Icons.local_shipping_outlined, Colors.purple);

  final IconData icon;
  final Color color;

  const NotificationType(this.icon, this.color);
}

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,

  });

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,

  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'type': type,
      'isRead': isRead,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> json){
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NotificationType.values.firstWhere(
          (type)=> type.name == json['type'],
      ),
      isRead: json['isRead'] ?? false,
    );
  }
}
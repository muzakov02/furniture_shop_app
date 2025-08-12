import 'package:flutter/foundation.dart';
import 'package:furniture_shop_app/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier{
  final List<Notification> _notifications = [];
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  Map<NotificationType, bool> _notificationiPreferences = {
    NotificationType.order: true,
    NotificationType.promotion: true,
    NotificationType.newArrival: true,
    NotificationType.delivery: true,
  };

  static const String _pushEnabledKey = 'push_enabled';
  static const String _emailEnabledKey = 'email_enabled';
  static const String _preferencesKey = 'notification_preferences';

  NotificationProvider(){
    _loadPreferences();
  }

  List<Notification> get  notifications => _notifications;
  bool get pushEnabled => _pushEnabled;
  bool  get emailEnabled => _emailEnabled;
  Map<NotificationType, bool> get notificationPreferences => _notificationiPreferences;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _pushEnabled = prefs.getBool(_pushEnabledKey) ?? true;
    _emailEnabled = prefs.getBool(_emailEnabledKey) ?? true;

    for (var type in NotificationType.values) {
      final prefKey = '${_preferencesKey}_${type.name}';
      _notificationiPreferences[type]= prefs.getBool(prefKey) ?? true;
    }
    notifyListeners();
  }

  Future<void> setPushEnabled(bool value) async{
    _pushEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushEnabledKey, value);
    notifyListeners();
  }

  Future<void> setEmailEnabled(bool value) async{
    _emailEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailEnabledKey, value);
    notifyListeners();
  }

  Future<void> setNotificationPreferences(NotificationType type, bool value) async {
    _notificationiPreferences[type] = value;
    final prefs = await SharedPreferences.getInstance();
    final prefKey = '${_preferencesKey}_${type.name}';
    await prefs.setBool(prefKey, value);
    notifyListeners();
  }

  void addNotification(Notification notification) {
    if(_notificationiPreferences[notification.type] ?? false){
      _notifications.insert(0, notification);
      notifyListeners();
    }
  }
  void removeNotification(String id){
    _notifications.removeWhere((notification)=> notification.id == id);
    notifyListeners();
  }

  void  markAsRead(String id){
    final index = _notifications.indexWhere((notification)=> notification.id == id);
    if(index != -1){
      _notifications[index] =   _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void clearAll(){
    _notifications.clear();
    notifyListeners();
  }

  void addSampleNotification() {
    if(_notifications.isNotEmpty) return;

    final sampleNotifications = [
      Notification(
        id: '1',
        title: 'Order Delivery',
        message: 'Your order #ORD-2024-001 has been delivered successfully',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.order,
      ),
      Notification(
        id: '2',
        title: 'Special Offer',
        message: 'Get 20% off on all bedroom furniture this weekend! ',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.promotion,
      ),
      Notification(
        id: '3',
        title: 'New Collection',
        message: 'Check out our new minimalist collection',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.newArrival,
      ),
    ];
    for(var notification in sampleNotifications){
      if(_notificationiPreferences[notification.type] ?? false){
        addNotification(notification);
      }
    }
  }
}
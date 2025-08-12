import 'package:flutter/material.dart';
import 'package:furniture_shop_app/models/notification.dart';
import 'package:furniture_shop_app/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              _buildSettingsSection(provider),
              Divider(
                height: 16,
                color: Colors.grey.shade300,
              ),
              _buildNotificationsList(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList(NotificationProvider provider) {
    final notifications = provider.notifications;

    if (notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.notifications_none,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No notifications yet',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ll see your notifications here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                'Recent Notifications',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              TextButton(
                  onPressed: provider.clearAll, child: const Text('Clear All'))
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Dismissible(
              key: Key(notification.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                provider.removeNotification(notification.id);
              },
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: notification.type.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification.type.icon,
                    color: notification.type.color,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(notification.timestamp),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.all(12),
                onTap: () => provider.markAsRead(notification.id),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection(NotificationProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        SwitchListTile(
          value: provider.pushEnabled,
          onChanged: (value) async {
            await provider.setPushEnabled(value);
          },
          title: Text(
            'Push Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('Receive push notifications'),
        ),
        SwitchListTile(
          value: provider.emailEnabled,
          onChanged: (value) async {
            await provider.setEmailEnabled(value);
          },
          title: Text(
            'Email Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('Receive email notifications'),
        ),
        Divider(
          height: 32,
          color: Colors.grey.shade300,
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Notification Types',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...NotificationType.values.map(
          (type) {
            return SwitchListTile(
              value: provider.notificationPreferences[type] ?? false,
              onChanged: (value) async {
                await provider.setNotificationPreferences(type, value);
              },
              title: Text(
                _getNotificationTypeTitle(type),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(_gatNotificationTypeDescription(type)),
            );
          },
        ),
      ],
    );
  }

  String _getNotificationTypeTitle(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return 'Order Updates';
      case NotificationType.promotion:
        return 'Promotions';
      case NotificationType.newArrival:
        return 'New Arrivals';
      case NotificationType.delivery:
        return 'Delivery Status';
    }
  }

  String _gatNotificationTypeDescription(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return 'Updates about your orders';
      case NotificationType.promotion:
        return 'Deals and promotional offers';
      case NotificationType.newArrival:
        return 'New products and collections';
      case NotificationType.delivery:
        return 'Updates about your deliveries';
    }
  }
}

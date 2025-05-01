import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime dateTime;
  bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.dateTime,
    this.read = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'Schedule Change',
      message: 'The Flutter for Beginners session has been moved to 11:00 AM.',
      dateTime: DateTime.now().subtract(Duration(hours: 2)),
    ),
    NotificationItem(
      id: '2',
      title: 'Ticket Update',
      message: 'Your support ticket #123 has been marked as In Progress.',
      dateTime: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final notification =
          notifications.firstWhere((notification) => notification.id == id);
      notification.read = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.read = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark All Read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.message),
                  trailing: notification.read
                      ? null
                      : Icon(Icons.circle, color: Colors.blue, size: 12),
                  onTap: () => _markAsRead(notification.id),
                );
              },
            ),
    );
  }
}

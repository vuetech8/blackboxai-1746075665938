import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/event_schedule_screen.dart';
import 'screens/ticketing_support_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Conference App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/events': (context) => EventScheduleScreen(),
        '/tickets': (context) => TicketingSupportScreen(),
        '/profile': (context) => UserProfileScreen(),
        '/notifications': (context) => NotificationsScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Conference Home'),
      ),
      body: Center(
        child: Text('Welcome to the Event Conference App!'),
      ),
    );
  }
}

// Placeholder screens for routing

class EventScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Schedule'),
      ),
      body: Center(child: Text('Event Schedule Screen')),
    );
  }
}

class TicketingSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticketing & Support'),
      ),
      body: Center(child: Text('Ticketing & Support Screen')),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(child: Text('User Profile Screen')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(child: Text('Notifications Screen')),
    );
  }
}

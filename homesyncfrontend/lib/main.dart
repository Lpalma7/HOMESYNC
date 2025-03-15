import 'package:flutter/material.dart';
import 'package:homesync/screens/bar_chart_widget.dart';
import 'package:homesync/screens/electrical_usage_screen.dart';
import 'package:homesync/screens/homepage_screen.dart';
import 'package:homesync/screens/notification_screen.dart';
import 'package:homesync/screens/settings_screen.dart';
import 'package:homesync/screens/welcome_screen.dart';
import 'package:homesync/screens/signup_screen.dart';
import 'package:homesync/screens/login_screen.dart';
import 'package:homesync/screens/forgot_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/homepage': (context) => HomeScreen(),
        '/settings': (context) => SettingsPage(),
        '/electrical_usage': (context) => ElectricalUsageScreen(),
        '/notification': (context) => NotificationPage(),
        '/barchartwidget': (context) => BarChartWidget(),

      },
    );
  }
}

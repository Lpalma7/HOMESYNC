import 'package:flutter/material.dart';
import 'package:homesync/screens/welcome_screen.dart';
import 'package:homesync/screens/signup_screen.dart';
import 'package:homesync/screens/login_screen.dart';
import 'package:homesync/screens/devices_screen.dart';
import 'package:homesync/screens/forgot_password_screen.dart';
import 'package:homesync/screens/homepage_screen.dart';
import 'package:homesync/screens/rooms.dart';
import 'package:homesync/screens/adddevices.dart';
import 'package:homesync/screens/notification_screen.dart';
import 'package:homesync/screens/notification_settings.dart';
import 'package:homesync/screens/System_notif.dart';

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
        '/homepage': (context) => HomepageScreen(),
        '/devices': (context) => DevicesScreen(),
        '/rooms':(context) => Rooms(),
        '/adddevice':(context) => AddDeviceScreen(),
        '/notification':(context) => NotificationScreen(),
        '/notificationsettings':(context) => NotificationSettings(),
        '/systemnotif':(context) => SystemNotif(),
        
        

      },
    
    );
  }
}

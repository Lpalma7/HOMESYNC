import 'package:flutter/material.dart';
import 'package:homesync/deviceinfo.dart';
import 'package:homesync/welcome_screen.dart';
import 'package:homesync/signup_screen.dart';
import 'package:homesync/login_screen.dart';
import 'package:homesync/devices_screen.dart';
import 'package:homesync/forgot_password_screen.dart';
import 'package:homesync/homepage_screen.dart';
import 'package:homesync/rooms.dart';
import 'package:homesync/adddevices.dart';
import 'package:homesync/notification_screen.dart';
import 'package:homesync/notification_settings.dart';
import 'package:homesync/System_notif.dart';
import 'package:homesync/device_notif.dart';
import 'package:homesync/roomsinfo.dart';
import 'package:homesync/schedule.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:homesync/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
          name: "homeautomation",
    options: const FirebaseOptions(
      apiKey: "258697759332",
      appId: "1:258697759332:ios:7620bdfd38bcb3d13b2d71",
      messagingSenderId: "YOUR_SENDER_ID",
      projectId: "homeautomation-b6d6d",
      databaseURL: "https://homeautomation-b6d6d-default-rtdb.firebaseio.com/",
    ),
  );
  runApp(MyApp());
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
        '/devicenotif':(context) => DeviceNotif(),
        '/roominfo': (context) => Roomsinfo(RoomItem: ModalRoute.of(context)!.settings.arguments as String),
        '/schedule': (context)=> Schedule(),
       // '/profile':(context) => ProfileScreen(),
        
        

      },
    
    );
  }
}

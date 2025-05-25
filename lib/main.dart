import 'package:flutter/material.dart';
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
import 'firebase_options.dart'; // Import firebase_options.dart
import 'package:homesync/deviceinfo.dart'; // Import deviceinfo.dart
import 'package:homesync/editdevice.dart'; // Import editdevice.dart
import 'package:homesync/profile_screen.dart';
import 'package:homesync/databaseservice.dart'; // Import DatabaseService
import 'package:homesync/usage.dart'; // Import usage.dart for sumAllAppliancesKwh and sumAllAppliancesKwhr
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Trigger the appliance update chain on app startup
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
        '/roominfo': (context) => Roomsinfo(roomItem: ModalRoute.of(context)!.settings.arguments as String),
        '/schedule': (context)=> Schedule(),
        '/deviceinfo': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DeviceInfoScreen( // Changed to DeviceInfoScreen
            applianceId: args['applianceId'] as String, // Expect applianceId in args
            initialDeviceName: args['deviceName'] as String,
        // initialDeviceUsage: args['deviceUsage'] as String, // Usage will be fetched by DeviceInfoScreen
          );
        },
        '/editdevice': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return EditDeviceScreen(
            applianceId: args['applianceId'] as String, // Expect applianceId in args
          );
        },
       '/profile':(context) => ProfileScreen(),


      },

    );
  }
}

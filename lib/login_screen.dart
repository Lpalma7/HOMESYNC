import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/forgot_password_screen.dart';
import 'package:homesync/signup_screen.dart';
import 'package:homesync/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homesync/homepage_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  void _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  void _saveRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      appBar: null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 5, top: 65),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 50, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, -20),
                child: Image.asset(
                  'assets/homesync_logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('HomeSync', style: TextStyle(fontSize: 40));
                  },
                ),
              ),
            ),
            Transform.translate( //title
              offset: Offset(-55, -170),
           child: Text(
              'LOG IN',
              textAlign: TextAlign.center,
              style: GoogleFonts.jaldi(
                textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                color: Colors.black,
              ),
            ),
            ),

Transform.translate( // title
              offset: Offset(1, -70),
            child: Text(
              'HOMESYNC',
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSerif(
                textStyle: TextStyle(fontSize: 25),
                color: Colors.black,
              ),
            ),
),
            Transform.translate(
              offset: Offset(0, -30),
            child:TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Email Address',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            ),

            Transform.translate(
              offset: Offset(0, -20),
            child:TextField(
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Password',
                 hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            ),
            
            
             Transform.translate(
              offset: Offset(100, -25),
            child:TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                );  
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                  color: Colors.grey,
                ),
              ),
            ),
             ),

             Transform.translate(
              offset: Offset(-10, -70),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                        _saveRememberMe(value!);
                      },
                    ),
                    Transform.translate(
              offset: Offset(-10, -1),
                    child:Text(
                      "Remember Me",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(fontSize: 14),
                        color: Colors.grey,
                      ),
                    ),
                    ),
                  ],
                ),
              ],
            ),
             ),
            
            Transform.translate(
              offset: Offset(0, -20),
            child:ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomepageScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: BorderSide(color: Colors.black, width: 1),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.5),
              ),
              child: Text(
                'Log In',
                style: GoogleFonts.judson(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            ),

            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                'Don\'t have an account? SIGN UP',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

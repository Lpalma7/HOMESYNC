import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/screens/homepage_screen.dart';
import 'package:homesync/screens/login_screen.dart';
import 'package:homesync/screens/welcome_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      appBar: null,
      body: Padding(
        padding: EdgeInsets.all(14),
        child: ListView(  
          children: [
            Align( // Back arrow
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 5, top: 30), 
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

            Center( // logo
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
                'SIGN UP',
                textAlign: TextAlign.center,
                style: GoogleFonts.jaldi(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
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
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),

            // inputs 
            Transform.translate(
              offset: Offset(0, -20), 
              child: _buildTextField(Icons.email, 'Email Address'),
            ),

            Transform.translate(
              offset: Offset(0, -20),
              child: _buildTextField(Icons.person, 'Username'),
            ),

            Transform.translate(
              offset: Offset(0, -20),
              child: _buildTextField(Icons.house, 'House Address'),
            ),

            Transform.translate(
              offset: Offset(0, -20),
              child: _buildTextField(Icons.lock, 'Password', obscureText: true),
            ),

            Transform.translate(
              offset: Offset(0, -20), 
              child: _buildTextField(Icons.lock, 'Re-Enter Password', obscureText: true),
            ),

            Transform.translate(
              offset: Offset(0, -9),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomepageScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 13,),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.5),
                ),
                child: Text(
                  'Create Account',
                  style: GoogleFonts.judson(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

Transform.translate(
              offset: Offset(0, 5),
            child:TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Already have an account? LOG IN',
                style: GoogleFonts.inter(
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

 Widget _buildTextField(IconData icon, String hintText, {bool obscureText = false}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10,),
    child: TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent, 
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        
        ),
    ),
      );
    
    
  
}
}
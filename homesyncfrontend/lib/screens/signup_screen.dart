import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/screens/homepage_screen.dart';
import 'package:homesync/screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
Widget build(BuildContext context) { // whole frame
  return Scaffold(
    backgroundColor: const Color(0xFFE9E7E6), 
    appBar: null, 
    body: Padding(
      padding: EdgeInsets.all(12),
     
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        
            
            Align( // arrow back
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 5, top: 65), 
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 50, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            
            Center( // logo
              child: Transform.translate(
              offset: Offset(0, -20),
              child: Padding(
                padding: EdgeInsets.only(top: 1, bottom: 10),
                child: Image.asset(
                  'assets/homesync_logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return 
                    Text('HomeSync', style: TextStyle(fontSize:30));
                  },
                ),
              ),
              ),
            ),
                

                Transform.translate( // title na SIGN UP
                offset: Offset(-55, -182),
            child: Text(
              'SIGN UP',
              textAlign: TextAlign.center,
                  style: GoogleFonts.jaldi(
                  textStyle: TextStyle(fontSize: 23, fontWeight:FontWeight.bold),
                  color: Colors.black, 
            ),
            ),
),

 Transform.translate( // title na homesync
                offset: Offset(1, -80),
                child: Text(
                  'HOMESYNC',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.instrumentSerif(
                  textStyle: TextStyle(fontSize: 25,),
                  color: Colors.black, 
                  ),
                ),
                ),
             
            
             SizedBox(height: 50), // email info
            Transform.translate( 
                offset: Offset(0, -115),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true, 
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                  ),
                hintText: 'Email Address',
                border: OutlineInputBorder(),
                
              ),
            ),
            ),
            
            
            SizedBox(height: 15),
            Transform.translate( 
                offset: Offset(0, -120),
            child:TextField(
              decoration: InputDecoration(
                filled: true, 
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                  ),
                hintText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            ),
            
SizedBox(height: 15),
            Transform.translate( 
                offset: Offset(0, -125),
            child:TextField(
               keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                filled: true, 
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.house,
                  color: Colors.black,
                  ),
                hintText: 'House Address',
                border: OutlineInputBorder(),
              ),
            ),
            ),
            
SizedBox(height: 15,), // password info
            Transform.translate( 
                offset: Offset(-0, -130),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                filled: true, 
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                  ),
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
),


SizedBox(height: 15,), // password info
            Transform.translate( 
                offset: Offset(-0, -135),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                filled: true, 
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                  ),
                hintText: 'Re-Enter Password',
                border: OutlineInputBorder(),
              ),
            ),
),

Transform.translate( 
            offset: Offset(0, -115), // login btn yarn
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                backgroundColor: Colors.white,
                 shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), 
                side: BorderSide(
                color: Colors.black, 
                width: 1,
                ),
              ),
              elevation: 5, 
          shadowColor: Colors.black.withOpacity(0.5),
              ),
            child: Text(
              'Create Account ',
              style: GoogleFonts.judson(
                fontSize: 24,
                color: Colors.black, 
                ),
            ),
            ),
            ),

Transform.translate( 
                offset: Offset(3, -100),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('Already have an account? LOG IN',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey, 
                  ),
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

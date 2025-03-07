import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xE9E7E6),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/homesync_logo.png', height: 137, width: 149),
            SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'HOMESYNC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, // Larger font size
                    fontWeight: FontWeight.bold, // Make it bold
                    color: Colors.blue[900], // Different color
                  ),
                ),
                Text(
                  'A Connected Home to a Connected Life',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic, // Optional: make it italic
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('LOG IN'),
            ),
            SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('SIGN UP'),
            ),
          ],
        ),
      ),
    );
  }
}

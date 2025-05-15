import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
    title: 'Profile Account',
    theme: ThemeData(
      textTheme: GoogleFonts.jaldiTextTheme(
        Theme.of(context).textTheme,
      ),
      primaryTextTheme: GoogleFonts.jaldiTextTheme(
        Theme.of(context).primaryTextTheme,
      ),
    ),
  ); 
}
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // Controllers to handle text input
  final TextEditingController _emailController = TextEditingController(text: 'user@example.com');
  final TextEditingController _usernameController = TextEditingController(text: 'Username');
  final TextEditingController _addressController = TextEditingController(text: 'Home Address');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Padding(   // back btn
                    padding: EdgeInsets.only(left: 1, top: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 50, color: Colors.black),
                        onPressed: ()  => Navigator.of(context).pop(), 
                         
                        
                      ),
                      Text(
                        'Profile Account',
                       style: GoogleFonts.jaldi(
                        textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                        color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Home Icon and Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child:CircleAvatar(
                        backgroundColor: Colors.grey,
                      radius: 50,
                      child: Icon(Icons.home, color: Colors.black, size: 60),
                    ),
                     ),
                  
                      const SizedBox(height: 3),
                      const Text(
                        'My Home',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Profile information fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Email 
                      _buildInfoRow(
                        Icons.email,
                        'Email Address',
                        _emailController,
                        false,
                      ),
                          Transform.translate(
                  offset: Offset(0, -10),
                      child: Divider(height: 0,),

                      ),
                      
                      // Username field
                      _buildInfoRow(
                        Icons.person,
                        'Username',
                        _usernameController,
                        false,
                      ),
                      
                          Transform.translate(
                  offset: Offset(0, -10),
                      child: Divider(height: 0,),

                      ),
                      
                      // Address field
                      _buildInfoRow(
                        Icons.home,
                        'House Address',
                        _addressController,
                        false,
                      ),
                      
                      Transform.translate(
                  offset: Offset(0, -10),
                      child: Divider(height: 0,),

                      ),
                      // Password field
                      _buildInfoRow(
                        Icons.lock,
                        'Password',
                        _passwordController,
                        true,
                      ),

                         Transform.translate(
                  offset: Offset(0, -20),
                      child: Divider(height: 0,),

                      ),

                      const SizedBox(height: 20),

                      
                      ElevatedButton(
                        onPressed: () {
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Information updated')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                            side: BorderSide(color: Colors.black, width: 1),
                          ),
                          elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.5),
                        ),
                        child: Text(
                          'Update Profile',
                          style: GoogleFonts.judson(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                      ),
                      
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildInfoRow(IconData icon, String title, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                TextField(
                  controller: controller,
                  obscureText: isPassword && _obscurePassword,
                  decoration: isPassword
                      ? InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                                  size: 25,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 4),
                          isDense: true,
                          border: InputBorder.none,
                        )
                      : const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          isDense: true,
                          border: InputBorder.none,
                        ),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}
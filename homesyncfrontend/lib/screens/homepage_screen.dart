import 'package:flutter/material.dart';
import 'package:homesync/screens/welcome_screen.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:homesync/screens/electricity_usage_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/screens/notification_screen.dart';

class HomepageScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomepageScreen> {
  String selectedPeriod = 'Weekly';
  Weather? currentWeather;
  int _selectedIndex = 0; 

  @override // whole frame 
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: const Color(0xFFE9E7E6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [

///////////////////////////////////////////////////////////////////////////////////////////////////

              GestureDetector( // profile icon flyout
                onTap: () => _showFlyout(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Padding(
        padding: const EdgeInsets.only(top: 20),
                     
                    child:CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 25,
                      child: Icon(Icons.person, color: Colors.black, size: 35),
                    ),
                     ),
                    SizedBox(width: 10,),
                     Padding(
        padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'My Home',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                  ],
                ),
              ),

/////////////////////////////////////////////////////////////////////////////////////////////////////////
              Transform.translate( // weather 
                offset: Offset(195, -50),
              child:Container(  
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cloud_circle_sharp, size: 35,color: Colors.lightBlue,),
                    SizedBox(width: 4),
                    Text('27°C',
                     style: GoogleFonts.inter(
                        fontSize: 16,),
                    ),
                    Transform.translate( 
                offset: Offset(-45, 16),
                    child:Text(
                          "Today's Weather", 
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              ),
//////////////////////////////////////////////////////////////////////////////////////////////////////

              // Navigation Tabs
            Transform.translate(
  offset: Offset(-5, -20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildNavButton('Electricity', _selectedIndex == 0, 0),
      _buildNavButton('Devices', _selectedIndex == 1, 1),
      _buildNavButton('Rooms', _selectedIndex == 2, 2),
          ],
          
        ),
        
        ),

                  Transform.translate(
                offset: Offset(-1, -20),
              child: Container(
              width: 1000, 
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.black38,
              ),
            ),
            ),
          
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////           
            
              // date and usage display
              Transform.translate( 
                offset: Offset(0, -10),
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Usage',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                  
                      Row(
                        children: [
                          Text('March 10 - March 16'),
                          IconButton(
                            icon: Icon(Icons.calendar_month),
                            onPressed: () => _showPeriodPicker(),
                          ),
                        ],
                      ),
                  
                    ],
                  ),
                ],
              ),
              ),

//////////////////////////////////////////////////////////////////////////////////////////////////////           
             
            Expanded( // Usage Graph
  child: SingleChildScrollView(
    child: Column(
      children: [
        Transform.translate(
          offset: const Offset(0, 0,),
          child: Container(
            height: 300,
            width: 350,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[350], // 
              
              
            ),
            child: const ElectricityUsageChart(),
          ),
        ),
    
        _buildUsageStat(  // usage status
          'Electricity Usage',
          '250.1 kWh',
          Icons.electric_bolt,
        ),
        _buildUsageStat(      // cost usage
          'Electricity Cost',
          '1,000.00',
          Icons.attach_money,
        ),

        // Devices List
        _buildDevicesList(),
      ],
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////

void _showFlyout(BuildContext context) { //flyout na nakaka baliw ayusin
  final screenSize = MediaQuery.of(context).size;
  showModalBottomSheet(
     isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Align(
        alignment: Alignment.centerRight,
        child: Transform.translate(
          offset: Offset(-90, -0), 
          child: Container(
            width: screenSize.width * 0.75,
            height: screenSize.height -0,
            decoration: BoxDecoration(
              color: const Color(0xFF3D3D3D),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(0),
              ),
            ),

         
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

               SizedBox(height: 60),

                Row( //profile icon, name, and email display
                  children: [
                    Icon(Icons.account_circle, size: 50, color: Colors.white), 
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Home",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "emailExample@gmail.com", 
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

          SizedBox(height: 40),
          
              ListTile(
                
                leading: Icon(Icons.person, color: Colors.white,size: 35,),
                title: Text('Profile', style: GoogleFonts.inter( color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),

          SizedBox(height: 15),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.white, size: 35,),
                title: Text('Notification', style: GoogleFonts.inter(color: Colors.white)),
                 onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
              ),  

              SizedBox(height: 15),
                ListTile(
              leading: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(Icons.logout, color: Colors.white, size: 35,),
              ),
                title: Text('Logout', style: GoogleFonts.inter(color: Colors.white)),
               onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
              ),  
              ],
            ),
          ),
        ),
      );
    },
  );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

Widget _buildNavButton(String title, bool isSelected, int index) { // nav bar function
  return Column(
    children: [
      TextButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
          
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/electricity');
              break;
            case 1:
              Navigator.pushNamed(context, '/devices');
              break;
            case 2:
              Navigator.pushNamed(context, '/rooms');
              break;
          }
        },
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.black : Colors.grey[400],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 17,
          ),
        ),
      ),
      if (isSelected)
                Transform.translate(
  offset: Offset(-0, -10),
        child:Container(
          height: 2,
          width: 70,
          color: Colors.brown,
          margin: EdgeInsets.only(top: 1),
        ),
                ),
    ],
  );
}
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  
 Widget _buildUsageStat(String title, String value, IconData icon) { // usage and cost 
  return Transform.translate(
    offset: Offset(-5, 10), 
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8,),
          Text(title, style: GoogleFonts.judson(color: Colors.black,fontSize: 16)),
          Spacer(),
          Text(value, style: GoogleFonts.jaldi(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
        ],
      ),
    ),
  );
}
//////////////////////////////////////////////////////////////////////////////////////////////////

  Widget _buildDevicesList() { // devices
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('Devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _buildDeviceItem('Kitchen Plug', '24.4 kWh', Icons.power),
        _buildDeviceItem('Bedroom Light', '14.9 kWh', Icons.light),
        _buildDeviceItem('Living Room Plug', '24.4 kWh', Icons.power),
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget _buildDeviceItem(String name, String usage, IconData icon) { // device settings
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8),
          Text(name, style: GoogleFonts.judson(color: Colors.black,fontSize: 16)),
          Spacer(),
          Text(usage, style: GoogleFonts.jaldi(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
        ],
      ),
    );
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // calendar picker function
  void _showPeriodPicker() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white, 
      title: Text('Select Period',
      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: Colors.white, 
            title: Text('Monthly'),
            onTap: () {
              setState(() => selectedPeriod = 'Monthly');
              Navigator.pop(context);
            },
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Weekly'),
            onTap: () {
              setState(() => selectedPeriod = 'Weekly');
              Navigator.pop(context);
            },
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Yearly'),
            onTap: () {
              setState(() => selectedPeriod = 'Yearly');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
}
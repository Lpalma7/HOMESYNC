import 'package:flutter/material.dart';
import 'package:homesync/adddevices.dart';
import 'package:homesync/notification_screen.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:homesync/homepage_screen.dart';

import 'package:google_fonts/google_fonts.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen> {
  Weather? currentWeather;
  int _selectedIndex = 1;
  bool _masterPowerOn = true; // Added overall power control

 List<Map<String, dynamic>> devices = [ // devices command
  {'title': 'Kitchen Plug\n (Oven)', 'isOn': true, 'icon': Icons.power},
  {'title': 'Kitchen Area\n Light', 'isOn': false, 'icon': Icons.light},
  {'title': 'Living Room \nLight', 'isOn': false, 'icon': Icons.light},
  {'title': 'Bedroom\n Plug (Air-con)', 'isOn': true, 'icon': Icons.power},
  {'title': 'Living Room \n Plug (Television)', 'isOn': true, 'icon': Icons.power},
  {'title': 'Bedroom\nLight', 'isOn': false, 'icon': Icons.light},
  {'title': 'Dining Area \nPlug (Refrigerator)', 'isOn': true, 'icon': Icons.power},
];

  Set<int> _selectedDevices = {};

  // function all power toggle
  void _toggleMasterPower() {
    setState(() {
      _masterPowerOn = !_masterPowerOn;
      // all device and device connect function
      for (int i = 0; i < devices.length; i++) {
        devices[i]['isOn'] = _masterPowerOn;
      }
    });
  }

 @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Scaffold(
    backgroundColor: const Color(0xFFE9E7E6), // whole frame
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddDeviceScreen()),
        );
      },
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

              /////////////////////////////////////////////
              // Profile + Home Text + Flyout
              GestureDetector(
                onTap: () => _showFlyout(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 25,
                        child: Icon(Icons.person, color: Colors.black, size: 35),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'My Home',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////
              // Weather Info
              Transform.translate(
                offset: const Offset(195, -50),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_circle_sharp, size: 35, color: Colors.lightBlue),
                      const SizedBox(width: 4),
                      Text(
                        '27°C',
                        style: GoogleFonts.inter(fontSize: 16),
                      ),
                      Transform.translate(
                        offset: const Offset(-45, 16),
                        child: Text(
                          "Today's Weather",
                          style: GoogleFonts.inter(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ////////////////////////////////////////////////////////////
              // Navigation Tabs
              Transform.translate(
                offset: const Offset(-5, -20),
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
                offset: const Offset(-1, -20),
                child: const SizedBox(
                  width: 1000,
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black38,
                  ),
                ),
              ),
              ////////////////////////////////////////////////////////////
             
              Expanded(
                child: Column(
                  children: [
                    // Search Bar and Power Toggle
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 47,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Color(0xFFD9D9D9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // main Power Toggle Button
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _masterPowerOn ? Colors.black : Colors.grey,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.power_settings_new,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: _toggleMasterPower,
                              tooltip: 'Master Power',
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    //////////////////////////////////////////////////////////////////
                    // Switch Controls adjustments
                    const SizedBox(height: 25),
                    Expanded(
                      child: Stack(
                        children: [
                        
                          GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 70), 
                            itemCount: devices.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final device = devices[index];
                              final isSelected = _selectedDevices.contains(index);
                              return GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    _selectedDevices.contains(index)
                                        ? _selectedDevices.remove(index)
                                        : _selectedDevices.add(index);
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    //indiv device power
                                    devices[index]['isOn'] = !devices[index]['isOn'];
                                  });
                                },
                                child: Container( //container design and delete
                                  decoration: BoxDecoration(
                                    color: device['isOn'] ? Colors.black : Colors.white, 
                                    border: Border.all(
                                      color: isSelected ? Colors.red: Colors.transparent,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DeviceCard(
                                    title: device['title'],
                                    isOn: device['isOn'],
                                    icon: device['icon'],
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          if (_selectedDevices.isNotEmpty) // delete
                            Transform.translate(
                             offset: const Offset(200, 385),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent.withOpacity(0),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.transparent.withOpacity(0),
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 50),
                                  onPressed: () {
                                    setState(() {
                                     
                                      List<int> indexesToRemove = _selectedDevices.toList()..sort((a, b) => b.compareTo(a));
                                      for (int index in indexesToRemove) {
                                        devices.removeAt(index);
                                      }
                                      _selectedDevices.clear();
                                    });
                                  },
                                ),
                              ),
                            ),
                        ],
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

  //////////////////////////////////////////////////////////////////////////////////
  // Flyout Menu
  void _showFlyout(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: const Offset(-90, 0),
            child: Container(
              width: screenSize.width * 0.75,
              height: screenSize.height,
              decoration: const BoxDecoration(
                color: Color(0xFF3D3D3D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, size: 50, color: Colors.white),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Home",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "emailExample@gmail.com",
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white, size: 35),
                    title: Text('Profile', style: GoogleFonts.inter(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.white, size: 35),
                    title: Text('Notification', style: GoogleFonts.inter(color: Colors.white)),
                    onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
              ),  
                  
                  const SizedBox(height: 15),
                  ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.logout, color: Colors.white, size: 35),
                    ),
                    title: Text('Logout', style: GoogleFonts.inter(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/welcome');
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

  ////////////////////////////////////////////////////////////////////////////////////////////
  // Navigation Button
  Widget _buildNavButton(String title, bool isSelected, int index) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() => _selectedIndex = index);
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/homepage');
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
            offset: const Offset(0, -10),
            child: Container(
              height: 2,
              width: 70,
              color: Colors.brown,
              margin: const EdgeInsets.only(top: 1),
            ),
          ),
      ],
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String title;
  final bool isOn;
  final IconData icon;

  const DeviceCard({
    super.key,
    required this.title,
    required this.isOn,
    required this.icon,
  });

  //////////////////////////////////////////////////////////////////////////////////////
 @override
Widget build(BuildContext context) {   // button design settings
  return Container(
    width: 140,
    decoration: BoxDecoration(
    
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isOn ? Colors.white : Colors.black,
        width: 3,
      ),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Icon(icon, color: isOn ? Colors.white : Colors.grey),
        const SizedBox(height: 1),
        
        Transform.translate(
          offset: const Offset(0, 4), 
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isOn ? Colors.white : Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Transform.translate(
          offset: const Offset(0, 5),
          child: Text(
            isOn ? 'ON' : 'Off',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isOn ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}
}
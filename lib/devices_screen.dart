import 'package:flutter/material.dart';
import 'package:homesync/adddevices.dart';
import 'package:homesync/notification_screen.dart';
import 'package:weather/weather.dart';
import 'package:homesync/welcome_screen.dart';
import 'package:homesync/deviceinfo.dart';
import 'package:homesync/relay_state.dart';
import 'package:homesync/databaseservice.dart';
import 'package:google_fonts/google_fonts.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen> {
  Weather? currentWeather;
  int _selectedIndex = 1;

  List<Map<String, dynamic>> devices = [
    {
      'applianceName': 'Oven', 
      'roomName': 'Kitchen Area', 
      'deviceType': 'Socket 1',
      'relay': 'relay1', 
      'icon': Icons.power
    },

    {
      'applianceName': 'Light 1', 
      'roomName': 'Kitchen Area', 
      'deviceType': 'Light',
      'relay': 'relay2', 
      'icon': Icons.light
    },
    {
      'applianceName': 'Light 2', 
      'roomName': 'Living Area', 
      'deviceType': 'Light',
      'relay': 'relay3', 
      'icon': Icons.light
    },
    {
      'applianceName': 'Air-con', 
      'roomName': 'Bedroom', 
      'deviceType': 'Socket 2',
      'relay': 'relay4', 
      'icon': Icons.power
    },
    {
      'applianceName': 'Television', 
      'roomName': 'Living Area', 
      'deviceType': 'Socket 3',
      'relay': 'relay5', 
      'icon': Icons.power
    },

    {
      'applianceName': 'Light 3', 
      'roomName': 'Bedroom', 
      'deviceType': 'Light',
      'relay': 'relay6', 
      'icon': Icons.light
    },

    {
      'applianceName': 'Refrigerator', 
      'roomName': 'Dining Area', 
      'deviceType': 'Socket 4',
      'relay': 'relay7', 
      'icon': Icons.power
    },

    {
      'applianceName': 'Rice-cooker', 
      'roomName': ' Kitchen Area', 
      'deviceType': 'Socket 5',
      'relay': 'relay8', 
      'icon': Icons.power
    },

    {
      'applianceName': 'Fan', 
      'roomName': 'Living Area', 
      'deviceType': 'Socket 6',
      'relay': 'relay8', 
      'icon': Icons.power
    },
  ];

  // function all power toggle
  void _toggleMasterPower() {
    bool newMasterState = !RelayState.relayStates['relay8']!;
    setState(() {
      RelayState.relayStates['relay8'] = newMasterState;
      for (int i = 1; i <= 7; i++) {
        String relayKey = 'relay$i';
        RelayState.relayStates[relayKey] = newMasterState;
      }
    });
    // Update Firebase
    DatabaseService().updateDeviceData('relay8', newMasterState ? 1 : 0);
    for (int i = 1; i <= 7; i++) {
      String relayKey = 'relay$i';
      DatabaseService().updateDeviceData(relayKey, newMasterState ? 1 : 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRelayStates();
  }

  Future<void> _fetchRelayStates() async {
    DatabaseService dbService = DatabaseService();
    for (String relay in RelayState.relayStates.keys) {
      Map<String, dynamic>? data = await dbService.read(path: relay);
      if (data != null && data['state'] != null) {
        RelayState.relayStates[relay] = data['state'] == 1;
      }
    }
    setState(() {});
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
                          child: SizedBox(
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
                              color: RelayState.relayStates['relay8']! ? Colors.black : Colors.grey,
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
                      child: GridView.builder(
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
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                String relayPath = device['relay'];
                                bool newState = !RelayState.relayStates[relayPath]!;
                                RelayState.relayStates[relayPath] = newState;
                                DatabaseService().updateDeviceData(relayPath, newState ? 1 : 0);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: RelayState.relayStates[device['relay']]! 
                                    ? Colors.black 
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DeviceCard(
                                applianceName: device['applianceName'] as String,
                                roomName: device['roomName'] as String,
                                deviceType: device['deviceType'] as String,
                                isOn: RelayState.relayStates[device['relay']] ?? false,
                                icon: device['icon'],
                              ),
                            ),
                          );
                        },
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
  final String applianceName;
  final String roomName;
  final String deviceType;
  final bool isOn;
  final IconData icon;

  const DeviceCard({
    super.key,
    required this.applianceName,
    required this.roomName,
    required this.deviceType,
    required this.isOn,
    required this.icon,
  });

  //////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [     // box switch container
        Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isOn ? Colors.white : Colors.black,
              width: 4,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Icon(icon, color: isOn ? Colors.white : Colors.black, size: 35,),
              const SizedBox(height: 1),
              
              // Appliance Name
              Text(
                applianceName,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isOn ? Colors.white : Colors.black,
                ),
              ),
              
              // Room Name
              Text(
                roomName,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isOn ? Colors.white : Colors.black,
                ),
              ),
              
              // Device Type
              Text(
                deviceType,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isOn ? Colors.white : Colors.black,
                ),
              ),
              
              const SizedBox(height: 1),
              Text(  // status 
                isOn ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isOn ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        
        // Edit btn in corner
        Positioned(
          top: 10,
          right: 9,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context, 
                '/schedule', 
                arguments: {
                  'applianceName': applianceName,
                  'roomName': roomName,
                  'deviceType': deviceType
                }
              );
            },
            child: Container(    
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isOn ? Colors.white30 : Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                size: 16,
                color: isOn ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/adddevices.dart';

class Roomsinfo extends StatefulWidget {
  final String RoomItem;

  const Roomsinfo({super.key, required this.RoomItem});

  @override
  State<Roomsinfo> createState() => RoomsinfoState();
}

class RoomsinfoState extends State<Roomsinfo> {
  bool _masterPowerOn = true; 
  int _selectedIndex = 1;

  // device list
  List<Map<String, dynamic>> devices = [
    {'title': 'Bedroom\n Plug (Air-con)', 'isOn': true, 'icon': Icons.power},
    {'title': 'Bedroom\nLight', 'isOn': false, 'icon': Icons.light},
  ];

  Set<int> _selectedDevices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      floatingActionButton: FloatingActionButton(
        onPressed: () { // add btn and frame
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
              
              Container(
                padding: EdgeInsets.only(left: 1, top: 30), // back
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 50, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Transform.translate( //title
                      offset: Offset(5, -1),
                      child: Text(
                        widget.RoomItem,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jaldi(
                          textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), 
              Expanded(
                child: Stack(
                  children: [
                    // Devices Grid
                    GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 30),
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
                              // Individual device power
                              devices[index]['isOn'] = !devices[index]['isOn'];
                            });
                          }, 
                          child: Container( // delete and on off design
                            decoration: BoxDecoration(
                              color: device['isOn'] ? Colors.black : Colors.white,
                              border: Border.all(
                                color: isSelected ? Colors.red : Colors.transparent, 
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
                    
                    // Delete button 
                    if (_selectedDevices.isNotEmpty)
                      Transform.translate(
                        offset: const Offset(200, 515),
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
      ),
    );
  }
}

// DeviceCard 
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

  @override
  Widget build(BuildContext context) { // container device design
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
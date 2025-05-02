import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/adddevices.dart';
import 'package:homesync/relay_state.dart';
import 'package:homesync/databaseservice.dart';

class Roomsinfo extends StatefulWidget {
  final String RoomItem;

  const Roomsinfo({super.key, required this.RoomItem});

  @override
  State<Roomsinfo> createState() => RoomsinfoState();
}

class RoomsinfoState extends State<Roomsinfo> {
  final Set<int> _selectedDevices = {};
  late List<Map<String, dynamic>> devices;

  // Room-to-devices mapping
  final Map<String, List<Map<String, dynamic>>> _roomDevices = {
    'Kitchen': [
      {'title': 'Kitchen Plug\n(Oven)', 'relay': 'relay1', 'icon': Icons.power},
      {'title': 'Kitchen Area\nLight', 'relay': 'relay2', 'icon': Icons.light},
    ],
    'Living Room': [
      {'title': 'Living Room\nLight', 'relay': 'relay3', 'icon': Icons.light},
      {'title': 'Living Room Plug\n(Television)', 'relay': 'relay5', 'icon': Icons.power},
    ],
    'Bedroom': [
      {'title': 'Bedroom Plug\n(Air-con)', 'relay': 'relay4', 'icon': Icons.power},
      {'title': 'Bedroom\nLight', 'relay': 'relay6', 'icon': Icons.light},
    ],
    'Dining Area': [
      {'title': 'Dining Area Plug\n(Refrigerator)', 'relay': 'relay7', 'icon': Icons.power},
    ],
  };

  @override
  void initState() {
    super.initState();
    // Initialize devices based on selected room
    devices = _roomDevices[widget.RoomItem] ?? [];
    _fetchRelayStates();
  }

  Future<void> _fetchRelayStates() async {
    DatabaseService dbService = DatabaseService();
    for (var device in devices) {
      String relayPath = device['relay'];
      Map<String, dynamic>? data = await dbService.read(path: relayPath);
      if (data != null && data['state'] != null) {
        RelayState.relayStates[relayPath] = data['state'] == 1;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddDeviceScreen())),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 50, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      widget.RoomItem,
                      style: GoogleFonts.jaldi(
                        textStyle: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    GridView.builder(
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
                          onLongPress: () => setState(() => _selectedDevices.contains(index) 
                              ? _selectedDevices.remove(index) 
                              : _selectedDevices.add(index)),
                          onTap: () {
                            setState(() {
                              String relayPath = device['relay'];
                              bool newState = !(RelayState.relayStates[relayPath] ?? false);
                              RelayState.relayStates[relayPath] = newState;
                              DatabaseService().updateDeviceData(relayPath, newState ? 1 : 0);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: RelayState.relayStates[device['relay']]! 
                                  ? Colors.black 
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected ? Colors.red : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DeviceCard(
                              title: device['title'],
                              isOn: RelayState.relayStates[device['relay']]!,
                              icon: device['icon'],
                            ),
                          ),
                        );
                      },
                    ),
                    if (_selectedDevices.isNotEmpty)
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 50),
                          onPressed: () {
                            setState(() {
                              List<int> indexes = _selectedDevices.toList()..sort((a, b) => b.compareTo(a));
                              for (int index in indexes) {
                                String relayPath = devices[index]['relay'];
                                DatabaseService().delete(path: relayPath);
                                RelayState.relayStates.remove(relayPath);
                                devices.removeAt(index);
                              }
                              _selectedDevices.clear();
                            });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isOn ? Colors.white : Colors.black,
          width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isOn ? Colors.white : Colors.grey),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: isOn ? Colors.white : Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            isOn ? 'ON' : 'Off',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isOn ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
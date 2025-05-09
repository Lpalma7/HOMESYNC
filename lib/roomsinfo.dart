import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/adddevices.dart';
import 'package:homesync/relay_state.dart';
import 'package:homesync/databaseservice.dart';
import 'package:homesync/room_data_manager.dart'; 

class Roomsinfo extends StatefulWidget {
  final String RoomItem;

  const Roomsinfo({super.key, required this.RoomItem});

  @override
  State<Roomsinfo> createState() => RoomsinfoState();
}

class RoomsinfoState extends State<Roomsinfo> {
  late List<Map<String, dynamic>> devices;
  final RoomDataManager _roomDataManager = RoomDataManager(); // room data manager

  @override
  void initState() {
    super.initState();
    devices = _roomDataManager.roomDevices[widget.RoomItem] ?? [];
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
                child: GridView.builder(
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DeviceCard(
                          applianceName: device['applianceName'] as String,
                          roomName: device['roomName'] as String,
                          deviceType: device['deviceType'] as String,
                          isOn: RelayState.relayStates[device['relay']]!,
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
      ),
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
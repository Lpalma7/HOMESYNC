import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For DocumentSnapshot if needed, though service might hide it
import 'dart:async';
import 'package:homesync/databaseservice.dart'; // Import DatabaseService

class DeviceInfoScreen extends StatefulWidget {
  final String applianceId; // e.g., "light1", "socket2"
  final String initialDeviceName;
  // deviceUsage might be better fetched directly or calculated from Firestore data
  // For now, let's assume it might be passed or derived.
  // final String initialDeviceUsage;

  const DeviceInfoScreen({
    super.key,
    required this.applianceId,
    required this.initialDeviceName,
    // required this.initialDeviceUsage,
  });

  @override
  DeviceInfoScreenState createState() => DeviceInfoScreenState();
}

class DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DatabaseService _dbService = DatabaseService();
  StreamSubscription? _applianceSubscription;

  // State variables to hold data from Firestore and for editing
  bool _isDeviceOn = false;
  String _currentDeviceName = "";
  String _currentDeviceUsage = "0 kWh"; // Default or placeholder
  
  // Editable fields
  late TextEditingController _nameController;
  late TextEditingController _roomController;
  late TextEditingController _typeController;
  TextEditingController _kWhRateController = TextEditingController(text: "0.0"); // Initialize immediately
  IconData _selectedIcon = Icons.devices; // State for selected icon
  
  // Add state variable for device type dropdown
  String _deviceType = 'Light'; // Default value


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDeviceName);
    _roomController = TextEditingController(); // Will be populated from fetched data
    _typeController = TextEditingController(); // Will be populated from fetched data
    _listenToApplianceData();
  }

  @override
  void dispose() {
    _applianceSubscription?.cancel();
    _nameController.dispose();
    _roomController.dispose();
    _typeController.dispose();
    _kWhRateController.dispose(); // Dispose the new controller
    super.dispose();
  }

  void _listenToApplianceData() {
    final userId = _dbService.getCurrentUserId();
    if (userId == null) {
      print("User not logged in, cannot listen to appliance data.");
      // Handle not logged in state, maybe show an error or default view
      if (mounted) {
        setState(() {
          _currentDeviceName = "Error: Not logged in";
        });
      }
      return;
    }

    _applianceSubscription = _dbService.streamDocument(
      collectionPath: 'users/$userId/appliances',
      docId: widget.applianceId,
    ).listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (mounted) {
          setState(() {
            _isDeviceOn = (data['applianceStatus'] == 'ON');
            _currentDeviceName = data['applianceName'] ?? widget.initialDeviceName;
            
            // Populate editing fields
            _nameController.text = _currentDeviceName;
            _roomController.text = data['roomName'] ?? "";
            _deviceType = data['deviceType'] ?? "Light"; // Set the device type for dropdown
            _typeController.text = _deviceType; // Keep controller synced for compatibility
            _selectedIcon = IconData(data['icon'] ?? Icons.devices.codePoint, fontFamily: 'MaterialIcons');
            
            
            _kWhRateController.text = data['kWhRate']?.toString() ?? "0.0";

            // Update usage display. You might want to format this.
            // Example: using 'kwh' or 'presentHourlyusage'
            double kwh = (data['kwh'] is num) ? (data['kwh'] as num).toDouble() : 0.0;
            _currentDeviceUsage = "${kwh.toStringAsFixed(1)} kWh";

            // _presentHourlyUsage = (data['presentHourlyusage'] is num) ? (data['presentHourlyusage'] as num).toStringAsFixed(2) : "0.0";

          });
        }
      } else {
        if (mounted) {
          setState(() {
            _currentDeviceName = "Appliance not found";
            _isDeviceOn = false;
          });
        }
        print("Appliance document ${widget.applianceId} does not exist.");
      }
    }, onError: (error) {
      print("Error listening to appliance ${widget.applianceId}: $error");
      if (mounted) {
        setState(() {
          _currentDeviceName = "Error loading data";
        });
      }
    });
  }

  Future<void> _toggleDeviceStatus(bool newStatus) async {
    final newStatusString = newStatus ? 'ON' : 'OFF';
    try {
      final userId = _dbService.getCurrentUserId();
      if (userId == null) {
        print("User not logged in, cannot update appliance status.");
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appliances')
          .doc(widget.applianceId)
          .update({'applianceStatus': newStatusString});
      // Optimistic update, or rely on stream to update _isDeviceOn
      // setState(() {
      //   _isDeviceOn = newStatus;
      // });
    } catch (e) {
      print("Error updating appliance status: $e");
      // Show a snackbar or error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update status: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _updateDeviceDetails() async {
    final userId = _dbService.getCurrentUserId();
    if (userId == null) {
      print("User not logged in, cannot update appliance details.");
      return;
    }

   
    double kWhRate = double.tryParse(_kWhRateController.text) ?? 0.0;
    
    final updatedData = {
      'applianceName': _nameController.text,
      'roomName': _roomController.text,
      'deviceType': _deviceType, // Use _deviceType instead of _typeController.text
      'icon': _selectedIcon.codePoint,
      'kWhRate': kWhRate, 
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('appliances')
          .doc(widget.applianceId)
          .update(updatedData);

      print("Appliance details updated successfully for ${widget.applianceId}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Device details updated successfully!")),
        );
      }
    } catch (e) {
      print("Error updating appliance details: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update details: ${e.toString()}")),
        );
      }
    }
  }

  // Method to show the icon picker dialog
  void _showIconPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE9E7E6),
          title: Text('Select an Icon',
          style: GoogleFonts.jaldi(
          fontWeight: FontWeight.bold
          ),
          ),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _getCommonIcons().map((IconData icon) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        
                        color: _selectedIcon.codePoint == icon.codePoint
                            ? Colors.grey[300]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
              style: GoogleFonts.jaldi(
               textStyle: TextStyle(fontSize: 18, color: Colors.black87),       
                
              ),
            ),
            ),
          ],
        );
      },
    );
  }

  // List of common icons for devices
  List<IconData> _getCommonIcons() {
    return [
      Icons.lightbulb_outline,
      Icons.power_outlined,
      Icons.power_settings_new,
      Icons.ac_unit_outlined,
      Icons.tv_outlined,
      Icons.air_outlined,
      Icons.device_thermostat,
      Icons.kitchen,
      Icons.water_drop_outlined,
      Icons.microwave_outlined,
      Icons.coffee_maker_outlined,
      Icons.speaker_outlined,
      Icons.computer_outlined,
      Icons.router_outlined,
      Icons.videogame_asset_outlined,
      Icons.camera_outlined,
      Icons.shower_outlined,
      Icons.local_laundry_service_outlined,
      Icons.devices_other_outlined,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding( // back btn
                  padding: EdgeInsets.only(left: 1, top: 8),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, size: 50, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(height: 8),
                Transform.translate(
                  offset: Offset(65, -58),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100, // Fix overflow by constraining width
                    child: Text(
                      _currentDeviceName, // Use state variable
                      style: GoogleFonts.jaldi(
                        textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Device Status
                Transform.translate(
                  offset: Offset(0, -50),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration( //container
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible( // Added Flexible to prevent overflow
                              child: Row(
                                children: [
                                  Icon(
                                    _getIconForDevice(_currentDeviceName), // icon status design
                                    size: 30,
                                    color: _isDeviceOn ? Colors.black : Colors.grey,
                                  ),
                                  SizedBox(width: 12),
                                  Flexible( // Added Flexible to prevent overflow
                                    child: Text(
                                      _currentDeviceName, // Use state variable
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis, // Handle text overflow
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isDeviceOn,
                              onChanged: (value) {
                                _toggleDeviceStatus(value);
                              },
                              activeColor: Colors.white,
                              activeTrackColor: Colors.black,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Current Status",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8), // on off label
                        Text(
                          _isDeviceOn ? "ON" : "OFF",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _isDeviceOn ? Colors.black : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Energy Usage
                Transform.translate(
                  offset: Offset(0, -30),
                  child: Text(
                    "Energy Usage",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Energy Stats
                Transform.translate(
                  offset: Offset(0, -15),
                  child: _buildEnergyStatCard(
                    "Total Usage", // This might be 'kwh' from appliance data
                    _currentDeviceUsage, // Use state variable
                    "Accumulated", // Or "This Week" if you calculate it
                    Icons.electric_bolt,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -5),
                  child: _buildEnergyStatCard(
                    "Average Daily Usage", // This would need calculation based on more data
                     // Placeholder, actual calculation needed
                    "${((double.tryParse(_currentDeviceUsage.replaceAll(" kWh", "")) ?? 0) / 7).toStringAsFixed(1)} kWh",
                    "Per Day (Example)",
                    Icons.query_stats,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 5),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.attach_money, color: Colors.blue),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "kWh Rate",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              TextField(
                                controller: _kWhRateController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  
                                  hintText: "Enter KWH rate",
                                  suffixText: "₱/kWh",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Editing Section
                Text(
                  "Appliance Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Appliance Name',
                    labelStyle: GoogleFonts.jaldi(
                      fontSize: 20,
                      
                    ),
                     border: OutlineInputBorder(),
                  ),
                ),
                
                SizedBox(height: 8),
                TextField(
                  controller: _roomController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Room Name',
                    labelStyle: GoogleFonts.jaldi(
                      fontSize: 20,
                      
                    ),
                     border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                // Replace TextField with DropdownButtonFormField for device type
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Device Type',
                    labelStyle: GoogleFonts.jaldi(
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: Colors.grey[200],
                  style: GoogleFonts.jaldi(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  value: _deviceType,
                  items: ['Light', 'Socket'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _deviceType = value!;
                      _typeController.text = value; // Keep the controller in sync
                    });
                  },
                ),
                SizedBox(height: 8),
                
                Transform.translate(
                    offset: Offset(-0, -0),
               child:  Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(_selectedIcon),
                    TextButton(
                      
                      onPressed: _showIconPickerDialog, 
                      child: Text('Change Icon',
                      style: GoogleFonts.jaldi(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                      ),
                    ),
                    ),
                  ],
                ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
      side: BorderSide(color: Colors.black, width: 1),
    )
                  ),
                  onPressed: _updateDeviceDetails,
                  child: Text('Save Changes',
                  style: GoogleFonts.judson(
                      fontSize: 20,
                      color: Colors.black,
                  ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnergyStatCard(String title, String value, String period, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Added margin for spacing
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          SizedBox(width: 16),
          Expanded( // Added Expanded to prevent overflow if text is long
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  period,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForDevice(String deviceName) {
    // Normalize deviceName for robust matching
    final name = deviceName.toLowerCase();
    if (name.contains("light")) {
      return Icons.lightbulb_outline; // Using a more common light icon
    } else if (name.contains("socket") || name.contains("plug")) {
      return Icons.power_outlined;
    } else if (name.contains("ac") || name.contains("air conditioner") || name.contains("aircon")) {
      return Icons.ac_unit_outlined;
    } else if (name.contains("tv") || name.contains("television")) {
      return Icons.tv_outlined;
    } else if (name.contains("fan")) {
      return Icons.air_outlined;
    }
    return Icons.devices_other_outlined; // A generic fallback
  }
}
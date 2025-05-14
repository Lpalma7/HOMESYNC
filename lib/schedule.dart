import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/databaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp or FieldValue if needed

// Device class can be removed if not used for local list management anymore,
// or kept if there's a reason for it. For now, it's not directly used for Firestore interaction.
/*
class Device {
  // ... (original Device class)
}
*/

class Schedule extends StatefulWidget {
  final Map<String, dynamic>? routeArgs; // Expects {'applianceId': 'xyz', ...otherData} for editing

  const Schedule({super.key, this.routeArgs});

  @override
  State<Schedule> createState() => ScheduleState();
}

class ScheduleState extends State<Schedule> {
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController applianceNameController = TextEditingController();
  final TextEditingController kwhController = TextEditingController();
  // final TextEditingController roomController = TextEditingController(); // Not directly used for selectedRoom
  final TextEditingController socketController = TextEditingController(); // For relay name

  final _formKey = GlobalKey<FormState>();

  String deviceType = 'Light';
  String? selectedRoom;
  List<String> rooms = ['Living Area', 'Kitchen Area', 'Bedroom', 'Dining Area']; // Can be dynamic later
  Map<String, IconData> roomIcons = {
    'Living Area': Icons.living,
    'Kitchen Area': Icons.kitchen,
    'Bedroom': Icons.bed,
    'Dining Area': Icons.dining,
  };

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final Map<String, Map<String, TimeOfDay>> presetTimes = {
    'Morning': {'start': TimeOfDay(hour: 6, minute: 0), 'end': TimeOfDay(hour: 12, minute: 0)},
    'Afternoon': {'start': TimeOfDay(hour: 12, minute: 0), 'end': TimeOfDay(hour: 18, minute: 0)},
    'Evening': {'start': TimeOfDay(hour: 18, minute: 0), 'end': TimeOfDay(hour: 23, minute: 0)},
  };

  final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  Map<String, bool> selectedDays = {
    'Mon': false, 'Tue': false, 'Wed': false, 'Thu': false, 'Fri': false, 'Sat': false, 'Sun': false,
  };

  IconData selectedIcon = Icons.device_hub; // Default icon

  bool isEditing = false;
  String? editingApplianceId; // Firestore document ID of the appliance being edited
  Map<String, dynamic>? _initialApplianceData; // To store original data for status preservation

  String? applianceNameError;
  String? kwhError;
  String? roomError;
  String? socketError; // For relay
  String? timeError;
  String? daysError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = widget.routeArgs ?? (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?);

    if (args != null && args['applianceId'] != null) {
      isEditing = true;
      editingApplianceId = args['applianceId'] as String;
      // Fetch full appliance data to populate the form accurately
      _loadApplianceDataForEditing(editingApplianceId!);
    } else if (args != null) {
        // If args are present but no applianceId, it might be pre-fill for a new device
        // This logic can be expanded if needed, e.g. pre-filling from AddDeviceScreen arguments
        applianceNameController.text = args['applianceName'] ?? '';
        selectedRoom = args['roomName'];
        deviceType = args['deviceType'] ?? 'Light';
        // Icon might need to be derived or passed
    }
  }

  Future<void> _loadApplianceDataForEditing(String applianceId) async {
    DocumentSnapshot<Map<String, dynamic>>? snapshot = await _dbService.getDocument(
        collectionPath: 'users/${_dbService.getCurrentUserId()}/appliances',
        docId: applianceId
    );

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data()!;
      _initialApplianceData = data; // Store initial data

      setState(() {
        applianceNameController.text = data['applianceName'] ?? '';
        kwhController.text = (data['kwh'] ?? 0.0).toString();
        selectedRoom = data['roomName'];
        deviceType = data['deviceType'] ?? 'Light';
        selectedIcon = IconData(data['icon'] ?? Icons.device_hub.codePoint, fontFamily: 'MaterialIcons');
        socketController.text = data['relay'] ?? ''; // For 'Socket' type

        if (data['startTime'] != null) {
          final stParts = (data['startTime'] as String).split(':');
          startTime = TimeOfDay(hour: int.parse(stParts[0]), minute: int.parse(stParts[1]));
        }
        if (data['endTime'] != null) {
          final etParts = (data['endTime'] as String).split(':');
          endTime = TimeOfDay(hour: int.parse(etParts[0]), minute: int.parse(etParts[1]));
        }

        final daysList = List<String>.from(data['days'] ?? []);
        selectedDays.forEach((key, value) {
          selectedDays[key] = daysList.contains(key);
        });
      });
    } else {
      print("Error: Could not load appliance data for editing.");
      // Handle error, maybe pop screen or show message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not load device data for ID: $applianceId"))
        );
        Navigator.of(context).pop();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Main scaffold and form structure (largely similar to AddDeviceScreen)
    // ... (Keep the existing build method structure from Schedule.dart)
    // Replace _buildRequiredTextField calls if they were different from AddDeviceScreen
    // Ensure all controllers and state variables are used correctly.
    // The submit button will call _validateAndSubmitDevice
     return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      appBar: null,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Transform.translate(
                      offset: Offset(0.0, 20),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, size: 50, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: Offset(-50, -30), // Adjusted to match AddDeviceScreen if needed
                    child: Text(
                      isEditing ? 'Edit Schedule' : 'Set Schedule', // Title reflects purpose
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jaldi(
                        textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  Transform.translate(
                    offset: Offset(0, -15),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[400],
                      ),
                      child: IconButton(
                        color: Colors.black,
                        iconSize: 60,
                        icon: Icon(selectedIcon),
                        onPressed: () => _pickIcon(),
                      ),
                    ),
                  ),

                  _buildRequiredTextField(
                    applianceNameController,
                    "Appliance Name",
                    Icons.device_hub,
                    errorText: applianceNameError
                  ),

                  _buildRequiredTextField(
                    kwhController,
                    "KWH", // Changed from KWPH for consistency
                    Icons.energy_savings_leaf,
                    keyboardType: TextInputType.number,
                    errorText: kwhError
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              selectedRoom != null ? (roomIcons[selectedRoom] ?? Icons.home) : Icons.home,
                              size: 30,
                              color: Colors.black
                            ),
                            labelText: 'Room',
                            labelStyle: GoogleFonts.jaldi(
                              textStyle: TextStyle(fontSize: 20),
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            errorText: roomError,
                          ),
                          dropdownColor: Colors.grey[200],
                          style: GoogleFonts.jaldi(
                            textStyle: TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                          value: selectedRoom,
                          items: rooms.map((room) {
                            return DropdownMenuItem(
                              value: room,
                              child: Text(room),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRoom = value;
                              roomError = null;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Room is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, size: 30, color: Colors.black),
                        onPressed: _addRoomDialog,
                      )
                    ],
                  ),

                  SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Device Type',
                      labelStyle: GoogleFonts.jaldi(
                        textStyle: TextStyle(fontSize: 20),
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                    ),
                    dropdownColor: Colors.grey[200],
                    style: GoogleFonts.jaldi(
                      textStyle: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    value: deviceType,
                    items: ['Light', 'Socket'].map((type) { // Add other types if necessary
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        deviceType = value!;
                        if (deviceType == 'Light') {
                          socketError = null; // Clear socket error if type changes to Light
                          socketController.clear(); // Clear relay controller
                        }
                      });
                    },
                  ),

                  if (deviceType == 'Socket') ...[
                    SizedBox(height: 5),
                    _buildRequiredTextField( // Using the same text field builder
                      socketController,
                      "Relay Name", // Changed label to Relay Name
                      Icons.electrical_services,
                      hint: "Enter relay identifier",
                      errorText: socketError
                    ),
                  ],

                  SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: timeError != null ? Colors.red : Colors.black
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                leading: Icon(Icons.access_time, color: Colors.black),
                                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                title: Text(
                                  startTime != null
                                      ? 'Start: \n${startTime!.format(context)}'
                                      : 'Set Start Time *',
                                ),
                                onTap: () => _pickStartTime(),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                leading: Icon(Icons.access_time, color: Colors.black),
                                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                title: Text(
                                  endTime != null
                                      ? 'End: \n${endTime!.format(context)}'
                                      : 'Set End Time *',
                                ),
                                onTap: () => _pickEndTime(),
                              ),
                            ),
                          ],
                        ),
                        if (timeError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                timeError!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Transform.translate(
                    offset: Offset(-90, 13),
                    child: Text(
                      ' Automatic alarm set',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: Offset(-0, 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (final preset in presetTimes.keys)
                            ElevatedButton(
                              onPressed: () => _applyPresetTime(preset),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey, width: 1),
                              ),
                              child: Text(preset),
                            ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Repeating Days',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            if (daysError != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(daysError!, style: TextStyle(color: Colors.red, fontSize: 12)), // Show error next to title
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: weekdays.map((day) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: FilterChip(
                                  label: Text(day),
                                  labelStyle: TextStyle(
                                    color: selectedDays[day] ?? false ? Colors.white : Colors.black, // Text color based on selection
                                  ),
                                  selected: selectedDays[day] ?? false,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedDays[day] = selected;
                                      if (selectedDays.values.any((s) => s)) { // Clear error if any day is selected
                                        daysError = null;
                                      }
                                    });
                                  },
                                  backgroundColor: Colors.grey[300], // Neutral background
                                  selectedColor: Colors.black, // Selected color
                                  checkmarkColor: Colors.white,
                                  side: BorderSide(
                                    color: daysError != null && !(selectedDays[day] ?? false) ? Colors.red : Colors.grey,
                                    width: 1
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20), // Added space before button

                  ElevatedButton(
                    onPressed: _validateAndSubmitDevice,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Square corners
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: Text(
                      isEditing ? 'Save Changes' : 'Add Device with Schedule', // Clarified button text
                      style: GoogleFonts.judson(
                        fontSize: 20, // Adjusted font size
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper for text fields (can be copied from AddDeviceScreen or defined here)
  Widget _buildRequiredTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, size: 30, color: Colors.black),
          labelText: label,
          labelStyle: GoogleFonts.jaldi(
            textStyle: TextStyle(fontSize: 20),
            color: Colors.grey[700], // Darker grey for label
          ),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Slightly rounded border
          errorText: errorText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          if (label == "KWH" && double.tryParse(value) == null) {
            return "Please enter a valid number for KWH";
          }
          return null;
        },
      ),
    );
  }

  // _addRoomDialog, _pickIcon, _applyPresetTime, _pickStartTime, _pickEndTime
  // can be copied from AddDeviceScreen or kept if they are identical.
  // For brevity, assuming they are similar and focusing on _validateAndSubmitDevice.

  void _addRoomDialog() {
    TextEditingController roomInput = TextEditingController();
    IconData newRoomIcon = Icons.home; // Default icon for new room

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFE9E7E6),
        title: Text('Add New Room', style: GoogleFonts.jaldi(fontWeight: FontWeight.bold, color: Colors.black)),
        content: StatefulBuilder( // Use StatefulBuilder to update icon selection within dialog
          builder: (BuildContext context, StateSetter setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: roomInput,
                    decoration: InputDecoration(
                      hintText: "Enter room name",
                      prefixIcon: Icon(newRoomIcon, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Select Icon:", style: GoogleFonts.jaldi(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  SizedBox(
                     height: 150, // Adjust height as needed
                     width: double.maxFinite,
                     child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: [
                        Icons.living, Icons.bed, Icons.kitchen, Icons.dining,
                        Icons.bathroom, Icons.meeting_room, Icons.workspace_premium, Icons.chair,
                        Icons.stairs, Icons.garage, Icons.yard, Icons.balcony,
                      ].map((icon) {
                        return IconButton(
                          icon: Icon(icon, color: newRoomIcon == icon ? Theme.of(context).primaryColor : Colors.black),
                          onPressed: () {
                            setDialogState(() { // Use setDialogState to update the icon in the dialog
                              newRoomIcon = icon;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            );
          }
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: GoogleFonts.jaldi(color: Colors.black54)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: Text('Add Room', style: GoogleFonts.jaldi(color: Colors.white)),
            onPressed: () {
              if (roomInput.text.isNotEmpty) {
                setState(() {
                  String newRoomName = roomInput.text;
                  if (!rooms.contains(newRoomName)) {
                    rooms.add(newRoomName);
                    roomIcons[newRoomName] = newRoomIcon; // Store selected icon
                  }
                  selectedRoom = newRoomName; // Select the newly added room
                  roomError = null;
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _pickIcon() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFE9E7E6),
      builder: (_) => Container( // Added container for padding
        padding: EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          children: <IconData>[ // Explicitly type the list
            Icons.lightbulb_outline, Icons.tv_outlined, Icons.power_outlined, Icons.kitchen_outlined,
            Icons.speaker_group_outlined, Icons.laptop_chromebook_outlined, Icons.ac_unit_outlined, Icons.microwave_outlined,
            Icons.router_outlined, Icons.videogame_asset_outlined, Icons.local_laundry_service_outlined, Icons.air_outlined, // Changed fan_outlined
          ].map<Widget>((IconData icon) { // Explicitly type icon in map
            return IconButton(
              icon: Icon(icon, color: Colors.black, size: 30),
              onPressed: () {
                setState(() {
                  selectedIcon = icon; // Now icon is IconData
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      )
    );
  }

  void _applyPresetTime(String preset) {
    if (presetTimes.containsKey(preset)) {
      setState(() {
        startTime = presetTimes[preset]!['start'];
        endTime = presetTimes[preset]!['end'];
        timeError = null;
      });
    }
  }

  void _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
        if (endTime != null && startTime!.hour > endTime!.hour || (startTime!.hour == endTime!.hour && startTime!.minute >= endTime!.minute)) {
            timeError = "Start time must be before end time";
        } else {
            timeError = null;
        }
      });
    }
  }

  void _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        endTime = picked;
         if (startTime != null && startTime!.hour > endTime!.hour || (startTime!.hour == endTime!.hour && startTime!.minute >= endTime!.minute)) {
            timeError = "End time must be after start time";
        } else {
            timeError = null;
        }
      });
    }
  }


  void _validateAndSubmitDevice() {
    bool isValid = true;
    setState(() { // Reset errors
      applianceNameError = null; kwhError = null; roomError = null;
      socketError = null; timeError = null; daysError = null;
    });

    if (applianceNameController.text.isEmpty) {
      applianceNameError = "Appliance name is required"; isValid = false;
    }
    if (kwhController.text.isEmpty) {
      kwhError = "KWH is required"; isValid = false;
    } else if (double.tryParse(kwhController.text) == null) {
      kwhError = "Invalid KWH value"; isValid = false;
    }
    if (selectedRoom == null) {
      roomError = "Room is required"; isValid = false;
    }
    if (deviceType == 'Socket' && socketController.text.isEmpty) {
      socketError = "Relay name is required for Socket type"; isValid = false;
    }
    if (startTime == null || endTime == null) {
      timeError = "Start and end times are required"; isValid = false;
    } else if (startTime!.hour > endTime!.hour || (startTime!.hour == endTime!.hour && startTime!.minute >= endTime!.minute)) {
        timeError = "End time must be after start time"; isValid = false;
    }
    if (!selectedDays.values.any((selected) => selected)) {
      daysError = "At least one day must be selected"; isValid = false;
    }

    setState(() {}); // Trigger UI update for error messages

    if (isValid) {
      _submitDeviceToFirestore();
    }
  }

  Future<void> _submitDeviceToFirestore() async {
    final Map<String, dynamic> firestoreData = {
      'applianceName': applianceNameController.text,
      'deviceType': deviceType,
      'kwh': double.tryParse(kwhController.text) ?? 0.0,
      'roomName': selectedRoom!,
      'icon': selectedIcon.codePoint,
      'startTime': startTime != null ? "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}" : null,
      'endTime': endTime != null ? "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}" : null,
      'days': selectedDays.entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
      // Preserve existing status and usage if editing, otherwise set defaults
      'applianceStatus': isEditing ? (_initialApplianceData?['applianceStatus'] ?? 'OFF') : 'OFF',
      'presentHourlyusage': isEditing ? (_initialApplianceData?['presentHourlyusage'] ?? 0.0) : 0.0,
    };

    if (deviceType == 'Socket') {
      firestoreData['relay'] = socketController.text;
    } else {
      firestoreData['relay'] = null; // Ensure relay is null for non-socket types
    }

    try {
      if (isEditing && editingApplianceId != null) {
        await _dbService.updateApplianceData(
          applianceId: editingApplianceId!,
          dataToUpdate: firestoreData,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Device schedule updated successfully!')));
      } else {
        // This is for adding a new device with its schedule
        await _dbService.addAppliance(applianceData: firestoreData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New device with schedule added!')));
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      print("Error submitting device to Firestore: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving device: ${e.toString()}'))
        );
      }
    }
  }
}

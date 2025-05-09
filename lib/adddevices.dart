import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
} 

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController applianceNameController = TextEditingController();
  final TextEditingController kwhController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController socketController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  String deviceType = 'Light';
  String? selectedRoom;
  List<String> rooms = ['Living Area', 'Kitchen Area','Bedroom','Dining Area'];
  Map<String, IconData> roomIcons = {
    'Living Area': Icons.living,
    'Kitchen Area': Icons.kitchen,
    'Bedroom': Icons.bed,
    'Dining Area': Icons.dining,
  };

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  
  // Preset time periods
  final Map<String, Map<String, TimeOfDay>> presetTimes = {
    'Morning': {
      'start': TimeOfDay(hour: 6, minute: 0),
      'end': TimeOfDay(hour: 12, minute: 0),
    },
    'Afternoon': {
      'start': TimeOfDay(hour: 12, minute: 0),
      'end': TimeOfDay(hour: 18, minute: 0),
    },
    'Evening': {
      'start': TimeOfDay(hour: 18, minute: 0),
      'end': TimeOfDay(hour: 23, minute: 0),
    },
  };
  
  // Repeating days
  final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  Map<String, bool> selectedDays = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };

  IconData selectedIcon = Icons.device_hub;

  // validation errors
  String? applianceNameError;
  String? kwhError;
  String? roomError;
  String? socketError;
  String? timeError;
  String? daysError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6), //frame
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
                    offset: Offset(-50, -30),
                    child: Text(
                      ' Add device',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.jaldi(
                        textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                        color: Colors.black,
                      ),
                    ),
                  ),
      
                  SizedBox(height: 5),
                  Transform.translate(  // icon profile
                    offset: Offset(0,-15),
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
                  
                  // Required text 
                  _buildRequiredTextField(
                    applianceNameController, 
                    "Appliance Name", 
                    Icons.device_hub,
                    errorText: applianceNameError
                  ),
                  _buildRequiredTextField(
                    kwhController, 
                    "KWPH", 
                    Icons.energy_savings_leaf, 
                    keyboardType: TextInputType.number,
                    errorText: kwhError
                  ),

                  SizedBox(height: 10),
                  
                  // Required room 
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
                  
                  // Device type dropdown 
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
                    items: ['Light', 'Socket'].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        deviceType = value!;
                        
                        if (deviceType == 'Light') {
                          socketError = null;
                        }
                      });
                    },
                  ),
                  
                  // Required socket input 
                  if (deviceType == 'Socket') ...[
                    SizedBox(height: 5),
                    _buildRequiredTextField(
                      socketController, 
                      "Socket", 
                      Icons.electrical_services, 
                      hint: "Enter socket name",
                      errorText: socketError
                    ),
                  ],

                  SizedBox(height: 10),
                  
                  // Required time
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
// title
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
                  
                  // automatic time buttons
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
                  
                  // Require repeating days 
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
                                    color: selectedDays[day] ?? false ? Colors.white : Colors.white,
                                  ),
                                  selected: selectedDays[day] ?? false,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedDays[day] = selected;
                                      
                                      if (selected) {
                                        daysError = null;
                                      }
                                    });
                                  },
                                  backgroundColor: Colors.black,
                                  side: BorderSide(
                                    color: daysError != null ? Colors.red : Colors.grey, 
                                    width: 1
                                  ),
                                  selectedColor: Theme.of(context).colorScheme.secondary,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Submit button
                  ElevatedButton(
                    onPressed: _validateAndSubmitDevice,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Colors.white, 
                      foregroundColor: Colors.black, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(color: Colors.black, width: 1), 
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.5), 
                    ),
                    child: Text(
                      'Add Device', 
                      style: GoogleFonts.judson(
                        fontSize: 24,
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

  // Required text field 
  Widget _buildRequiredTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {TextInputType keyboardType = TextInputType.text, 
    String? hint,
    String? errorText}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, size: 30, color: Colors.black), 
          labelText: '$label',  
          labelStyle: GoogleFonts.jaldi(
            textStyle: TextStyle(fontSize: 20),
            color: Colors.grey,
          ),
          hintText: hint,
          border: OutlineInputBorder(),
          errorText: errorText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }
 
  static IconData roomIconSelected = Icons.home;

  void _addRoomDialog() {    
    TextEditingController roomInput = TextEditingController();

    showDialog(    // room content
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFE9E7E6),
        titleTextStyle: GoogleFonts.jaldi(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        title: Text('Add Room'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: roomInput,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(fontSize: 17),
                      color: Colors.black, 
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Room name",
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        roomIconSelected,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Select Icon',
                    style: GoogleFonts.jaldi(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(  // icon picker
                    height: 200,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: [
                        Icons.living, Icons.bed, Icons.kitchen, Icons.dining,
                        Icons.bathroom, Icons.meeting_room, Icons.workspace_premium, Icons.chair,
                        Icons.stairs, Icons.garage, Icons.yard, Icons.balcony,
                      ].map((icon) {
                        return IconButton(
                          icon: Icon(
                            icon, 
                            color: roomIconSelected == icon ? Theme.of(context).colorScheme.secondary : Colors.black,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              roomIconSelected = icon;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
        
        actions: [
          TextButton(  // room add btn
            onPressed: () {
              if (roomInput.text.isNotEmpty) {
                setState(() {
                  rooms.add(roomInput.text);
                  selectedRoom = roomInput.text;
                  roomIcons[roomInput.text] = roomIconSelected;
                  
                  roomError = null;
                });
              }
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.jaldi(
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickIcon() { // icon picker
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFE9E7E6),
      builder: (_) => GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        children: [
          Icons.light, Icons.tv, Icons.power, Icons.kitchen,
          Icons.speaker, Icons.laptop, Icons.ac_unit, Icons.microwave,
        ].map((icon) {
          return IconButton(
            icon: Icon(icon, color: Colors.black),
            onPressed: () {
              setState(() {
                selectedIcon = icon;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
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
   
        if (endTime != null) {
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
       
        if (startTime != null) {
          timeError = null;
        }
      });
    }
  }
  
  void _validateAndSubmitDevice() {
    // Checking req field
    bool isValid = true;
    
    if (applianceNameController.text.isEmpty) {
      setState(() {
        applianceNameError = "Appliance name is required";
      });
      isValid = false;
    } else {
      setState(() {
        applianceNameError = null;
      });
    }
    
    if (kwhController.text.isEmpty) {
      setState(() {
        kwhError = "KWPH is required";
      });
      isValid = false;
    } else {
      setState(() {
        kwhError = null;
      });
    }
    
    if (selectedRoom == null) {
      setState(() {
        roomError = "Room is required";
      });
      isValid = false;
    } else {
      setState(() {
        roomError = null;
      });
    }
    
    if (deviceType == 'Socket' && socketController.text.isEmpty) {
      setState(() {
        socketError = "Socket name is required";
      });
      isValid = false;
    } else {
      setState(() {
        socketError = null;
      });
    }
    
    if (startTime == null || endTime == null) {
      setState(() {
        timeError = "Start and end times are required";
      });
      isValid = false;
    } else {
      setState(() {
        timeError = null;
      });
    }
    
    if (!selectedDays.values.any((selected) => selected)) {
      setState(() {
        daysError = "At least one day must be selected";
      });
      isValid = false;
    } else {
      setState(() {
        daysError = null;
      });
    }
    _submitDevice();
    Navigator.of(context).pop();
  }
  
  void _submitDevice() {
    // all data
    final Map<String, dynamic> deviceData = {
      "name": applianceNameController.text,
      "type": deviceType,
      "kwh": double.parse(kwhController.text),
      "room": selectedRoom,
      "icon": selectedIcon.codePoint,
      "startTime": "${startTime?.hour}:${startTime?.minute}",
      "endTime": "${endTime?.hour}:${endTime?.minute}",
      "days": selectedDays.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
    };
    
    if (deviceType == 'Socket') {
      deviceData["socket"] = socketController.text;
      // relay here
      print("Connecting to relay: ${socketController.text}");
    }
    print("Device added: $deviceData");
    
  }
}
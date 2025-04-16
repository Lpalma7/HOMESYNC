import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Device {
  final String id;
  final String name;
  final String type;
  final double kwh;
  final String room;
  final IconData icon;
  final String? appliance;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Map<String, bool> selectedDays;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.kwh,
    required this.room,
    required this.icon,
    this.appliance,
    this.startTime,
    this.endTime,
    required this.selectedDays,
  });

  Device copyWith({
    String? name,
    String? type,
    double? kwh,
    String? room,
    IconData? icon,
    String? appliance,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Map<String, bool>? selectedDays,
  }) {
    return Device(
      id: this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      kwh: kwh ?? this.kwh,
      room: room ?? this.room,
      icon: icon ?? this.icon,
      appliance: appliance ?? this.appliance,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      selectedDays: selectedDays ?? this.selectedDays,
    );
  }
}

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => ScheduleState();
}

class ScheduleState extends State<Schedule> {
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController kwhController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController applianceController = TextEditingController(); // Added appliance 

  String deviceType = 'Light';
  String? selectedRoom;
  List<String> rooms = ['Living Room', 'Kitchen','Bedroom','Dining Area'];
  Map<String, IconData> roomIcons = { // Added room icons 
    'Living Room': Icons.living,
    'Kitchen': Icons.kitchen,
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
  
  // Added device and editing state 
  final List<Device> devices = [];
  bool isEditing = false;
  String? editingDeviceId;

  @override
  Widget build(BuildContext context) {  /////whole frame design + back btn + add device label
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      appBar: null, 
      body: SafeArea(
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
              isEditing ? ' Edit device' : ' Edit Device',
              textAlign: TextAlign.center,
              style: GoogleFonts.jaldi(
                textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                color: Colors.black,
              ),
            ),
            ),
        /////////////////////////////////////////////////////////////////////////////////////////////      
              SizedBox(height: 5),
              Transform.translate( 
                offset: Offset(0,-15),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    
                    color: Colors.grey[400], // design for icon picker
                  ),
                  child: IconButton(
                    color: Colors.black,
                    iconSize: 60,
                    icon: Icon(selectedIcon),
                    onPressed: () => _pickIcon(),
                  ),
                ),
              ),
              ///////////////////////////////////////////////////
              _buildTextField(deviceNameController, "Device Name", Icons.device_hub),  // input of device and KWPH
              _buildTextField(kwhController, "KWPH", Icons.electrical_services, keyboardType: TextInputType.number),

              ////////////////////////////////////////////////////////
              SizedBox(height: 10),
              Row(                                       // Rooms dropdown function
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
                textStyle: TextStyle(fontSize: 20,),
                color: Colors.black,
                         ),
                        border: OutlineInputBorder(),
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
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add,size: 30, color: Colors.black),
                    onPressed: _addRoomDialog,
                  )
                ],
              ),
              //////////////////////////////////////////////////////////////////////////////////////
              
              SizedBox(height: 15),             // dropdown device type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                fillColor: Colors.white,
                
                  labelText: 'Device Type',
                  labelStyle: GoogleFonts.jaldi(
                textStyle: TextStyle(fontSize: 20,),
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
                items: ['Light', 'Plug'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    deviceType = value!;
                  });
                },
              ),
                                                                        // appliance input
              if (deviceType == 'Plug') ...[
                SizedBox(height: 20),
                _buildTextField(
                  applianceController, 
                  "Appliance", 
                  Icons.electrical_services, 
                  hint: "Enter appliance name"
                ),
              ],

              /////////////////////////////////////////////////////////////////////
             SizedBox(height: 10), // whole box
          Container(
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),

  child: Row(                               // start time
    children: [
      Expanded(
        child: ListTile(
          leading: Icon(Icons.access_time,color: Colors.black,),
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          title: Text(
            startTime != null
                ? 'Start: \n${startTime!.format(context)}'
                : 'Set Start Time',
          ),
          onTap: () => _pickStartTime(),
        ),
      ),


      Expanded(  // end time
        child: ListTile(
          leading: Icon(Icons.access_time,color: Colors.black,),
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          title: Text(
            endTime != null
                ? 'End: \n${endTime!.format(context)}'
                : 'Set End Time',
          ),
          onTap: () => _pickEndTime(),
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
                                                                                                                                            //         
              // automatic set (morning,afternoon,evening)
Transform.translate( 
              offset: Offset(-0, 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final preset in presetTimes.keys)
                      ElevatedButton(
                        onPressed: () => _applyPresetTime(preset),
                        child: Text(preset),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey, width: 1), 
                        ),
                      ),
                  ],
                ),
              ),
),
                                                                                                                                    //               
              // Repeating days section
              Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Repeating Days',
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
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
                  });
                },
                backgroundColor: Colors.black,
                side: BorderSide(color: Colors.grey, width: 1),
                selectedColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          }).toList(),
        ),
      ),
      SizedBox(height: 4),
      SizedBox(),
    ],
  ),
),
SizedBox(height: 10),    // add device btn
ElevatedButton(
  onPressed: _submitDevice,
  child: Text(
                isEditing ? 'Save Changes' : 'Save Device', 
                style: GoogleFonts.judson(
                  fontSize: 24,
                  color: Colors.black,
                ),
  ),
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
),
            ],
          ),
        ),
      ),
      ),
    );
  }

/////////////////////////////////////////////////////////////
  Widget _buildTextField(                              // design edit for device and kwph
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {TextInputType keyboardType = TextInputType.text, 
    String? hint}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5,top:10 ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
           filled: true,
                fillColor: Colors.white,
          prefixIcon: Icon(icon,size: 30, color: Colors.black), 
          labelText: label,
          labelStyle: GoogleFonts.jaldi(
                textStyle: TextStyle(fontSize: 20,),
                color: Colors.grey,
                         ),
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
//////////////////////////////////////////////////////////////////
 
  static IconData roomIconSelected = Icons.home; // add room container

 void _addRoomDialog() {    
  TextEditingController roomInput = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFE9E7E6),
      titleTextStyle: GoogleFonts.jaldi(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      title: Text('Add Room'), // add room and room name input
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: roomInput,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(fontSize: 17,),
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
                    
                    prefixIcon: Icon( // show icon picker for rooms
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
                SizedBox(height: 5), // icon picker
                Container(
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
      
      actions: [ // add room content
        TextButton(
          onPressed: () {
            if (roomInput.text.isNotEmpty) {
              setState(() {
                rooms.add(roomInput.text);
                selectedRoom = roomInput.text;
                roomIcons[roomInput.text] = roomIconSelected;
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
////////////////////////////////////////////////////////////////////////////////////////////////////////
  void _pickIcon() { // icon picker profile
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
            icon: Icon(icon, color: Colors.black,),
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

  ///////////////////////////////////////////////////////////////////////////////////////////
// time
  void _applyPresetTime(String preset) {
    if (presetTimes.containsKey(preset)) {
      setState(() {
        startTime = presetTimes[preset]!['start'];
        endTime = presetTimes[preset]!['end'];
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
      });
    }
  }
  
  // save btn
  void _submitDevice() {
    if (deviceNameController.text.isEmpty || kwhController.text.isEmpty || selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill the information'),
         backgroundColor: Colors.grey[900],
        duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final double kwh = double.tryParse(kwhController.text) ?? 0.0;
    
    if (isEditing && editingDeviceId != null) {
      final int deviceIndex = devices.indexWhere((d) => d.id == editingDeviceId);
      if (deviceIndex != -1) {
        devices[deviceIndex] = Device(
          id: editingDeviceId!,
          name: deviceNameController.text,
          type: deviceType,
          kwh: kwh,
          room: selectedRoom!,
          icon: selectedIcon,
          appliance: deviceType == 'Plug' ? applianceController.text : null,
          startTime: startTime,
          endTime: endTime,
          selectedDays: Map.from(selectedDays),
        );

      }
    } else { //new device
      
      final newDevice = Device(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: deviceNameController.text,
        type: deviceType,
        kwh: kwh,
        room: selectedRoom!,
        icon: selectedIcon,
        appliance: deviceType == 'Plug' ? applianceController.text : null,
        startTime: startTime,
        endTime: endTime,
        selectedDays: Map.from(selectedDays),
      );
      
      devices.add(newDevice);
    
    }
    
    print("Device ${isEditing ? 'updated' : 'added'}: ${deviceNameController.text}, Type: $deviceType");
    if (deviceType == 'Plug') {
      print("Appliance: ${applianceController.text}");
    }
    print("Time range: ${startTime?.format(context)} - ${endTime?.format(context)}");
    
    final selectedDaysList = selectedDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    print("Repeating days: $selectedDaysList");
    
    // Reset and edit
    _resetForm();
    setState(() {
      isEditing = false;
      editingDeviceId = null;
    });
    
  
    Navigator.of(context).pop(true); 
  }
  void _resetForm() {
    deviceNameController.clear();
    kwhController.clear();
    applianceController.clear();
    setState(() {
      deviceType = 'Light';
      selectedIcon = Icons.device_hub;
      startTime = null;
      endTime = null;
      for (final day in weekdays) {
        selectedDays[day] = false;
      }
    });
  }

  void _loadDeviceForEditing(Device device) {
    deviceNameController.text = device.name;
    kwhController.text = device.kwh.toString();
    if (device.appliance != null) {
      applianceController.text = device.appliance!;
    }
    
    setState(() {
      isEditing = true;
      editingDeviceId = device.id;
      deviceType = device.type;
      selectedRoom = device.room;
      selectedIcon = device.icon;
      startTime = device.startTime;
      endTime = device.endTime;
      selectedDays = Map.from(device.selectedDays);
    });
  }
}
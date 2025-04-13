import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
} 

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController kwhController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  String deviceType = 'Light';
  String? selectedRoom;
  List<String> rooms = ['Living Room', 'Kitchen','Bedroom','Dining Area'];

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

  String? selectedAppliance;
  List<String> appliances = ['Oven', 'Microwave', 'Fan'];

  IconData selectedIcon = Icons.device_hub;

////////////////////////////////////////////////////////////////////////////
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
              ' Add device',
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
              _buildTextField(deviceNameController, "Device Name", Icons.device_hub),  // the input of device and KWPH
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
                        prefixIcon: Icon(Icons.home,size: 30, color: Colors.black),
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
                                                                        // plug tapos you choose appliance
              if (deviceType == 'Plug') ...[
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                fillColor: Colors.white,
                    labelText: 'Appliance',
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
                  value: selectedAppliance,
                  items: appliances.map((app) {
                    return DropdownMenuItem(
                      value: app,
                      child: Text(app),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAppliance = value;
                    });
                  },
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
                          side: BorderSide(color: Colors.grey, width: 1), // Add border color here
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
                'Add Device', 
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
    elevation: 5, // Optional: adds shadow
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
 void _addRoomDialog() {    // add btn settings
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
      title: Text('Add Room'),
      content: TextField(
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
            fontSize: 15 ,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (roomInput.text.isNotEmpty) {
              setState(() {
                rooms.add(roomInput.text);
                selectedRoom = roomInput.text;
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
  void _pickIcon() {
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
  
  void _submitDevice() {
  
    print("Device added: ${deviceNameController.text}, Type: $deviceType");
    print("Time range: ${startTime?.format(context)} - ${endTime?.format(context)}");
    
    final selectedDaysList = selectedDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    print("Repeating days: $selectedDaysList");
  }
}
import 'package:flutter/material.dart';
import 'package:homesync/notification_screen.dart';
import 'package:weather/weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/welcome_screen.dart';
import 'package:homesync/room_data_manager.dart'; 

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => RoomsState();
}

class RoomsState extends State<Rooms> {
  Weather? currentWeather;
  int _selectedIndex = 2;
  final RoomDataManager _roomDataManager = RoomDataManager(); // Initial manager

  // given list
  List<RoomItem> rooms = [
    RoomItem(
      title: 'Bedroom',
      icon: Icons.bed,
    ),
    RoomItem(
      title: 'Kitchen Area',
      icon: Icons.kitchen,
    ),
    RoomItem(
      title: 'Living Area',
      icon: Icons.weekend,
    ),
    RoomItem(
      title: 'Dining Area',
      icon: Icons.dining,
    ),
  ];

  // list
  List<String> roomTypes = ['Living Area', 'Bedroom', 'Kitchen Area', 'Dining Area',];

  @override
  Widget build(BuildContext context) {  // whole frame and add btn navi and design
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFE9E7E6),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoomDialog(context);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              /// Profile + Home Text + Flyout
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

              /// Weather Info
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

              /// Navigation Tabs
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

              const SizedBox(height: 1), // search bar
              SizedBox(
                width: 355, 
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

              /// Room List
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: rooms.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  itemBuilder: (context, index) {
                    return RoomListTile(
                      room: rooms[index],
                      onDelete: () {
                        _deleteRoom(index);
                      },
                      onEdit: (newName) {
                        _editRoomName(index, newName);
                      },
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

  void _deleteRoom(int index) {
    final oldRoomName = rooms[index].title;
    
    setState(() {
      rooms.removeAt(index);
      
      
      _roomDataManager.roomDevices.remove(oldRoomName);
    });
  }
  
  // Updated to edit room name
  void _editRoomName(int index, String newName) {
    final oldRoomName = rooms[index].title;
    
   
    setState(() {
      rooms[index] = RoomItem(
        title: newName,
        icon: rooms[index].icon,
      );
    });
    
   
    _roomDataManager.updateRoomName(oldRoomName, newName);
  }

  void _showAddRoomDialog(BuildContext context) {    
    TextEditingController roomInput = TextEditingController();
    IconData roomIconSelected = Icons.home;

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
        
        actions: [
          TextButton(
            onPressed: () {
              if (roomInput.text.isNotEmpty) {
                setState(() {
                  final newRoomName = roomInput.text;
                  
                  if (!roomTypes.contains(newRoomName)) {
                    roomTypes.add(newRoomName);
                  }
                  
                  // Add room to list
                  rooms.add(RoomItem(
                    title: newRoomName,
                    icon: roomIconSelected,
                  ));
                  
                  if (!_roomDataManager.roomDevices.containsKey(newRoomName)) {
                    _roomDataManager.roomDevices[newRoomName] = [];
                  }
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

  /// Flyout Menu
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

  /// Navigation Button
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

class RoomItem {     // room setting and function
  final String title;
  final IconData icon;

  RoomItem({
    required this.title,
    required this.icon,
  });
}

class RoomListTile extends StatelessWidget {
  final RoomItem room;
  final VoidCallback onDelete;
  final Function(String) onEdit; 

  const RoomListTile({
    super.key,
    required this.room,
    required this.onDelete,
    required this.onEdit, 
  });

  @override
  Widget build(BuildContext context) {
    final String title = room.title;
   return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/roominfo', arguments: title);
    }, 
    onLongPress: () {
      _showEditDialog(context); //edit
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
        color: Colors.transparent, 
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                color: Colors.transparent,
              ),
              child: Icon(
                room.icon,
                color: Colors.black87,
                size: 40,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                room.title,
                style: GoogleFonts.judson(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
  
  // edit name content
  void _showEditDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: room.title);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE9E7E6),
          title: Text('Edit Room Name', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Room Name',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  onEdit(nameController.text);
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: Text('Save', style: GoogleFonts.inter(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
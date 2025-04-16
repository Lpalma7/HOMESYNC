import 'package:flutter/material.dart';
import 'package:homesync/notification_screen.dart';
import 'package:homesync/roomsinfo.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:homesync/roomsinfo.dart';
import 'package:homesync/homepage_screen.dart';
import 'package:homesync/devices_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesync/welcome_screen.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => RoomsState();
}

class RoomsState extends State<Rooms> {
  Weather? currentWeather;
  int _selectedIndex = 2;

  // given list
  List<RoomItem> rooms = [
    RoomItem(
      title: 'Bedroom',
      icon: Icons.bed,
    ),
    RoomItem(
      title: 'Kitchen',
      icon: Icons.kitchen,
    ),
    RoomItem(
      title: 'Living Room',
      icon: Icons.weekend,
    ),
    RoomItem(
      title: 'Dining Area',
      icon: Icons.dining,
    ),
  ];

  // dropdownlist
  List<String> roomTypes = ['Living Room', 'Bedroom', 'Kitchen', 'Dining Area',];

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

////////////////////////////////////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////////////////////////////////
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

        //////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////////////////////////////
              const SizedBox(height: 1), // search bar
              Container(
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

///////////////////////////////////////////////////////////////////////////////////
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
    setState(() {
      rooms.removeAt(index);
    });
  }

///////////////////////////////////////////////////////////////////////////
 // Add room settings and function
  void _showAddRoomDialog(BuildContext context) {
    final TextEditingController roomNameController = TextEditingController();
    IconData selectedIcon = Icons.home;
    String selectedRoomType = roomTypes.isNotEmpty ? roomTypes[0] : 'Living Room';
    
    showDialog(
      context: context, // whole  add container
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFD9D9D9),
              title: Text('Add New Room', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: roomNameController,
                      decoration: InputDecoration(
                        hintText: 'Room Name',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15), // room type and drop down design
                    Row(
                      children: [
                        Icon(Icons.home, color: Colors.black, size: 25),
                        SizedBox(width: 10),
                        Text('Room Type', style: GoogleFonts.inter(color: Colors.grey[700])),
                      ],
                    ),
                    SizedBox(height: 10), 
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedRoomType,
                            items: roomTypes
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRoomType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15), // room icon and select icon design
                    Row(
                      children: [
                        Icon(Icons.image, color: Colors.black, size: 25),
                        SizedBox(width: 10),
                        Text('Room Icon', style: GoogleFonts.inter(color: Colors.grey[700])),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: InkWell(
                          onTap: () {
                            _showIconPicker(context, (newIcon) {
                              setState(() {
                                selectedIcon = newIcon;
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(selectedIcon, color: Colors.black87, size: 25),
                              ),
                              SizedBox(width: 10),
                              Text('Select Icon', style: GoogleFonts.inter(color: Colors.grey[700])),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey[600])),
                ),
                TextButton(
                  onPressed: () {
                    // Add the new room to list
                    if (roomNameController.text.isNotEmpty) {
                      setState(() {
                       
                        if (!roomTypes.contains(roomNameController.text)) {
                          this.setState(() {
                            roomTypes.add(roomNameController.text);
                          });
                        }
                        
                        // Add room to the list
                        this.setState(() {
                          rooms.add(RoomItem(
                            title: roomNameController.text,
                            icon: selectedIcon,
                          ));
                        });
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text('Add Room', style: GoogleFonts.inter(color: Colors.grey[600])),
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  void _showIconPicker(BuildContext context, Function(IconData) onIconSelected) {
    final List<IconData> roomIcons = [ //icon picker rooms
      Icons.bed,
      Icons.kitchen,
      Icons.weekend,
      Icons.dining,
      Icons.garage_rounded,
      Icons.bathroom,
    ];
    
    showDialog(
      context: context, // icon container and function
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Icon', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: roomIcons.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    onIconSelected(roomIcons[index]);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        roomIcons[index],
                        size: 30,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey[600])),
            ),
          ],
        );
      },
    );
  }
/////////////////////////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////////////////////////////////////////
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

  const RoomListTile({
    Key? key,
    required this.room,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = room.title;
   return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/roominfo', arguments: title);
    }, 
    onLongPress: () {
      _showDeleteConfirmation(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
        color: Colors.transparent, // containers icons list
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
  
  // confirmation for deletion
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFD9D9D9),
          title: Text('Delete Room', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete "${room.title}"?', 
                        style: GoogleFonts.inter()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: Text('Delete', style: GoogleFonts.inter(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
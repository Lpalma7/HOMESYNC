import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.pushNamed(context, '/barchartwidget');
            },
          ),
        ],
      ),
      
    
      body: Stack(
        children: [
          Column(
            children: [
              DefaultTabController(
                length: 2,
                child: TabBar(
                  tabs: [
                    Tab(text: 'Favorites'),
                    Tab(text: 'All Devices'),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 100, color: Colors.grey),
                      Text(
                        'Make or the domain you care most\nabout as a device or create a new one',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
       
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Smart'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
              fixedColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

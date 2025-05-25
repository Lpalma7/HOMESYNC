import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceUsage extends StatefulWidget {
  const DeviceUsage({super.key});

  @override
  State<DeviceUsage> createState() => DeviceUsageState();
}

class DeviceUsageState extends State<DeviceUsage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); 
  }

  Widget usageTile(String leading, String title, String usage, String cost, {bool showCircle = true}) {
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
         BoxShadow( 
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 3),
        
         ),
        ],
      ),


      
      child: Row(
  children: [
    if (showCircle) 
      Container(
        width: 44, 
        height: 45, 
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[300],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        
        child: Center(
         child:  Transform.translate( 
                  offset: Offset(1, 2),
          child: Text(
            leading,
            style: GoogleFonts.jaldi(
              color: Colors.white,
              fontSize: 25,
              
            ),
          ),
        ),
      ),
      ),
                     
    if (showCircle) const SizedBox(width: 10), 
          
          Expanded(child: Text(title,  style: GoogleFonts.jaldi(fontSize: 20, fontWeight: FontWeight.w500))),


          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: 
            BorderRadius.circular(20), border:Border.all()),
            
           
            child: Text(usage,  style: GoogleFonts.jaldi (fontSize: 15)), 
          ),

          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8),border: Border.all()),
            child: Text(cost,  style: TextStyle(fontSize: 16)), 
          ),
        ],
      ),
    );
  }


  Widget buildYearlyUsage() {
    return ListView(
      
      children: [
        
        usageTile('', '2025', '15.84', '₱155.72', showCircle: false),
      ],
    );
  }

  Widget buildMonthlyUsage() {
    final months = [
      'December', 'November', 'October', 'September', 'August', 'July', 'June', 'May'
    ];

    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, index) {
        return usageTile((12 - index).toString(), months[index], '1.32', '₱12.98');
      },
    );
  }

  Widget buildWeeklyUsage() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "June",
            style: GoogleFonts.jaldi(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        
        usageTile('5', 'Week 5', '1.32', '₱12.98'),
        usageTile('4', 'Week 4', '1.32', '₱12.98'),
        usageTile('3', 'Week 3', '1.32', '₱12.98'),
        usageTile('2', 'Week 2', '1.32', '₱12.98'),
        usageTile('1', 'Week 1', '1.32', '₱12.98'),

        const SizedBox(height: 20),
        const Divider(thickness: 1.5),
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "May",
            style: GoogleFonts.jaldi(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        // May weeks 5 to 1
        usageTile('5', 'Week 5', '1.32', '₱12.98'),
        usageTile('4', 'Week 4', '1.32', '₱12.98'),
        usageTile('3', 'Week 3', '1.32', '₱12.98'),
        usageTile('2', 'Week 2', '1.32', '₱12.98'),
        usageTile('1', 'Week 1', '1.32', '₱12.98'),
      ],
    );
  }

  Widget buildDailyUsage() {
    final days = [
      'May 31, (Monday)', 'May 30, (Sunday)', 'May 29, (Saturday)', 'May 28, (Friday)',
      'May 27, (Thursday)', 'May 26, (Wednesday)', 'May 25, (Tuesday)', 'May 24, (Monday)', 
      'May 23, (Sunday)', 'May 22, (Saturday)', 'May 21, (Friday)', 'May 20, (Thursday)'
    ];
    
    return ListView(
      children: days.asMap().entries.map((entry) {
        int index = entry.key;
        String day = entry.value;
        return usageTile((31 - index).toString(), day, '1.32', '₱12.98');
      }).toList(),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFE9E7E6),
    body: SafeArea(
      child: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 50, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  _tabController.index == 0
                      ? 'Yearly Usage'
                      : _tabController.index == 1
                          ? 'Monthly Usage'
                          : _tabController.index == 2
                              ? 'Weekly Usage'
                              : 'Daily Usage',
                  style: GoogleFonts.jaldi(
                    textStyle: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.brown,
             labelStyle: GoogleFonts.jaldi(
    fontSize: 18,
    fontWeight: FontWeight.bold,
             ),
            onTap: (_) => setState(() {}),
            tabs: const [
              Tab(text: 'Yearly'),
              Tab(text: 'Monthly'),
              Tab(text: 'Weekly'),
              Tab(text: 'Daily'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildYearlyUsage(),
                buildMonthlyUsage(),
                buildWeeklyUsage(),
                buildDailyUsage(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
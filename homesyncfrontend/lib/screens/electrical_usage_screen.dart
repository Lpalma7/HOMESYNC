import 'package:flutter/material.dart';
import 'package:homesync/screens/bar_chart_widget.dart';


class ElectricalUsageScreen extends StatelessWidget {
  const ElectricalUsageScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electricity Usage Dashboard',
      theme: ThemeData(
        primaryColor: const Color(0xFFE9E7E6),
        scaffoldBackgroundColor: const Color(0xFFE9E7E6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE9E7E6),
          elevation: 0,
        ),
      ),
      home: const UsageDashboard(),
      debugShowCheckedModeBanner: true, // Removes debug banner
    );
  }
}

class UsageDashboard extends StatelessWidget {
  const UsageDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section

              
              Row(    //back btn icon 
                children: [
                  Transform.translate(
                offset: const Offset(-10, 20),
                 child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 50, color: Colors.black,),
                    onPressed: () {}, // Navigation back 
                  ),
                  ),


                  const Spacer(), // label eletricity usage
                  Transform.translate(
                  offset: const Offset(-40, 20),
                  child: const Text(
                    'Electricity Usage',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ),

                  const Spacer(), // calendar icon
                  Transform.translate(
                  offset: const Offset(-20, 15),
                  child: const Icon(Icons.calendar_month, size: 30, color: Colors.black),
                  ),
                ],
              ),
          
              const SizedBox(height: 10), // Weekly Label
              Transform.translate(
                  offset: const Offset(60, -10),
                child: Text(
                'Weekly',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ),


              const SizedBox(height: 20), //  Bar Chart
              Transform.translate(
                  offset: const Offset(-1, -10),
              child: Container(
                height: 300,
                width: 400,
                child: BarChartWidget(),
              ),
              ),


              SingleChildScrollView(
              scrollDirection: Axis.horizontal,// Total Usage Info
              child:Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[800],
                    ),
                    child: const Icon(Icons.bolt, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '250.1 kWh',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Total electricity usage',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              ),

              const SizedBox(height: 16),

              // Devices Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Devices',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // Device usage list
                    DeviceUsageItem(icon: Icons.power, name: 'Plugs', usage: 24.4, color: Colors.amber),
                    const Divider(height: 32, color: Colors.white),
                    DeviceUsageItem(icon: Icons.lightbulb_outline, name: 'Lights', usage: 14.9, color: Colors.lightBlue[200]!),
                    const Divider(height: 32, color: Colors.white),
                    DeviceUsageItem(icon: Icons.ac_unit, name: 'Aircon', usage: 210.8, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceUsageItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final double usage;
  final Color color;

  const DeviceUsageItem({super.key, required this.icon, required this.name, required this.usage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        const Spacer(),
        Text(
          '${usage.toStringAsFixed(1)} kWh',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}

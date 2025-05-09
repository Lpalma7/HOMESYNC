import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class deviceinfo extends StatefulWidget {
  final String deviceName;
  final String deviceUsage;

  const deviceinfo({
    super.key,
    required this.deviceName,
    required this.deviceUsage,
  });

  @override
  deviceinfoState createState() => deviceinfoState();
}

class deviceinfoState extends State<deviceinfo> {
  bool isDeviceOn = true;

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
              offset: Offset(65,-58), 
                child: Text(
                  widget.deviceName,
                  style: GoogleFonts.jaldi(
                    textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
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
                        Row(
                          children: [
                            Icon(
                              _getIconForDevice(widget.deviceName), // icon status design
                              size: 30,
                              color: isDeviceOn ? Colors.black : Colors.grey,
                            ),
                            SizedBox(width: 12),
                            Text(
                              widget.deviceName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: isDeviceOn,
                          onChanged: (value) { // toggle
                            setState(() {
                              isDeviceOn = value;
                            });
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
                      isDeviceOn ? "ON" : "OFF",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDeviceOn ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              ),
    
              // Energy Usage
              Transform.translate(
  offset: Offset(0, -30),
              child:Text(
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
                "Total Usage",
                widget.deviceUsage,
                "This Week",
                Icons.electric_bolt,
              ),
              ),
              
              Transform.translate(
              offset: Offset(0, -5),
              child: _buildEnergyStatCard(
                "Average Daily Usage",
                "${(double.parse(widget.deviceUsage.replaceAll(" kWh", "")) / 7).toStringAsFixed(1)} kWh",
                "Per Day",
                Icons.query_stats,
              ),
              ),
              
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      ),
    );
  }
  
  Widget _buildEnergyStatCard(String title, String value, String period, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),   //energy usage widget design
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
          Column(
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
        ],
      ),
    );
  }
  
  IconData _getIconForDevice(String deviceName) {
    if (deviceName.toLowerCase().contains("light")) {
      return Icons.light;
    } else if (deviceName.toLowerCase().contains("plug")) {
      return Icons.power;
    } else if (deviceName.toLowerCase().contains("ac") || 
              deviceName.toLowerCase().contains("air")) {
      return Icons.ac_unit;
    } else if (deviceName.toLowerCase().contains("tv")) {
      return Icons.tv;
    } else {
      return Icons.devices;
    }
  }
}
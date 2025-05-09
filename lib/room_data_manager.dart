import 'package:flutter/material.dart';

class RoomDataManager {
  static final RoomDataManager _instance = RoomDataManager._internal();
  
  factory RoomDataManager() {
    return _instance;
  }
  
  RoomDataManager._internal();
  
  // room data
  final Map<String, List<Map<String, dynamic>>> roomDevices = {
    
    'Bedroom': [
      {
        'applianceName': 'Air-con', 
        'roomName': 'Bedroom', 
        'deviceType': 'Socket 2',
        'relay': 'relay4', 
        'icon': Icons.power
      },
      {
        'applianceName': 'Light 3', 
        'roomName': 'Bedroom', 
        'deviceType': 'Light',
        'relay': 'relay6', 
        'icon': Icons.light
      },
    ],
    'Kitchen Area': [
      {
        'applianceName': 'Oven', 
        'roomName': 'Kitchen Area', 
        'deviceType': 'Socket 1',
        'relay': 'relay1', 
        'icon': Icons.power
      },
      {
        'applianceName': 'Light 1', 
        'roomName': 'Kitchen Area', 
        'deviceType': 'Light',
        'relay': 'relay2', 
        'icon': Icons.light
      },
      {
      'applianceName': 'Rice-cooker', 
      'roomName': ' Kitchen Area', 
      'deviceType': 'Socket 5',
      'relay': 'relay8', 
      'icon': Icons.power
    },
    ],
    'Living Area': [
      {
        'applianceName': 'Light 2', 
        'roomName': 'Living Area', 
        'deviceType': 'Light',
        'relay': 'relay3', 
        'icon': Icons.light
      },
      {
        'applianceName': 'Television', 
        'roomName': 'Living Area', 
        'deviceType': 'Socket 3',
        'relay': 'relay5', 
        'icon': Icons.power
      },
      {
      'applianceName': 'Fan', 
      'roomName': 'Living Area', 
      'deviceType': 'Socket 6',
      'relay': 'relay8', 
      'icon': Icons.power
    },
    ],
    'Dining Area': [
      {
        'applianceName': 'Refrigerator', 
        'roomName': 'Dining Area', 
        'deviceType': 'Socket 4',
        'relay': 'relay7', 
        'icon': Icons.power
      },
    ],
  };
  
  // update room name
  void updateRoomName(String oldName, String newName) {
    if (roomDevices.containsKey(oldName)) {
      // old room name and devices
      final devices = roomDevices[oldName]!;
      
      // Update roomName 
      for (var device in devices) {
        device['roomName'] = newName;
      }
      
      // Add devices in new name
      roomDevices[newName] = devices;
      
      // Remove old entry
      roomDevices.remove(oldName);
    }
  }
}
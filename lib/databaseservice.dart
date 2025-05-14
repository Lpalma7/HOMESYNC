import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For getting current user
import 'dart:async';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // --- Generic Firestore Operations ---

  // Set data for a document with a specific ID
  Future<void> setDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = false, // Set to true to merge data instead of overwriting
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).set(data, SetOptions(merge: merge));
    } catch (e) {
      print("Error setting document at $collectionPath/$docId: $e");
      rethrow;
    }
  }

  // Add a document to a collection (Firestore generates ID)
  Future<DocumentReference> addDocumentToCollection({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      print("Error adding document to $collectionPath: $e");
      rethrow;
    }
  }

  // Get a single document
  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).doc(docId).get();
      if (snapshot.exists) {
        return snapshot;
      }
      return null;
    } catch (e) {
      print("Error getting document $collectionPath/$docId: $e");
      rethrow;
    }
  }

  // Get all documents in a collection
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collectionPath,
  }) async {
    try {
      return await _firestore.collection(collectionPath).get();
    } catch (e) {
      print("Error getting collection $collectionPath: $e");
      rethrow;
    }
  }

  // Update a document
  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      print("Error updating document $collectionPath/$docId: $e");
      rethrow;
    }
  }

  // Delete a document
  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      print("Error deleting document $collectionPath/$docId: $e");
      rethrow;
    }
  }

  // Stream a single document
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collectionPath,
    required String docId,
  }) {
    return _firestore.collection(collectionPath).doc(docId).snapshots();
  }

  // Stream a collection
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
  }) {
    return _firestore.collection(collectionPath).snapshots();
  }

  // --- Appliance Specific Operations ---

  // Get a stream of appliances from the top-level collection
  Stream<QuerySnapshot<Map<String, dynamic>>> getAppliancesStream() {
    // Access the top-level 'appliances' collection directly
    return _firestore.collection('appliances').snapshots();
  }

  // Get a single appliance document for the current user by ID
  Future<Map<String, dynamic>?> getApplianceData(String applianceId) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      print("User not logged in. Cannot get appliance data.");
      return null;
    }
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('appliances')
          .doc(applianceId)
          .get();

      if (docSnapshot.exists) {
        // Include the document ID in the returned data
        return {...docSnapshot.data()!, 'id': docSnapshot.id};
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting appliance data for ID $applianceId: $e");
      rethrow;
    }
  }

  // Add a new appliance for the current user
  // This function handles uniqueness check and incremental ID generation.
  Future<void> addAppliance({
    required Map<String, dynamic> applianceData, // Contains 'applianceName', 'relay', 'deviceType', etc.
  }) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception("User not logged in. Cannot add appliance.");
    }

    final String deviceType = applianceData['deviceType'] as String; // e.g., "Light", "Socket"
    final String applianceName = applianceData['applianceName'] as String;
    final String relay = applianceData['relay'] as String;

    final appliancesCollectionRef = _firestore.collection('users').doc(userId).collection('appliances');

    // 1. Uniqueness Check:
    // Check if an appliance with the same name, relay, AND deviceType already exists for this user.
    final uniquenessQuery = await appliancesCollectionRef
        .where('applianceName', isEqualTo: applianceName)
        .where('relay', isEqualTo: relay)
        .where('deviceType', isEqualTo: deviceType)
        .limit(1)
        .get();

    if (uniquenessQuery.docs.isNotEmpty) {
      throw Exception("Appliance with the same name, relay, and type already exists.");
    }

    // 2. Incremental ID Generation:
    // Find existing appliances of the same deviceType to determine the next number.
    final typeQuery = await appliancesCollectionRef
        .where('deviceType', isEqualTo: deviceType)
        .get();

    int maxNumber = 0;
    for (var doc in typeQuery.docs) {
      // Document IDs are like "light1", "socket2", etc.
      final docId = doc.id;
      final typePrefix = deviceType.toLowerCase();
      if (docId.startsWith(typePrefix)) {
        try {
          final numberPart = docId.substring(typePrefix.length);
          final number = int.parse(numberPart);
          if (number > maxNumber) {
            maxNumber = number;
          }
        } catch (e) {
          // Ignore IDs that don't match the pattern (e.g., if manually added or different format)
          print("Could not parse number from appliance ID: $docId for type: $deviceType");
        }
      }
    }
    final newNumber = maxNumber + 1;
    final newApplianceId = '${deviceType.toLowerCase()}$newNumber'; // e.g., "light3", "socket1"

    // 3. Add the appliance
    // Ensure all required fields are present as per your rules/data model
    // Example: 'icon' is expected as int (codepoint), 'kwh' as double/num
    // 'days' as List<String>
    // 'applianceStatus' as String
    // 'presentHourlyusage' as String (or number, ensure consistency)

    // Validate or transform data if necessary before setting
    // For example, 'icon' might be coming as a string from a form
    if (applianceData['icon'] is String) {
        try {
            applianceData['icon'] = int.parse(applianceData['icon'] as String);
        } catch (e) {
            applianceData['icon'] = 0xe333; // Default icon if parsing fails
            print("Warning: Could not parse icon string, using default. Error: $e");
        }
    } else if (applianceData['icon'] == null) {
        applianceData['icon'] = 0xe333; // Default icon if null
    }


    if (applianceData['kwh'] is String) {
        try {
            applianceData['kwh'] = double.parse(applianceData['kwh'] as String);
        } catch (e) {
            applianceData['kwh'] = 0.0; // Default kwh if parsing fails
             print("Warning: Could not parse kwh string, using default. Error: $e");
        }
    } else if (applianceData['kwh'] == null) {
        applianceData['kwh'] = 0.0; // Default kwh if null
    }
    
    // Ensure 'days' is a List<String>
    if (applianceData['days'] is! List<String> && applianceData['days'] != null) {
        // Attempt to convert if it's List<dynamic> or handle error
        if (applianceData['days'] is List) {
            applianceData['days'] = List<String>.from(applianceData['days'] as List);
        } else {
            applianceData['days'] = <String>[]; // Default to empty list if not a list
        }
    } else if (applianceData['days'] == null) {
        applianceData['days'] = <String>[];
    }


    // Ensure 'presentHourlyusage' is a number (double)
    if (applianceData['presentHourlyusage'] is String) {
        try {
            applianceData['presentHourlyusage'] = double.parse(applianceData['presentHourlyusage'] as String);
        } catch (e) {
            applianceData['presentHourlyusage'] = 0.0; // Default if parsing fails
            print("Warning: Could not parse presentHourlyusage string, using default. Error: $e");
        }
    } else if (applianceData['presentHourlyusage'] == null) {
         applianceData['presentHourlyusage'] = 0.0;
    }


    // Add creation timestamp
    applianceData['createdAt'] = FieldValue.serverTimestamp();


    await appliancesCollectionRef.doc(newApplianceId).set(applianceData);
    print("Appliance added with ID: $newApplianceId");
  }

  // Update appliance status (or other fields)
  // Update appliance status (or other fields)
  Future<void> updateApplianceData({
    required String applianceId, // e.g., "light1"
    required Map<String, dynamic> dataToUpdate,
  }) async {
    if (dataToUpdate.isEmpty) {
        print("No data provided for update.");
        return;
    }

    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception("User not logged in. Cannot update appliance.");
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('appliances') // Target the user-specific subcollection
          .doc(applianceId)
          .update(dataToUpdate);

      print("Updated appliance $applianceId for user $userId with data: $dataToUpdate");
    } catch (e) {
      print("Error updating appliance $applianceId for user $userId: $e");
      rethrow; // Re-throw the error for the caller to handle
    }
  }

  // Delete an appliance
  Future<void> deleteAppliance({required String applianceId}) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception("User not logged in. Cannot delete appliance.");
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('appliances') // Target the user-specific subcollection
          .doc(applianceId)
          .delete();

      print("Deleted appliance $applianceId for user $userId");
    } catch (e) {
      print("Error deleting appliance $applianceId for user $userId: $e");
      rethrow; // Re-throw the error for the caller to handle
    }
  }

  // --- Methods for other collections (personal_information, usage) ---
  // You can add similar methods for 'personal_information' and 'usage' if needed.
  // For example:
  Future<void> setUserPersonalInformation({required Map<String, dynamic> data}) async {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception("User not logged in.");
    // Assuming a single document for personal info, e.g., 'details'
    await _firestore.collection('users').doc(userId).collection('personal_information').doc('details').set(data, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserPersonalInformation() {
    final userId = getCurrentUserId();
    if (userId == null) return Stream.error("User not logged in.");
    return _firestore.collection('users').doc(userId).collection('personal_information').doc('details').snapshots();
  }

  Future<void> addUserUsageRecord({required Map<String, dynamic> data}) async {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception("User not logged in.");
    // Firestore will generate an ID for each usage record
    await _firestore.collection('users').doc(userId).collection('usage').add(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserUsageRecords() {
    final userId = getCurrentUserId();
    if (userId == null) return Stream.error("User not logged in.");
    // Order by timestamp, for example
    return _firestore.collection('users').doc(userId).collection('usage').orderBy('timestamp', descending: true).snapshots();
  }

}

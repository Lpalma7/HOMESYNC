import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  
  void listen({
    required String path,
    required void Function(DatabaseEvent snapshot) onUpdate,
  }) {
    FirebaseDatabase.instance.ref(path).onValue.listen((event) {
      onUpdate(event);
    });
  }
  
  // Create or Update
  Future<void> create({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final ref = firebaseDatabase.ref().child(path);
    await ref.set(data);
  }

  // Read
  Future<Map<String, dynamic>?> read({
    required String path,
  }) async {
    final ref = firebaseDatabase.ref().child(path);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.value as Map<String, dynamic>;
    }
    return null;
  }

  // Update
  Future<void> update({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final ref = firebaseDatabase.ref().child(path);
    await ref.update(data);
  }

  // Delete
  Future<void> delete({
    required String path,
  }) async {
    final ref = firebaseDatabase.ref().child(path);
    await ref.remove();
  }

  Future<void> updateDeviceData(String relayPath, int state) async {
    final ref = firebaseDatabase.ref().child(relayPath);
    await ref.update({
      "state": state,
    });  
  }


}
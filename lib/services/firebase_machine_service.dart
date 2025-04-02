// lib/services/firebase_machine_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/machine.dart';
import '../models/machine_detail.dart';

class FirebaseMachineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  final CollectionReference _machinesCollection = 
      FirebaseFirestore.instance.collection('machines');
  final CollectionReference _machineDetailsCollection = 
      FirebaseFirestore.instance.collection('machine_details');
  
  // Get all machines from Firestore
  Future<List<Machine>> getAllMachines() async {
    try {
      final QuerySnapshot snapshot = await _machinesCollection.get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Machine(
          manufacturer: data['manufacturer'] ?? '',
          model: data['model'] ?? '',
          imagePath: data['imagePath'] ?? '',
          description: data['description'],
          documentPath: data['documentPath'],
          machineId: doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load machines: $e');
    }
  }
  
  // Get machine details by machineId
  Future<MachineDetail?> getMachineDetails(String machineId) async {
    try {
      final DocumentSnapshot snapshot = 
          await _machineDetailsCollection.doc(machineId).get();
      
      if (!snapshot.exists) {
        return null;
      }
      
      final data = snapshot.data() as Map<String, dynamic>;
      return MachineDetail.fromJson({
        'machineId': machineId,
        ...data,
      });
    } catch (e) {
      throw Exception('Failed to load machine details: $e');
    }
  }
}
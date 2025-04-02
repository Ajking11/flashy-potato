// lib/models/machine.dart
import '../services/firebase_machine_service.dart';

class Machine {
  final String manufacturer;
  final String model;
  final String imagePath;
  final String? description;
  final String? documentPath;
  final String machineId;

  Machine({
    required this.manufacturer,
    required this.model,
    required this.imagePath,
    this.description,
    this.documentPath,
    String? machineId,
  }) : machineId = machineId ?? '${manufacturer.toLowerCase()}_${model.toLowerCase().replaceAll(' ', '')}';

  // Getter to provide a combined name for display purposes
  String get name => '$manufacturer\n$model';
  
  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'imagePath': imagePath,
      'description': description,
      'documentPath': documentPath,
    };
  }
  
  // Create from Firestore document
  factory Machine.fromFirestore(Map<String, dynamic> data, String docId) {
    return Machine(
      manufacturer: data['manufacturer'] ?? '',
      model: data['model'] ?? '',
      imagePath: data['imagePath'] ?? '',
      description: data['description'],
      documentPath: data['documentPath'],
      machineId: docId,
    );
  }
}

// Static FirebaseMachineService instance
final FirebaseMachineService _machineService = FirebaseMachineService();

// Get the list of machines from Firestore
Future<List<Machine>> getMachinesFromFirestore() async {
  try {
    return await _machineService.getAllMachines();
  } catch (e) {
    // Fallback to original data if Firestore fails
    return getLocalMachines();
  }
}

// Legacy method - get machines from local data
List<Machine> getLocalMachines() {
  return [
    Machine(manufacturer: 'Schaerer', model: 'SCA', imagePath: 'assets/images/MK2.png'),
    Machine(manufacturer: 'Schaerer', model: 'SCB', imagePath: 'assets/images/MK3.png'),
    Machine(manufacturer: 'Schaerer', model: 'SCBBF', imagePath: 'assets/images/MK4.png'),
    Machine(manufacturer: 'Schaerer', model: 'SOUL S10', imagePath: 'assets/images/SOULS10.png'),
    Machine(manufacturer: 'Thermoplan', model: 'MARLOW', imagePath: 'assets/images/MARLOW.png'),
    Machine(manufacturer: 'Thermoplan', model: 'MARLOW 1.2', imagePath: 'assets/images/MARLOW12.png'),
  ];
}

// For backward compatibility
List<Machine> getMachines() {
  // Return local data synchronously for backward compatibility
  return getLocalMachines();
}
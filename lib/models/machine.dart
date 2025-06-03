// lib/models/machine.dart
import '../services/firebase_machine_service.dart';

class Machine {
  final String manufacturer;
  final String model;
  final String? imagePath; // Make imagePath nullable to handle missing images
  final String? description;
  final String? documentPath;
  final String machineId;
  final bool displayInApp;

  Machine({
    required this.manufacturer,
    required this.model,
    this.imagePath,
    this.description,
    this.documentPath,
    String? machineId,
    this.displayInApp = true, // Default to true for backward compatibility
  }) : machineId = machineId ?? '${manufacturer.toLowerCase()}_${model.toLowerCase().replaceAll(' ', '')}';

  // Getter to provide a combined name for display purposes
  String get name => '$manufacturer\n$model';
  
  // Getter to check if machine has an image
  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;
  
  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'imagePath': imagePath,
      'description': description,
      'documentPath': documentPath,
      'displayInApp': displayInApp,
    };
  }
  
  // Create from Firestore document
  factory Machine.fromFirestore(Map<String, dynamic> data, String docId) {
    // Process the document data in release mode - no debug messages
    // Check different possible image field names
    String? imageUrl;
    
    // Try different possible field names for the image
    final possibleImageFields = ['imageUrl', 'image', 'imagePath', 'imageURL', 'img', 'url'];
    
    for (var field in possibleImageFields) {
      if (data.containsKey(field) && data[field] != null) {
        final value = data[field].toString();
        
        if (value.isNotEmpty) {
          // Check if this is a Firebase Storage URL (gs://) which isn't directly usable
          if (value.startsWith('gs://')) {
            // Skip Firebase Storage URLs as they need conversion
            continue;
          } else {
            imageUrl = value;
            break;
          }
        }
      }
    }
    
    // Create and return the machine object with parsed data
    return Machine(
      manufacturer: data['manufacturer'] ?? '',
      model: data['model'] ?? '',
      imagePath: imageUrl, // Can be null if no image is assigned
      description: data['description'],
      documentPath: data['documentPath'],
      displayInApp: data['displayInApp'] ?? true, // Default to true if not specified
      machineId: docId,
    );
  }
}

// Static FirebaseMachineService instance
final FirebaseMachineService _machineService = FirebaseMachineService();

// Get the list of machines from Firestore
Future<List<Machine>> getMachinesFromFirestore() async {
  try {
    // Get machines that are marked to display in app
    return await _machineService.getAllMachines();
  } catch (e) {
    // Fallback to original data if Firestore fails
    return getLocalMachines();
  }
}

// Legacy method - get machines from local data
List<Machine> getLocalMachines() {
  return [
    Machine(manufacturer: 'Schaerer', model: 'SCA', imagePath: 'assets/images/MK2.png', displayInApp: true),
    Machine(manufacturer: 'Schaerer', model: 'SCB', imagePath: 'assets/images/MK3.png', displayInApp: true),
    Machine(manufacturer: 'Schaerer', model: 'SCBBF', imagePath: 'assets/images/MK4.png', displayInApp: true),
    Machine(manufacturer: 'Schaerer', model: 'SOUL S10', imagePath: 'assets/images/SOULS10.png', displayInApp: true),
    Machine(manufacturer: 'Thermoplan', model: 'MARLOW', imagePath: 'assets/images/MARLOW.png', displayInApp: true),
    Machine(manufacturer: 'Thermoplan', model: 'MARLOW 1.2', imagePath: 'assets/images/MARLOW12.png', displayInApp: true),
  ];
}

// For backward compatibility - this will be replaced by provider-based access
List<Machine> getMachines() {
  // Return local data synchronously for backward compatibility
  // Note: This should be replaced with provider-based access for Firebase data
  return getLocalMachines();
}
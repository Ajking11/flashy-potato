// lib/services/firebase_machine_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/machine.dart';
import '../models/machine_detail.dart';

class FirebaseMachineService {
  // This will be used in future implementations for transactions and batched operations
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  final CollectionReference _machinesCollection = 
      FirebaseFirestore.instance.collection('machines');
  final CollectionReference _machineDetailsCollection = 
      FirebaseFirestore.instance.collection('machine_details');
  
  // Debug method to examine document fields in detail
  void debugPrintDocument(DocumentSnapshot doc) {
    // Use a conditional compilation flag for debug logging
    assert(() {
      debugPrint('--------- Document Debug Info ---------');
      debugPrint('Document ID: ${doc.id}');
      debugPrint('Document exists: ${doc.exists}');
      
      final data = doc.data();
      debugPrint('Document data: $data');
      
      if (data != null && data is Map<String, dynamic>) {
        debugPrint('Document fields:');
        data.forEach((key, value) {
          debugPrint('  $key: $value (${value.runtimeType})');
        });
      }
      debugPrint('--------------------------------------');
      return true;
    }());
  }
  
  // Get all machines from Firestore that are marked to display in app
  Future<List<Machine>> getAllMachines() async {
    try {
      // First, try to get a single document to inspect its structure
      assert(() {
        debugPrint("===== Inspecting a specific document =====");
        return true;
      }());
      try {
        // Choose a known document ID to inspect - replace with an actual ID if needed
        const knownDocId = 'schaerer_sca'; // Dummy ID - replace with a real one if known
        final docSnapshot = await _machinesCollection.doc(knownDocId).get();
        
        if (docSnapshot.exists) {
          assert(() {
            debugPrint("Found document with ID: $knownDocId");
            return true;
          }());
          final data = docSnapshot.data() as Map<String, dynamic>;
          
          // Print all fields and their types
          assert(() {
            debugPrint("Document fields:");
            return true;
          }());
          data.forEach((key, value) {
            assert(() {
              debugPrint("  $key: $value (${value.runtimeType})");
              return true;
            }());
          });
          
          if (data.containsKey('imageUrl')) {
            assert(() {
              debugPrint("Image URL field exists: ${data['imageUrl']} (${data['imageUrl'].runtimeType})");
              return true;
            }());
          } else {
            assert(() {
              debugPrint("No 'imageUrl' field in this document.");
              return true;
            }());
            // Look for other possible image fields
            final possibleImageFields = ['image', 'imagePath', 'imageURL', 'img', 'url'];
            for (final field in possibleImageFields) {
              if (data.containsKey(field)) {
                assert(() {
                  debugPrint("Found alternative image field '$field': ${data[field]} (${data[field].runtimeType})");
                  return true;
                }());
              }
            }
          }
        } else {
          assert(() {
            debugPrint("Document with ID $knownDocId does not exist.");
            return true;
          }());
        }
      } catch (e) {
        assert(() {
          debugPrint("Error inspecting specific document: $e");
          return true;
        }());
      }
      
      // Now fetch all machines
      assert(() {
        debugPrint("===== Fetching ALL machines from Firestore =====");
        return true;
      }());
      final allMachines = await _machinesCollection.get();
      assert(() {
        debugPrint("Total machines found: ${allMachines.docs.length}");
        return true;
      }());
      
      // Print summary of each machine document
      for (var i = 0; i < allMachines.docs.length; i++) {
        final doc = allMachines.docs[i];
        final data = doc.data() as Map<String, dynamic>;
        assert(() {
          debugPrint("Machine $i - ID: ${doc.id}");
          debugPrint("  Manufacturer: ${data['manufacturer']}");
          debugPrint("  Model: ${data['model']}");
          debugPrint("  DisplayInApp: ${data['displayInApp']}");
          debugPrint("  Fields: ${data.keys.toList()}");
          return true;
        }());
      }
      
      // Now filter for only displayInApp = true
      assert(() {
        debugPrint("===== Filtering for displayInApp = true =====");
        return true;
      }());
      final QuerySnapshot snapshot = await _machinesCollection
          .where('displayInApp', isEqualTo: true)
          .get();
      
      assert(() {
        debugPrint("Machines with displayInApp=true found: ${snapshot.docs.length}");
        return true;
      }());
      
      // Create Machine objects from the filtered documents
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Machine.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      assert(() {
        debugPrint('Error in getAllMachines: $e');
        debugPrint('StackTrace: ${StackTrace.current}');
        return true;
      }());
      
      // Try to fetch just one machine to see if that works
      try {
        assert(() {
          debugPrint("===== Attempting to fetch a single machine =====");
          return true;
        }());
        final singleMachine = await _machinesCollection.limit(1).get();
        if (singleMachine.docs.isNotEmpty) {
          final doc = singleMachine.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          assert(() {
            debugPrint("Successfully fetched one machine: ${doc.id}");
            debugPrint("Data: $data");
            return true;
          }());
        } else {
          assert(() {
            debugPrint("No machines found in collection");
            return true;
          }());
        }
      } catch (innerError) {
        assert(() {
          debugPrint("Error fetching single machine: $innerError");
          return true;
        }());
      }
      
      // Re-throw the original error
      throw Exception('Failed to load machines: $e');
    }
  }
  
  // Get machine details by machineId
  Future<MachineDetail?> getMachineDetails(String machineId) async {
    try {
      assert(() {
        debugPrint("===== Fetching machine details for machineId: $machineId =====");
        return true;
      }());
      
      // First try to get details using the direct machineId
      DocumentSnapshot snapshot = 
          await _machineDetailsCollection.doc(machineId).get();
      
      if (snapshot.exists) {
        assert(() {
          debugPrint("Found machine details document with ID: $machineId");
          return true;
        }());
        final data = snapshot.data() as Map<String, dynamic>;
        debugPrintDocument(snapshot);
        
        return MachineDetail.fromJson({
          'machineId': machineId,
          ...data,
        });
      }
      
      // If not found, try alternate approaches
      assert(() {
        debugPrint("No machine details found with direct ID match. Trying alternate approaches...");
        return true;
      }());
      
      // Try a query to find by machineId field
      final QuerySnapshot queryResult = await _machineDetailsCollection
          .where('machineId', isEqualTo: machineId)
          .limit(1)
          .get();
      
      if (queryResult.docs.isNotEmpty) {
        final doc = queryResult.docs.first;
        assert(() {
          debugPrint("Found machine details through query with document ID: ${doc.id}");
          return true;
        }());
        final data = doc.data() as Map<String, dynamic>;
        debugPrintDocument(doc);
        
        return MachineDetail.fromJson({
          'machineId': machineId,
          ...data,
        });
      }
      
      // Get a list of all machine details to debug
      assert(() {
        debugPrint("===== Listing all machine_details documents =====");
        return true;
      }());
      final allDetailsSnapshot = await _machineDetailsCollection.limit(10).get();
      assert(() {
        debugPrint("Found ${allDetailsSnapshot.docs.length} machine detail documents");
        return true;
      }());
      
      if (allDetailsSnapshot.docs.isEmpty) {
        assert(() {
          debugPrint("WARNING: The machine_details collection appears to be empty!");
          debugPrint("Please make sure the collection exists and contains documents");
          
          // Just log that we can't check collections
          debugPrint("Note: Unable to list all collections in Firestore - method not available in this Flutter version");
          // Show the collection we're trying to access
          debugPrint("Trying to access collection: 'machine_details'");
          return true;
        }());
      }
      
      for (var doc in allDetailsSnapshot.docs) {
        assert(() {
          debugPrint("Detail document ID: ${doc.id}");
          return true;
        }());
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('machineId')) {
          assert(() {
            debugPrint("  machineId field: ${data['machineId']}");
            return true;
          }());
        } else {
          assert(() {
            debugPrint("  No machineId field found in this document");
            return true;
          }());
        }
      }
      
      // If we get here, no matching details were found
      assert(() {
        debugPrint("No machine details found for machineId: $machineId");
        return true;
      }());
      return null;
    } catch (e) {
      assert(() {
        debugPrint("Error in getMachineDetails: $e");
        debugPrint("StackTrace: ${StackTrace.current}");
        return true;
      }());
      throw Exception('Failed to load machine details: $e');
    }
  }
}
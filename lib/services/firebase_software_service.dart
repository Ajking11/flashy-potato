// lib/services/firebase_software_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/software.dart';

class FirebaseSoftwareService {
  // This will be used in future implementations for transactions and batched operations
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection reference for software packages
  final CollectionReference _softwareCollection = 
      FirebaseFirestore.instance.collection('software');
  
  // Get all software packages from Firestore
  Future<List<Software>> getAllSoftware() async {
    try {
      final QuerySnapshot snapshot = await _softwareCollection.get();
      
      return snapshot.docs.map((doc) {
        return Software.fromFirestore(
          doc.data() as Map<String, dynamic>, 
          doc.id,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting software packages: $e');
      return [];
    }
  }
  
  // Get a specific software package by ID
  Future<Software?> getSoftwareById(String id) async {
    try {
      final DocumentSnapshot doc = await _softwareCollection.doc(id).get();
      
      if (doc.exists) {
        return Software.fromFirestore(
          doc.data() as Map<String, dynamic>, 
          doc.id,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error getting software by ID: $e');
      return null;
    }
  }
  
  // Search software by query
  Future<List<Software>> searchSoftware(String query) async {
    try {
      // Search by name, description, or tags
      final QuerySnapshot nameSnapshot = await _softwareCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
          
      final QuerySnapshot descSnapshot = await _softwareCollection
          .where('description', isGreaterThanOrEqualTo: query)
          .where('description', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
          
      final QuerySnapshot tagSnapshot = await _softwareCollection
          .where('tags', arrayContains: query)
          .get();
      
      // Combine results and remove duplicates
      Set<String> processedIds = {};
      List<Software> results = [];
      
      // Process each snapshot and add unique results
      for (final snapshot in [nameSnapshot, descSnapshot, tagSnapshot]) {
        for (final doc in snapshot.docs) {
          if (!processedIds.contains(doc.id)) {
            processedIds.add(doc.id);
            results.add(Software.fromFirestore(
              doc.data() as Map<String, dynamic>, 
              doc.id,
            ));
          }
        }
      }
      
      return results;
    } catch (e) {
      debugPrint('Error searching software: $e');
      return [];
    }
  }
  
  // Download software package
  Future<String> downloadSoftware(
    Software software, 
    {Function(double)? onProgress}
  ) async {
    try {
      // Get application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDocDir.path}/${software.id}${_getFileExtension(software.filePath)}';
      final File file = File(filePath);
      
      // If file already exists, return its path
      if (await file.exists()) {
        return filePath;
      }
      
      // Create a reference to the file in Firebase Storage
      final Reference ref = _storage.ref(software.filePath);
      
      // Track download progress
      final DownloadTask downloadTask = ref.writeToFile(file);
      
      // Report progress if callback is provided
      if (onProgress != null) {
        downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }
      
      // Wait for download to complete
      await downloadTask;
      
      return filePath;
    } catch (e) {
      debugPrint('Error downloading software: $e');
      throw Exception('Failed to download software: $e');
    }
  }
  
  // Check which software packages are downloaded
  Future<Map<String, bool>> checkDownloadedSoftware(List<String> softwareIds) async {
    Map<String, bool> results = {};
    
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      
      for (final id in softwareIds) {
        // Check for all potential file extensions
        bool found = false;
        for (final ext in ['.zip', '.exe', '.pkg', '.msi', '.bin', '.img', '.dmg']) {
          final File file = File('${appDocDir.path}/$id$ext');
          if (await file.exists()) {
            results[id] = true;
            found = true;
            break;
          }
        }
        
        // If no file with extension was found, check for a file without extension
        if (!found) {
          final File file = File('${appDocDir.path}/$id');
          results[id] = await file.exists();
        }
      }
    } catch (e) {
      debugPrint('Error checking downloaded software: $e');
    }
    
    return results;
  }
  
  // Remove a downloaded software package
  Future<void> removeDownloadedSoftware(String softwareId) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      
      // Check for file with various extensions
      bool found = false;
      for (final ext in ['.zip', '.exe', '.pkg', '.msi', '.bin', '.img', '.dmg']) {
        final File file = File('${appDocDir.path}/$softwareId$ext');
        if (await file.exists()) {
          await file.delete();
          found = true;
          break;
        }
      }
      
      // If no file with extension was found, try without extension
      if (!found) {
        final File file = File('${appDocDir.path}/$softwareId');
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error removing downloaded software: $e');
      throw Exception('Failed to remove downloaded software: $e');
    }
  }
  
  // Helper method to extract file extension from a path
  String _getFileExtension(String path) {
    final Uri uri = Uri.parse(path);
    final String fileName = uri.pathSegments.last;
    final int dotIndex = fileName.lastIndexOf('.');
    
    if (dotIndex != -1 && dotIndex < fileName.length - 1) {
      return fileName.substring(dotIndex);
    }
    
    return ''; // No extension found
  }
}
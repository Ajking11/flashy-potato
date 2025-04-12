// lib/services/firebase_document_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class FirebaseDocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get the documents collection
  CollectionReference get _documentsCollection {
    // Try both collection paths to ensure we find documents
    // Based on your sample data, it seems documents are in the root collection
    return _firestore.collection('documents');
  }
  
  // Get all documents from Firestore
  Future<List<TechnicalDocument>> getAllDocuments() async {
    try {
      debugPrint('Fetching documents from Firestore collection: ${_documentsCollection.path}');
      
      // Get all documents from collection
      final QuerySnapshot snapshot = await _documentsCollection.get();
      
      debugPrint('Found ${snapshot.docs.length} documents in Firestore');
      
      // If no documents found, try a different collection path
      if (snapshot.docs.isEmpty) {
        // Try the default collection as well
        final alternateCollection = _firestore.collection('documents');
        debugPrint('Trying alternate collection: ${alternateCollection.path}');
        final alternateSnapshot = await alternateCollection.get();
        debugPrint('Found ${alternateSnapshot.docs.length} documents in alternate collection');
        
        return alternateSnapshot.docs.map((doc) {
          final docData = doc.data();
          return TechnicalDocument.fromFirestore(docData, doc.id);
        }).toList();
      }
      
      return snapshot.docs.map((doc) {
        final docData = doc.data() as Map<String, dynamic>;
        return TechnicalDocument.fromFirestore(docData, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error loading documents from Firestore: $e');
      debugPrint('Error details: ${e.toString()}');
      throw Exception('Failed to load documents: $e');
    }
  }
  
  // Download a document from Firebase Storage to local device
  Future<String> downloadDocument(
    TechnicalDocument document, {
    Function(double progress)? onProgress,
  }) async {
    try {
      // Get the local app directory
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${document.id}.pdf';
      final file = File(filePath);
      
      // Use the direct download URL if available
      if (document.downloadURL != null && document.downloadURL!.isNotEmpty) {
        // Download file from the direct URL
        final response = await downloadFileFromUrl(
          document.downloadURL!, 
          filePath,
          onProgress: onProgress,
        );
        if (!response) {
          throw Exception('Failed to download document from URL');
        }
      } else {
        // Fall back to using Firebase Storage reference
        final storageRef = _storage.ref().child(document.filePath);
        
        // If progress tracking is requested
        if (onProgress != null) {
          // Get metadata to determine file size
          final metadata = await storageRef.getMetadata();
          final totalBytes = metadata.size ?? 0;
          
          if (totalBytes > 0) {
            // Set up a download task with progress tracking
            final downloadTask = storageRef.writeToFile(file);
            
            // Monitor the task's progress
            downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
              final progress = snapshot.bytesTransferred / totalBytes;
              onProgress(progress);
            });
            
            // Wait for the download to complete
            await downloadTask;
          } else {
            // If size is unknown, just download with a simple progress simulation
            onProgress(0.1); // Start
            await storageRef.writeToFile(file);
            onProgress(1.0); // Complete
          }
        } else {
          // Simple download without progress tracking
          await storageRef.writeToFile(file);
        }
      }
      
      return filePath;
    } catch (e) {
      debugPrint('Error downloading document: $e');
      throw Exception('Failed to download document: $e');
    }
  }
  
  // Helper method to download a file from a URL
  Future<bool> downloadFileFromUrl(
    String url, 
    String destinationPath, {
    Function(double progress)? onProgress,
  }) async {
    try {
      // Get the file reference from Firebase Storage using the URL
      final ref = FirebaseStorage.instance.refFromURL(url);
      
      if (onProgress != null) {
        // Get file size for progress tracking
        final metadata = await ref.getMetadata();
        final totalBytes = metadata.size ?? 0;
        
        if (totalBytes > 0) {
          // Download with progress tracking
          final file = File(destinationPath);
          final downloadTask = ref.writeToFile(file);
          
          // Monitor progress
          downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            final progress = snapshot.bytesTransferred / totalBytes;
            onProgress(progress);
          });
          
          // Wait for download to complete
          await downloadTask;
        } else {
          // Simple simulated progress if size unknown
          onProgress(0.1);
          final file = File(destinationPath);
          await ref.writeToFile(file);
          onProgress(1.0);
        }
      } else {
        // Simple download without progress tracking
        final file = File(destinationPath);
        await ref.writeToFile(file);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error downloading from URL: $e');
      return false;
    }
  }
  
  // Remove a downloaded document
  Future<void> removeDownloadedDocument(String documentId) async {
    try {
      // Get the local app directory
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$documentId.pdf';
      final file = File(filePath);
      
      // Delete the file if it exists
      if (await file.exists()) {
        await file.delete();
      }
      
      // We don't update Firestore as isDownloaded is now a client-side property
    } catch (e) {
      debugPrint('Error removing downloaded document: $e');
      throw Exception('Failed to remove document: $e');
    }
  }
  
  // Check which documents are downloaded locally
  Future<Map<String, bool>> checkDownloadedDocuments(List<String> documentIds) async {
    final Map<String, bool> downloadStatus = {};
    final dir = await getApplicationDocumentsDirectory();
    
    for (final id in documentIds) {
      final filePath = '${dir.path}/$id.pdf';
      final file = File(filePath);
      downloadStatus[id] = await file.exists();
    }
    
    return downloadStatus;
  }
  
  // Get a specific document by ID
  Future<TechnicalDocument?> getDocumentById(String documentId) async {
    try {
      final docSnapshot = await _documentsCollection.doc(documentId).get();
      
      if (!docSnapshot.exists) {
        return null;
      }
      
      final docData = docSnapshot.data() as Map<String, dynamic>;
      return TechnicalDocument.fromFirestore(docData, documentId);
    } catch (e) {
      debugPrint('Error getting document by ID: $e');
      return null;
    }
  }
  
  // Search documents by query
  Future<List<TechnicalDocument>> searchDocuments(String query) async {
    try {
      // First try to search by title
      final QuerySnapshot titleSnapshot = await _documentsCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
          
      // Then try description
      final QuerySnapshot descSnapshot = await _documentsCollection
          .where('description', isGreaterThanOrEqualTo: query)
          .where('description', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
      
      // Combine results and remove duplicates
      final Set<String> documentIds = {};
      final List<TechnicalDocument> results = [];
      
      for (final doc in titleSnapshot.docs) {
        final docData = doc.data() as Map<String, dynamic>;
        if (!documentIds.contains(doc.id)) {
          documentIds.add(doc.id);
          results.add(TechnicalDocument.fromFirestore(docData, doc.id));
        }
      }
      
      for (final doc in descSnapshot.docs) {
        final docData = doc.data() as Map<String, dynamic>;
        if (!documentIds.contains(doc.id)) {
          documentIds.add(doc.id);
          results.add(TechnicalDocument.fromFirestore(docData, doc.id));
        }
      }
      
      return results;
    } catch (e) {
      debugPrint('Error searching documents: $e');
      return [];
    }
  }
}
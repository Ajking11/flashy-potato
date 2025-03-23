// lib/services/firebase_document_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class FirebaseDocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Collection references
  final CollectionReference _documentsCollection = 
      FirebaseFirestore.instance.collection('documents');
  
  // Get all documents from Firestore
  Future<List<TechnicalDocument>> getAllDocuments() async {
    try {
      final QuerySnapshot snapshot = await _documentsCollection.get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TechnicalDocument.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to load documents: $e');
    }
  }
  
  // Download a document from Firebase Storage to local device
  Future<String> downloadDocument(TechnicalDocument document) async {
    try {
      // Get the Firebase Storage reference
      final storageRef = _storage.ref().child('documents/${document.id}.pdf');
      
      // Get the local app directory
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${document.id}.pdf';
      final file = File(filePath);
      
      // Download the file
      await storageRef.writeToFile(file);
      
      // Update the document's isDownloaded status in Firestore
      await _documentsCollection.doc(document.id).update({
        'isDownloaded': true,
      });
      
      return filePath;
    } catch (e) {
      throw Exception('Failed to download document: $e');
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
      
      // Update the document's isDownloaded status in Firestore
      await _documentsCollection.doc(documentId).update({
        'isDownloaded': false,
      });
    } catch (e) {
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
}
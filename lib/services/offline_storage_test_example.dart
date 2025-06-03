// Example usage of enhanced offline storage with Drift
// This file demonstrates the new querying capabilities

import 'package:flutter/foundation.dart';
import '../models/document.dart';
import 'offline_storage_service.dart';

class OfflineStorageTestExample {
  final OfflineStorageService _offlineStorage = OfflineStorageService();

  // Example: Enhanced document search
  Future<void> demonstrateDocumentSearch() async {
    try {
      // Search across all document fields
      final searchResults = await _offlineStorage.searchDocuments("installation");
      debugPrint('Found ${searchResults.length} documents matching "installation"');

      // Get documents for a specific machine
      final machineDocuments = await _offlineStorage.getDocumentsByMachine("schaerer_scb");
      debugPrint('Found ${machineDocuments.length} documents for Schaerer SCB');

      // Get documents by category
      final manuals = await _offlineStorage.getDocumentsByCategory("Manual");
      debugPrint('Found ${manuals.length} manual documents');

      // Get only downloaded documents
      final offlineDocuments = await _offlineStorage.getDownloadedDocuments();
      debugPrint('Found ${offlineDocuments.length} downloaded documents');

      // Get specific document by ID
      final document = await _offlineStorage.getDocumentById("doc123");
      if (document != null) {
        debugPrint('Found document: ${document.title}');
      }
    } catch (e) {
      debugPrint('Error in document search demo: $e');
    }
  }

  // Example: Enhanced software search
  Future<void> demonstrateSoftwareSearch() async {
    try {
      // Search software
      final searchResults = await _offlineStorage.searchSoftware("firmware");
      debugPrint('Found ${searchResults.length} software items matching "firmware"');

      // Get software for a specific machine
      final machineSoftware = await _offlineStorage.getSoftwareByMachine("thermoplan_marlow");
      debugPrint('Found ${machineSoftware.length} software items for Thermoplan Marlow');

      // Get software by category
      final firmwareItems = await _offlineStorage.getSoftwareByCategory("Firmware");
      debugPrint('Found ${firmwareItems.length} firmware items');

      // Get downloaded software
      final offlineSoftware = await _offlineStorage.getDownloadedSoftware();
      debugPrint('Found ${offlineSoftware.length} downloaded software items');
    } catch (e) {
      debugPrint('Error in software search demo: $e');
    }
  }

  // Example: Enhanced machine search
  Future<void> demonstrateMachineSearch() async {
    try {
      // Search machines
      final searchResults = await _offlineStorage.searchMachines("schaerer");
      debugPrint('Found ${searchResults.length} machines matching "schaerer"');

      // Get specific machine by ID
      final machine = await _offlineStorage.getMachineById("schaerer_scb");
      if (machine != null) {
        debugPrint('Found machine: ${machine.manufacturer} ${machine.model}');
      }
    } catch (e) {
      debugPrint('Error in machine search demo: $e');
    }
  }

  // Example: Storage statistics
  Future<void> demonstrateStorageInfo() async {
    try {
      final storageInfo = await _offlineStorage.getStorageInfo();
      
      debugPrint('Storage Information:');
      debugPrint('Total files: ${storageInfo['totalFiles']}');
      debugPrint('Total size: ${storageInfo['totalSizeMB']?.toStringAsFixed(2)} MB');
      
      final dbInfo = storageInfo['database'] as Map<String, dynamic>?;
      if (dbInfo != null) {
        debugPrint('Database records:');
        debugPrint('- Machines: ${dbInfo['machines']}');
        debugPrint('- Documents: ${dbInfo['documents']}');
        debugPrint('- Software: ${dbInfo['software']}');
      }
    } catch (e) {
      debugPrint('Error getting storage info: $e');
    }
  }

  // Example: Combined search workflow
  Future<List<TechnicalDocument>> findRelevantDocuments(String machineId, String searchTerm) async {
    try {
      // First get all documents for the machine
      final machineDocuments = await _offlineStorage.getDocumentsByMachine(machineId);
      
      // Then search within those documents
      final allSearchResults = await _offlineStorage.searchDocuments(searchTerm);
      
      // Find intersection (documents that match both criteria)
      final relevantDocuments = machineDocuments.where((machineDoc) =>
        allSearchResults.any((searchDoc) => searchDoc.id == machineDoc.id)
      ).toList();
      
      debugPrint('Found ${relevantDocuments.length} documents for machine $machineId matching "$searchTerm"');
      return relevantDocuments;
    } catch (e) {
      debugPrint('Error in combined search: $e');
      return [];
    }
  }

  // Example: Offline-first workflow
  Future<List<TechnicalDocument>> getOfflineFirstDocuments(String category) async {
    try {
      // Prioritize downloaded documents
      final downloadedDocs = await _offlineStorage.getDownloadedDocuments();
      final categoryDownloaded = downloadedDocs.where((doc) => doc.category == category).toList();
      
      if (categoryDownloaded.isNotEmpty) {
        debugPrint('Found ${categoryDownloaded.length} offline documents in category $category');
        return categoryDownloaded;
      }
      
      // Fallback to all documents in category
      final allCategoryDocs = await _offlineStorage.getDocumentsByCategory(category);
      debugPrint('Found ${allCategoryDocs.length} total documents in category $category (some may require download)');
      return allCategoryDocs;
    } catch (e) {
      debugPrint('Error in offline-first workflow: $e');
      return [];
    }
  }
}

// Usage example in a widget or service:
/*
final testExample = OfflineStorageTestExample();

// Demonstrate all search capabilities
await testExample.demonstrateDocumentSearch();
await testExample.demonstrateSoftwareSearch();
await testExample.demonstrateMachineSearch();
await testExample.demonstrateStorageInfo();

// Find installation manuals for a specific machine
final docs = await testExample.findRelevantDocuments("schaerer_scb", "installation");

// Get offline-first manuals
final manuals = await testExample.getOfflineFirstDocuments("Manual");
*/
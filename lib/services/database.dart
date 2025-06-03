import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/document.dart';
import '../models/software.dart' as models;
import '../models/machine.dart' as models;

part 'database.g.dart';

// Document table matching TechnicalDocument model
class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get machineIds => text()(); // Comma-separated string
  TextColumn get category => text()();
  TextColumn get filePath => text()();
  TextColumn get downloadURL => text().nullable()();
  DateTimeColumn get uploadDate => dateTime()();
  IntColumn get fileSizeKB => integer()();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
  TextColumn get tags => text()(); // Comma-separated string
  TextColumn get uploadedBy => text().nullable()();
  TextColumn get sha256FileHash => text().nullable()();
  DateTimeColumn get lastSynced => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Software table matching Software model
class Softwares extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get version => text()();
  TextColumn get description => text()();
  TextColumn get machineIds => text()(); // Comma-separated string
  TextColumn get category => text()();
  TextColumn get filePath => text()();
  TextColumn get downloadURL => text().nullable()();
  DateTimeColumn get uploadDate => dateTime()();
  IntColumn get fileSizeKB => integer()();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
  TextColumn get tags => text()(); // Comma-separated string
  TextColumn get uploadedBy => text().nullable()();
  TextColumn get sha256FileHash => text().nullable()();
  TextColumn get changelogNotes => text()(); // Pipe-separated string
  TextColumn get previousVersion => text().nullable()();
  TextColumn get password => text().nullable()();
  TextColumn get concession => text()(); // Comma-separated string
  IntColumn get downloadCount => integer().withDefault(const Constant(0))();
  TextColumn get minVersion => text().nullable()();
  DateTimeColumn get lastSynced => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Machine table matching Machine model
class MachineEntries extends Table {
  TextColumn get id => text().named('machine_id')();
  TextColumn get manufacturer => text()();
  TextColumn get model => text()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get documentPath => text().nullable()();
  BoolColumn get displayInApp => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSynced => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  String get tableName => 'machines';
}

// Sync metadata table
class SyncMetadataTable extends Table {
  TextColumn get tableNameColumn => text().named('table_name')();
  DateTimeColumn get lastSyncTimestamp => dateTime()();
  IntColumn get recordCount => integer()();
  
  @override
  Set<Column> get primaryKey => {tableNameColumn};
  
  @override
  String get tableName => 'sync_metadata';
}

@DriftDatabase(tables: [Documents, Softwares, MachineEntries, SyncMetadataTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'costa_toolbox_db');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Create indexes for better query performance
      await customStatement(
        'CREATE INDEX idx_documents_category ON documents(category)',
      );
      await customStatement(
        'CREATE INDEX idx_documents_upload_date ON documents(upload_date)',
      );
      await customStatement(
        'CREATE INDEX idx_documents_machine_ids ON documents(machine_ids)',
      );
      await customStatement(
        'CREATE INDEX idx_software_category ON softwares(category)',
      );
      await customStatement(
        'CREATE INDEX idx_software_machine_ids ON softwares(machine_ids)',
      );
      await customStatement(
        'CREATE INDEX idx_machines_manufacturer ON machines(manufacturer)',
      );
    },
  );

  // Machine operations
  Future<List<models.Machine>> getAllMachines() async {
    try {
      final machineDataList = await select(machineEntries).get();
      return machineDataList.map(_machineDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting machines from database: $e');
      return [];
    }
  }

  Future<models.Machine?> getMachineById(String machineId) async {
    try {
      final machineData = await (select(machineEntries)..where((m) => m.id.equals(machineId))).getSingleOrNull();
      return machineData != null ? _machineDataToModel(machineData) : null;
    } catch (e) {
      debugPrint('Error getting machine by ID: $e');
      return null;
    }
  }

  Future<List<models.Machine>> searchMachines(String searchTerm) async {
    try {
      final query = select(machineEntries)
        ..where((m) => 
          m.manufacturer.contains(searchTerm) |
          m.model.contains(searchTerm) |
          m.description.contains(searchTerm));
      
      final machineDataList = await query.get();
      return machineDataList.map(_machineDataToModel).toList();
    } catch (e) {
      debugPrint('Error searching machines: $e');
      return [];
    }
  }

  Future<void> insertOrUpdateMachine(models.Machine machine) async {
    try {
      await into(machineEntries).insertOnConflictUpdate(_machineModelToData(machine));
    } catch (e) {
      debugPrint('Error inserting/updating machine: $e');
      throw Exception('Failed to save machine: $e');
    }
  }

  Future<void> insertOrUpdateMachines(List<models.Machine> machineList) async {
    try {
      await batch((batch) {
        for (final machine in machineList) {
          batch.insert(machineEntries, _machineModelToData(machine), mode: InsertMode.insertOrReplace);
        }
      });
    } catch (e) {
      debugPrint('Error batch inserting/updating machines: $e');
      throw Exception('Failed to save machines: $e');
    }
  }

  // Document operations
  Future<List<TechnicalDocument>> getAllDocuments() async {
    try {
      final documentDataList = await select(documents).get();
      return documentDataList.map(_documentDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting documents from database: $e');
      return [];
    }
  }

  Future<TechnicalDocument?> getDocumentById(String documentId) async {
    try {
      final documentData = await (select(documents)..where((d) => d.id.equals(documentId))).getSingleOrNull();
      return documentData != null ? _documentDataToModel(documentData) : null;
    } catch (e) {
      debugPrint('Error getting document by ID: $e');
      return null;
    }
  }

  Future<List<TechnicalDocument>> getDocumentsByMachine(String machineId) async {
    try {
      final documentDataList = await (select(documents)
        ..where((d) => d.machineIds.contains(machineId))).get();
      return documentDataList.map(_documentDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting documents by machine: $e');
      return [];
    }
  }

  Future<List<TechnicalDocument>> getDocumentsByCategory(String category) async {
    try {
      final documentDataList = await (select(documents)
        ..where((d) => d.category.equals(category))).get();
      return documentDataList.map(_documentDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting documents by category: $e');
      return [];
    }
  }

  Future<List<TechnicalDocument>> searchDocuments(String searchTerm) async {
    try {
      final query = select(documents)
        ..where((d) => 
          d.title.contains(searchTerm) |
          d.description.contains(searchTerm) |
          d.category.contains(searchTerm) |
          d.tags.contains(searchTerm));
      
      final documentDataList = await query.get();
      return documentDataList.map(_documentDataToModel).toList();
    } catch (e) {
      debugPrint('Error searching documents: $e');
      return [];
    }
  }

  Future<List<TechnicalDocument>> getDownloadedDocuments() async {
    try {
      final documentDataList = await (select(documents)
        ..where((d) => d.isDownloaded.equals(true))).get();
      return documentDataList.map(_documentDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting downloaded documents: $e');
      return [];
    }
  }

  Future<void> insertOrUpdateDocument(TechnicalDocument document) async {
    try {
      await into(documents).insertOnConflictUpdate(_documentModelToData(document));
    } catch (e) {
      debugPrint('Error inserting/updating document: $e');
      throw Exception('Failed to save document: $e');
    }
  }

  Future<void> insertOrUpdateDocuments(List<TechnicalDocument> documentList) async {
    try {
      await batch((batch) {
        for (final document in documentList) {
          batch.insert(documents, _documentModelToData(document), mode: InsertMode.insertOrReplace);
        }
      });
    } catch (e) {
      debugPrint('Error batch inserting/updating documents: $e');
      throw Exception('Failed to save documents: $e');
    }
  }

  // Software operations
  Future<List<models.Software>> getAllSoftware() async {
    try {
      final softwareDataList = await select(softwares).get();
      return softwareDataList.map(_softwareDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting software from database: $e');
      return [];
    }
  }

  Future<models.Software?> getSoftwareById(String softwareId) async {
    try {
      final softwareData = await (select(softwares)..where((s) => s.id.equals(softwareId))).getSingleOrNull();
      return softwareData != null ? _softwareDataToModel(softwareData) : null;
    } catch (e) {
      debugPrint('Error getting software by ID: $e');
      return null;
    }
  }

  Future<List<models.Software>> getSoftwareByMachine(String machineId) async {
    try {
      final softwareDataList = await (select(softwares)
        ..where((s) => s.machineIds.contains(machineId))).get();
      return softwareDataList.map(_softwareDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting software by machine: $e');
      return [];
    }
  }

  Future<List<models.Software>> getSoftwareByCategory(String category) async {
    try {
      final softwareDataList = await (select(softwares)
        ..where((s) => s.category.equals(category))).get();
      return softwareDataList.map(_softwareDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting software by category: $e');
      return [];
    }
  }

  Future<List<models.Software>> searchSoftware(String searchTerm) async {
    try {
      final query = select(softwares)
        ..where((s) => 
          s.name.contains(searchTerm) |
          s.description.contains(searchTerm) |
          s.category.contains(searchTerm) |
          s.tags.contains(searchTerm));
      
      final softwareDataList = await query.get();
      return softwareDataList.map(_softwareDataToModel).toList();
    } catch (e) {
      debugPrint('Error searching software: $e');
      return [];
    }
  }

  Future<List<models.Software>> getDownloadedSoftware() async {
    try {
      final softwareDataList = await (select(softwares)
        ..where((s) => s.isDownloaded.equals(true))).get();
      return softwareDataList.map(_softwareDataToModel).toList();
    } catch (e) {
      debugPrint('Error getting downloaded software: $e');
      return [];
    }
  }

  Future<void> insertOrUpdateSoftware(models.Software software) async {
    try {
      await into(softwares).insertOnConflictUpdate(_softwareModelToData(software));
    } catch (e) {
      debugPrint('Error inserting/updating software: $e');
      throw Exception('Failed to save software: $e');
    }
  }

  Future<void> insertOrUpdateSoftwares(List<models.Software> softwareList) async {
    try {
      await batch((batch) {
        for (final software in softwareList) {
          batch.insert(softwares, _softwareModelToData(software), mode: InsertMode.insertOrReplace);
        }
      });
    } catch (e) {
      debugPrint('Error batch inserting/updating software: $e');
      throw Exception('Failed to save software: $e');
    }
  }

  // Sync metadata operations
  Future<void> updateSyncMetadata(String tableName, int recordCount) async {
    try {
      await into(syncMetadataTable).insertOnConflictUpdate(
        SyncMetadataTableData(
          tableNameColumn: tableName,
          lastSyncTimestamp: DateTime.now(),
          recordCount: recordCount,
        ),
      );
    } catch (e) {
      debugPrint('Error updating sync metadata: $e');
    }
  }

  Future<DateTime?> getLastSyncTimestamp(String tableName) async {
    try {
      final metadata = await (select(syncMetadataTable)
        ..where((m) => m.tableNameColumn.equals(tableName))).getSingleOrNull();
      return metadata?.lastSyncTimestamp;
    } catch (e) {
      debugPrint('Error getting last sync timestamp: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getSyncInfo() async {
    try {
      final metadataList = await select(syncMetadataTable).get();
      final info = <String, dynamic>{};
      
      for (final metadata in metadataList) {
        info[metadata.tableNameColumn] = {
          'lastSync': metadata.lastSyncTimestamp.toIso8601String(),
          'recordCount': metadata.recordCount,
        };
      }
      
      return info;
    } catch (e) {
      debugPrint('Error getting sync info: $e');
      return {};
    }
  }

  // Utility operations
  Future<void> clearAllData() async {
    try {
      await batch((batch) {
        batch.deleteAll(machineEntries);
        batch.deleteAll(documents);
        batch.deleteAll(softwares);
        batch.deleteAll(syncMetadataTable);
      });
      debugPrint('Cleared all offline data from database');
    } catch (e) {
      debugPrint('Error clearing all data: $e');
      throw Exception('Failed to clear offline data: $e');
    }
  }

  Future<Map<String, int>> getStorageStats() async {
    try {
      final machineCount = await (selectOnly(machineEntries)..addColumns([machineEntries.id.count()])).getSingle();
      final documentCount = await (selectOnly(documents)..addColumns([documents.id.count()])).getSingle();
      final softwareCount = await (selectOnly(softwares)..addColumns([softwares.id.count()])).getSingle();
      
      return {
        'machines': machineCount.read(machineEntries.id.count()) ?? 0,
        'documents': documentCount.read(documents.id.count()) ?? 0,
        'software': softwareCount.read(softwares.id.count()) ?? 0,
      };
    } catch (e) {
      debugPrint('Error getting storage stats: $e');
      return {'machines': 0, 'documents': 0, 'software': 0};
    }
  }

  // Conversion helpers
  models.Machine _machineDataToModel(MachineEntry data) {
    return models.Machine(
      machineId: data.id,
      manufacturer: data.manufacturer,
      model: data.model,
      imagePath: data.imagePath,
      description: data.description,
      documentPath: data.documentPath,
      displayInApp: data.displayInApp,
    );
  }

  MachineEntriesCompanion _machineModelToData(models.Machine machine) {
    return MachineEntriesCompanion.insert(
      id: machine.machineId,
      manufacturer: machine.manufacturer,
      model: machine.model,
      imagePath: Value(machine.imagePath),
      description: Value(machine.description),
      documentPath: Value(machine.documentPath),
      displayInApp: Value(machine.displayInApp),
      lastSynced: Value(DateTime.now()),
    );
  }

  TechnicalDocument _documentDataToModel(Document data) {
    final machineIds = data.machineIds.isNotEmpty 
        ? List<String>.from(data.machineIds.split(',').where((id) => id.isNotEmpty))
        : <String>[];
    
    final tags = data.tags.isNotEmpty 
        ? List<String>.from(data.tags.split(',').where((tag) => tag.isNotEmpty))
        : <String>[];

    return TechnicalDocument(
      id: data.id,
      title: data.title,
      description: data.description,
      machineIds: machineIds,
      category: data.category,
      filePath: data.filePath,
      downloadURL: data.downloadURL,
      uploadDate: data.uploadDate,
      fileSizeKB: data.fileSizeKB,
      isDownloaded: data.isDownloaded,
      tags: tags,
      uploadedBy: data.uploadedBy,
      sha256FileHash: data.sha256FileHash,
    );
  }

  DocumentsCompanion _documentModelToData(TechnicalDocument document) {
    return DocumentsCompanion.insert(
      id: document.id,
      title: document.title,
      description: document.description,
      machineIds: document.machineIds.join(','),
      category: document.category,
      filePath: document.filePath,
      downloadURL: Value(document.downloadURL),
      uploadDate: document.uploadDate,
      fileSizeKB: document.fileSizeKB,
      isDownloaded: Value(document.isDownloaded),
      tags: document.tags.join(','),
      uploadedBy: Value(document.uploadedBy),
      sha256FileHash: Value(document.sha256FileHash),
      lastSynced: Value(DateTime.now()),
    );
  }

  models.Software _softwareDataToModel(Software data) {
    final machineIds = data.machineIds.isNotEmpty 
        ? List<String>.from(data.machineIds.split(',').where((id) => id.isNotEmpty))
        : <String>[];
    
    final tags = data.tags.isNotEmpty 
        ? List<String>.from(data.tags.split(',').where((tag) => tag.isNotEmpty))
        : <String>[];
    
    final changelogNotes = data.changelogNotes.isNotEmpty 
        ? List<String>.from(data.changelogNotes.split('|').where((note) => note.isNotEmpty))
        : <String>[];
    
    final concession = data.concession.isNotEmpty 
        ? List<String>.from(data.concession.split(',').where((con) => con.isNotEmpty))
        : <String>[];

    return models.Software(
      id: data.id,
      name: data.name,
      version: data.version,
      description: data.description,
      machineIds: machineIds,
      category: data.category,
      filePath: data.filePath,
      downloadURL: data.downloadURL,
      uploadDate: data.uploadDate,
      fileSizeKB: data.fileSizeKB,
      isDownloaded: data.isDownloaded,
      tags: tags,
      uploadedBy: data.uploadedBy,
      sha256FileHash: data.sha256FileHash,
      changelogNotes: changelogNotes,
      previousVersion: data.previousVersion,
      password: data.password,
      concession: concession,
      downloadCount: data.downloadCount,
      minVersion: data.minVersion,
    );
  }

  SoftwaresCompanion _softwareModelToData(models.Software software) {
    return SoftwaresCompanion.insert(
      id: software.id,
      name: software.name,
      version: software.version,
      description: software.description,
      machineIds: software.machineIds.join(','),
      category: software.category,
      filePath: software.filePath,
      downloadURL: Value(software.downloadURL),
      uploadDate: software.uploadDate,
      fileSizeKB: software.fileSizeKB,
      isDownloaded: Value(software.isDownloaded),
      tags: software.tags.join(','),
      uploadedBy: Value(software.uploadedBy),
      sha256FileHash: Value(software.sha256FileHash),
      changelogNotes: software.changelogNotes.join('|'), // Use pipe separator for changelog notes
      previousVersion: Value(software.previousVersion),
      password: Value(software.password),
      concession: software.concession.join(','),
      downloadCount: Value(software.downloadCount),
      minVersion: Value(software.minVersion),
      lastSynced: Value(DateTime.now()),
    );
  }
}
class Software {
  final String id;
  final String name;
  final String version;
  final String description;
  final List<String> machineIds; // Multiple machines can be associated with software
  final String category;
  final String filePath; // Path to the software package in Firebase Storage
  final String? downloadURL; // Direct download URL
  final DateTime releaseDate;
  final int fileSizeKB;
  final bool isDownloaded; // Track if the software is available offline
  final List<String> tags; // For searching
  final String? uploadedBy; // User who uploaded the software
  final String? sha256FileHash; // Hash for software verification
  final List<String> changelogNotes; // What's new in this version
  final String? previousVersion; // Reference to the previous version
  final String? password; // Password for protected software
  final List<String> concession; // Concession machines compatible with software
  final int downloadCount; // Number of times the software has been downloaded
  final String? minVersion; // Minimum version required

  // For backward compatibility when we need a single machineId
  String get machineId => machineIds.isNotEmpty ? machineIds.first : '';

  Software({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.machineIds,
    required this.category,
    required this.filePath,
    this.downloadURL,
    required this.releaseDate,
    required this.fileSizeKB,
    this.isDownloaded = false,
    this.tags = const [],
    this.uploadedBy,
    this.sha256FileHash,
    this.changelogNotes = const [],
    this.previousVersion,
    this.password,
    this.concession = const [],
    this.downloadCount = 0,
    this.minVersion,
  });

  // Factory constructor to create from JSON (local files)
  factory Software.fromJson(Map<String, dynamic> json) {
    // Handle concession which might be a string or list
    List<String> concession = [];
    if (json['concession'] is List) {
      concession = List<String>.from(json['concession']);
    } else if (json['concession'] is String && json['concession'].isNotEmpty) {
      concession = [json['concession']];
    }
    
    return Software(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      description: json['description'],
      machineIds: json['machineId'] is List 
          ? List<String>.from(json['machineId'])
          : json['machineId'] != null 
              ? [json['machineId']]
              : [],
      category: json['category'],
      filePath: json['filePath'],
      downloadURL: json['downloadURL'],
      releaseDate: json['releaseDate'] is String
          ? DateTime.parse(json['releaseDate'])
          : (json['releaseDate'] as DateTime?) ?? DateTime.now(),
      fileSizeKB: json['fileSizeKB'] ?? 0,
      isDownloaded: json['isDownloaded'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      uploadedBy: json['uploadedBy'],
      sha256FileHash: json['sha256FileHash'],
      changelogNotes: List<String>.from(json['changelogNotes'] ?? []),
      previousVersion: json['previousVersion'],
      password: json['password'],
      concession: concession,
      downloadCount: json['downloadCount'] ?? 0,
      minVersion: json['minVersion'],
    );
  }

  // Factory constructor to create from Firestore document
  factory Software.fromFirestore(Map<String, dynamic> doc, String docId) {
    // Handle the Timestamp type from Firestore
    DateTime releaseDate;
    if (doc['releaseDate'] is DateTime) {
      releaseDate = doc['releaseDate'];
    } else if (doc['releaseDate'] != null) {
      try {
        releaseDate = doc['releaseDate'].toDate();
      } catch (e) {
        releaseDate = DateTime.now();
      }
    } else {
      releaseDate = DateTime.now();
    }

    // Handle different ways machines can be stored (array, single string, or null)
    List<String> machineIds = [];
    if (doc['machineId'] is List) {
      machineIds = List<String>.from(doc['machineId']);
    } else if (doc['machineId'] != null && doc['machineId'] is String) {
      machineIds = [doc['machineId']];
    }
    
    // Handle categories which might be arrays in Firestore
    String category = '';
    if (doc['category'] is List && (doc['category'] as List).isNotEmpty) {
      category = (doc['category'] as List).first.toString();
    } else if (doc['category'] is String) {
      category = doc['category'];
    }
    
    // Handle file size which might be a number or string
    int fileSizeKB = 0;
    if (doc['fileSizeKB'] is int) {
      fileSizeKB = doc['fileSizeKB'];
    } else if (doc['fileSizeKB'] is String) {
      fileSizeKB = int.tryParse(doc['fileSizeKB']) ?? 0;
    } else if (doc['fileSizeKB'] != null) {
      fileSizeKB = (doc['fileSizeKB'] as num).toInt();
    }

    // Handle changelog notes which might be stored differently
    List<String> changelogNotes = [];
    if (doc['changelogNotes'] is List) {
      changelogNotes = List<String>.from(doc['changelogNotes']);
    } else if (doc['changelogNotes'] is String) {
      changelogNotes = [doc['changelogNotes']];
    }
    
    // Handle concession machines which might be stored differently
    List<String> concession = [];
    if (doc['concession'] is List) {
      concession = List<String>.from(doc['concession']);
    } else if (doc['concession'] is String && doc['concession'].isNotEmpty) {
      concession = [doc['concession']];
    }
    
    // Handle download count which might be a number or string
    int downloadCount = 0;
    if (doc['downloadCount'] is int) {
      downloadCount = doc['downloadCount'];
    } else if (doc['downloadCount'] is String) {
      downloadCount = int.tryParse(doc['downloadCount']) ?? 0;
    } else if (doc['downloadCount'] != null) {
      downloadCount = (doc['downloadCount'] as num).toInt();
    }

    return Software(
      id: docId,
      name: doc['name'] ?? 'Untitled Software',
      version: doc['version'] ?? '1.0.0',
      description: doc['description'] ?? '',
      machineIds: machineIds,
      category: category,
      filePath: doc['filePath'] ?? '',
      downloadURL: doc['downloadURL'],
      releaseDate: releaseDate,
      fileSizeKB: fileSizeKB,
      isDownloaded: doc['isDownloaded'] ?? false,
      uploadedBy: doc['uploadedBy'],
      sha256FileHash: doc['sha256FileHash'],
      changelogNotes: changelogNotes,
      previousVersion: doc['previousVersion'],
      password: doc['password'],
      concession: concession,
      downloadCount: downloadCount,
      minVersion: doc['minVersion'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'description': description,
      'machineId': machineIds,
      'category': category,
      'filePath': filePath,
      'downloadURL': downloadURL,
      'releaseDate': releaseDate.toIso8601String(),
      'fileSizeKB': fileSizeKB,
      'isDownloaded': isDownloaded,
      'tags': tags,
      'uploadedBy': uploadedBy,
      'sha256FileHash': sha256FileHash,
      'changelogNotes': changelogNotes,
      'previousVersion': previousVersion,
      'password': password,
      'concession': concession,
      'downloadCount': downloadCount,
      'minVersion': minVersion,
    };
  }

  // Create a copy with some fields changed
  Software copyWith({
    String? id,
    String? name,
    String? version,
    String? description,
    List<String>? machineIds,
    String? category,
    String? filePath,
    String? downloadURL,
    DateTime? releaseDate,
    int? fileSizeKB,
    bool? isDownloaded,
    List<String>? tags,
    String? uploadedBy,
    String? sha256FileHash,
    List<String>? changelogNotes,
    String? previousVersion,
    String? password,
    List<String>? concession,
    int? downloadCount,
    String? minVersion,
  }) {
    return Software(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      description: description ?? this.description,
      machineIds: machineIds ?? this.machineIds,
      category: category ?? this.category,
      filePath: filePath ?? this.filePath,
      downloadURL: downloadURL ?? this.downloadURL,
      releaseDate: releaseDate ?? this.releaseDate,
      fileSizeKB: fileSizeKB ?? this.fileSizeKB,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      tags: tags ?? this.tags,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      sha256FileHash: sha256FileHash ?? this.sha256FileHash,
      changelogNotes: changelogNotes ?? this.changelogNotes,
      previousVersion: previousVersion ?? this.previousVersion,
      password: password ?? this.password,
      concession: concession ?? this.concession,
      downloadCount: downloadCount ?? this.downloadCount,
      minVersion: minVersion ?? this.minVersion,
    );
  }
}

// Software categories
class SoftwareCategory {
  static const String firmware = 'Firmware';
  static const String utility = 'Utility';
  static const String diagnostic = 'Diagnostic';
  static const String update = 'Software Update';
  static const String driver = 'Driver';
  static const String calibration = 'Calibration Tool';
  static const String configuration = 'Configuration Tool';
  static const String promo = 'Promo';

  static List<String> getAllCategories() {
    return [firmware, utility, diagnostic, update, driver, calibration, configuration, promo];
  }
}
class TechnicalDocument {
  final String id;
  final String title;
  final String description;
  final List<String> machineIds; // Multiple machines can be associated with a document
  final String category;
  final String filePath; // Path to the PDF file in Firebase Storage
  final String? downloadURL; // Direct download URL
  final DateTime uploadDate;
  final int fileSizeKB;
  final bool isDownloaded; // Track if the document is available offline
  final List<String> tags; // For searching
  final String? uploadedBy; // User who uploaded the document
  final String? sha256FileHash; // Hash for document verification

  // For backward compatibility when we need a single machineId
  String get machineId => machineIds.isNotEmpty ? machineIds.first : '';

  TechnicalDocument({
    required this.id,
    required this.title,
    required this.description,
    required this.machineIds,
    required this.category,
    required this.filePath,
    this.downloadURL,
    required this.uploadDate,
    required this.fileSizeKB,
    this.isDownloaded = false,
    this.tags = const [],
    this.uploadedBy,
    this.sha256FileHash,
  });

  // Factory constructor to create from JSON (local files)
  factory TechnicalDocument.fromJson(Map<String, dynamic> json) {
    return TechnicalDocument(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      machineIds: json['machineId'] is List 
          ? List<String>.from(json['machineId'])
          : json['machineId'] != null 
              ? [json['machineId']]
              : [],
      category: json['category'],
      filePath: json['filePath'],
      downloadURL: json['downloadURL'],
      uploadDate: json['uploadDate'] is String
          ? DateTime.parse(json['uploadDate'])
          : (json['uploadDate'] as DateTime?) ?? DateTime.now(),
      fileSizeKB: json['fileSizeKB'],
      isDownloaded: json['isDownloaded'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      uploadedBy: json['uploadedBy'],
      sha256FileHash: json['sha256FileHash'],
    );
  }

  // Factory constructor to create from Firestore document
  factory TechnicalDocument.fromFirestore(Map<String, dynamic> doc, String docId) {
    // Handle the Timestamp type from Firestore
    DateTime uploadDate;
    if (doc['uploadDate'] is DateTime) {
      uploadDate = doc['uploadDate'];
    } else if (doc['uploadDate'] != null) {
      try {
        uploadDate = doc['uploadDate'].toDate();
      } catch (e) {
        uploadDate = DateTime.now();
      }
    } else {
      uploadDate = DateTime.now();
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

    return TechnicalDocument(
      id: docId,
      title: doc['title'] ?? 'Untitled Document',
      description: doc['description'] ?? '',
      machineIds: machineIds,
      category: category,
      filePath: doc['filePath'] ?? '',
      downloadURL: doc['downloadURL'],
      uploadDate: uploadDate,
      fileSizeKB: fileSizeKB,
      isDownloaded: doc['isDownloaded'] ?? false,
      uploadedBy: doc['uploadedBy'],
      sha256FileHash: doc['sha256FileHash'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'machineId': machineIds,
      'category': category,
      'filePath': filePath,
      'downloadURL': downloadURL,
      'uploadDate': uploadDate.toIso8601String(),
      'fileSizeKB': fileSizeKB,
      'isDownloaded': isDownloaded,
      'tags': tags,
      'uploadedBy': uploadedBy,
      'sha256FileHash': sha256FileHash,
    };
  }

  // Create a copy with some fields changed
  TechnicalDocument copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? machineIds,
    String? category,
    String? filePath,
    String? downloadURL,
    DateTime? uploadDate,
    int? fileSizeKB,
    bool? isDownloaded,
    List<String>? tags,
    String? uploadedBy,
    String? sha256FileHash,
  }) {
    return TechnicalDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      machineIds: machineIds ?? this.machineIds,
      category: category ?? this.category,
      filePath: filePath ?? this.filePath,
      downloadURL: downloadURL ?? this.downloadURL,
      uploadDate: uploadDate ?? this.uploadDate,
      fileSizeKB: fileSizeKB ?? this.fileSizeKB,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      tags: tags ?? this.tags,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      sha256FileHash: sha256FileHash ?? this.sha256FileHash,
    );
  }
}

// Document categories
class DocumentCategory {
  static const String manual = 'Manual';
  static const String maintenance = 'Maintenance';
  static const String troubleshooting = 'Troubleshooting';
  static const String parts = 'Parts Catalog';
  static const String training = 'Training';
  static const String technical = 'Technical Bulletin';
  static const String bulletin = 'Bulletin';  // New category
  static const String install = 'Install';    // New category

  static List<String> getAllCategories() {
    return [manual, maintenance, troubleshooting, parts, training, technical, bulletin, install];
  }
}
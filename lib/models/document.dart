class TechnicalDocument {
  final String id;
  final String title;
  final String description;
  final String machineId; // Related machine
  final String category;
  final String filePath; // Path to the PDF file
  final DateTime uploadDate;
  final int fileSizeKB;
  final bool isDownloaded; // Track if the document is available offline
  final List<String> tags; // For searching

  TechnicalDocument({
    required this.id,
    required this.title,
    required this.description,
    required this.machineId,
    required this.category,
    required this.filePath,
    required this.uploadDate,
    required this.fileSizeKB,
    this.isDownloaded = false,
    this.tags = const [],
  });

  // Factory constructor to create from JSON
  factory TechnicalDocument.fromJson(Map<String, dynamic> json) {
    return TechnicalDocument(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      machineId: json['machineId'],
      category: json['category'],
      filePath: json['filePath'],
      uploadDate: DateTime.parse(json['uploadDate']),
      fileSizeKB: json['fileSizeKB'],
      isDownloaded: json['isDownloaded'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'machineId': machineId,
      'category': category,
      'filePath': filePath,
      'uploadDate': uploadDate.toIso8601String(),
      'fileSizeKB': fileSizeKB,
      'isDownloaded': isDownloaded,
      'tags': tags,
    };
  }

  // Create a copy with some fields changed
  TechnicalDocument copyWith({
    String? id,
    String? title,
    String? description,
    String? machineId,
    String? category,
    String? filePath,
    DateTime? uploadDate,
    int? fileSizeKB,
    bool? isDownloaded,
    List<String>? tags,
  }) {
    return TechnicalDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      machineId: machineId ?? this.machineId,
      category: category ?? this.category,
      filePath: filePath ?? this.filePath,
      uploadDate: uploadDate ?? this.uploadDate,
      fileSizeKB: fileSizeKB ?? this.fileSizeKB,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      tags: tags ?? this.tags,
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

  static List<String> getAllCategories() {
    return [manual, maintenance, troubleshooting, parts, training, technical];
  }
}
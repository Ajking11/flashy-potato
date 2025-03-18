class UserPreferences {
  // Favorite machines (store machineId list)
  final List<String> favoriteMachineIds;
  
  // Favorite filters (store filter type/id list)
  final List<String> favoriteFilterTypes;
  
  // Notification preferences
  final bool notifyDocumentUpdates;
  final bool notifyImportantInfo;
  
  // Last update check timestamp
  final DateTime lastUpdateCheck;

  // Use a factory constructor for the default value
  factory UserPreferences.defaultPrefs() {
    return UserPreferences(
      favoriteMachineIds: const [],
      favoriteFilterTypes: const [],
      notifyDocumentUpdates: true,
      notifyImportantInfo: true,
      lastUpdateCheck: DateTime(2025, 3, 1),
    );
  }

  // Regular constructor without default values for the DateTime
  const UserPreferences({
    this.favoriteMachineIds = const [],
    this.favoriteFilterTypes = const [],
    this.notifyDocumentUpdates = true,
    this.notifyImportantInfo = true,
    required this.lastUpdateCheck,
  });

  // Create copy with updated fields
  UserPreferences copyWith({
    List<String>? favoriteMachineIds,
    List<String>? favoriteFilterTypes,
    bool? notifyDocumentUpdates,
    bool? notifyImportantInfo,
    DateTime? lastUpdateCheck,
  }) {
    return UserPreferences(
      favoriteMachineIds: favoriteMachineIds ?? this.favoriteMachineIds,
      favoriteFilterTypes: favoriteFilterTypes ?? this.favoriteFilterTypes,
      notifyDocumentUpdates: notifyDocumentUpdates ?? this.notifyDocumentUpdates,
      notifyImportantInfo: notifyImportantInfo ?? this.notifyImportantInfo,
      lastUpdateCheck: lastUpdateCheck ?? this.lastUpdateCheck,
    );
  }

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'favoriteMachineIds': favoriteMachineIds,
      'favoriteFilterTypes': favoriteFilterTypes,
      'notifyDocumentUpdates': notifyDocumentUpdates,
      'notifyImportantInfo': notifyImportantInfo,
      'lastUpdateCheck': lastUpdateCheck.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteMachineIds: List<String>.from(json['favoriteMachineIds'] ?? []),
      favoriteFilterTypes: List<String>.from(json['favoriteFilterTypes'] ?? []),
      notifyDocumentUpdates: json['notifyDocumentUpdates'] ?? true,
      notifyImportantInfo: json['notifyImportantInfo'] ?? true,
      lastUpdateCheck: json['lastUpdateCheck'] != null 
          ? DateTime.parse(json['lastUpdateCheck']) 
          : DateTime(2025, 3, 1),
    );
  }
}
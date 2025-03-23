class UserPreferences {
  // Favorite machines (store machineId list)
  final List<String> favoriteMachineIds;
  
  // Favorite filters (store filter type/id list)
  final List<String> favoriteFilterTypes;
  
  // Notification preferences
  final bool notifyDocumentUpdates;
  final bool notifyImportantInfo;
  
  // User information
  final String? userEmail;
  final bool isEmailConfirmed; // New field to track email confirmation
  
  // Last update check timestamp
  final DateTime lastUpdateCheck;

  // Use a factory constructor for the default value
  factory UserPreferences.defaultPrefs() {
    return UserPreferences(
      favoriteMachineIds: const [],
      favoriteFilterTypes: const [],
      notifyDocumentUpdates: true,
      notifyImportantInfo: true,
      userEmail: null,
      isEmailConfirmed: false,
      lastUpdateCheck: DateTime(2025, 3, 1),
    );
  }

  // Regular constructor without default values for the DateTime
  const UserPreferences({
    this.favoriteMachineIds = const [],
    this.favoriteFilterTypes = const [],
    this.notifyDocumentUpdates = true,
    this.notifyImportantInfo = true,
    this.userEmail,
    this.isEmailConfirmed = false,
    required this.lastUpdateCheck,
  });

  // Create copy with updated fields
  UserPreferences copyWith({
    List<String>? favoriteMachineIds,
    List<String>? favoriteFilterTypes,
    bool? notifyDocumentUpdates,
    bool? notifyImportantInfo,
    String? userEmail,
    bool? isEmailConfirmed,
    DateTime? lastUpdateCheck,
  }) {
    return UserPreferences(
      favoriteMachineIds: favoriteMachineIds ?? this.favoriteMachineIds,
      favoriteFilterTypes: favoriteFilterTypes ?? this.favoriteFilterTypes,
      notifyDocumentUpdates: notifyDocumentUpdates ?? this.notifyDocumentUpdates,
      notifyImportantInfo: notifyImportantInfo ?? this.notifyImportantInfo,
      userEmail: userEmail ?? this.userEmail,
      isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
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
      'userEmail': userEmail,
      'isEmailConfirmed': isEmailConfirmed,
      'lastUpdateCheck': lastUpdateCheck.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteMachineIds: List<String>.from(json['favoriteMachineIds'] ?? []),
      favoriteFilterTypes: List<String>.from(json['favoriteFilterTypes'] ?? []),
      notifyDocumentUpdates: json['notifyDocumentUpdates'] ?? true,
      notifyImportantInfo: json['notifyImportantInfo'] ?? true,
      userEmail: json['userEmail'],
      isEmailConfirmed: json['isEmailConfirmed'] ?? false,
      lastUpdateCheck: json['lastUpdateCheck'] != null 
          ? DateTime.parse(json['lastUpdateCheck']) 
          : DateTime(2025, 3, 1),
    );
  }
}
class UserPreferences {
  
  // Notification preferences
  final bool notifyDocumentUpdates;
  final bool notifyImportantInfo;
  
  // User information
  final String? userEmail;
  final bool isEmailConfirmed;
  
  // Favorites
  final List<String>? favoriteMachineIds;
  final List<String>? favoriteFilterTypes;
  
  // Last update check timestamp
  final DateTime lastUpdateCheck;

  // Use a factory constructor for the default value
  factory UserPreferences.defaultPrefs() {
    return UserPreferences(
      notifyDocumentUpdates: true,
      notifyImportantInfo: true,
      userEmail: null,
      isEmailConfirmed: false,
      favoriteMachineIds: [],
      favoriteFilterTypes: [],
      lastUpdateCheck: DateTime(2025, 3, 1),
    );
  }

  // Regular constructor without default values for the DateTime
  const UserPreferences({
    this.notifyDocumentUpdates = true,
    this.notifyImportantInfo = true,
    this.userEmail,
    this.isEmailConfirmed = false,
    this.favoriteMachineIds,
    this.favoriteFilterTypes,
    required this.lastUpdateCheck,
  });

  // Create copy with updated fields
  UserPreferences copyWith({
    bool? notifyDocumentUpdates,
    bool? notifyImportantInfo,
    String? userEmail,
    bool? isEmailConfirmed,
    List<String>? favoriteMachineIds,
    List<String>? favoriteFilterTypes,
    DateTime? lastUpdateCheck,
  }) {
    return UserPreferences(
      notifyDocumentUpdates: notifyDocumentUpdates ?? this.notifyDocumentUpdates,
      notifyImportantInfo: notifyImportantInfo ?? this.notifyImportantInfo,
      userEmail: userEmail ?? this.userEmail,
      isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
      favoriteMachineIds: favoriteMachineIds ?? this.favoriteMachineIds,
      favoriteFilterTypes: favoriteFilterTypes ?? this.favoriteFilterTypes,
      lastUpdateCheck: lastUpdateCheck ?? this.lastUpdateCheck,
    );
  }

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'notifyDocumentUpdates': notifyDocumentUpdates,
      'notifyImportantInfo': notifyImportantInfo,
      'userEmail': userEmail,
      'isEmailConfirmed': isEmailConfirmed,
      'favoriteMachineIds': favoriteMachineIds,
      'favoriteFilterTypes': favoriteFilterTypes,
      'lastUpdateCheck': lastUpdateCheck.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notifyDocumentUpdates: json['notifyDocumentUpdates'] ?? true,
      notifyImportantInfo: json['notifyImportantInfo'] ?? true,
      userEmail: json['userEmail'],
      isEmailConfirmed: json['isEmailConfirmed'] ?? false,
      favoriteMachineIds: json['favoriteMachineIds'] != null 
          ? List<String>.from(json['favoriteMachineIds']) 
          : [],
      favoriteFilterTypes: json['favoriteFilterTypes'] != null 
          ? List<String>.from(json['favoriteFilterTypes']) 
          : [],
      lastUpdateCheck: json['lastUpdateCheck'] != null 
          ? DateTime.parse(json['lastUpdateCheck']) 
          : DateTime(2025, 3, 1),
    );
  }
}
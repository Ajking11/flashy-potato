// lib/models/filter_recommendation.dart
import 'package:flutter/foundation.dart';

@immutable
class FilterRecommendation {
  final int tempHardness;
  final int totalHardness;
  final int cpd;
  final String filterType;
  final String filterSize;
  final String bypass;
  final int capacity;
  final DateTime createdAt;
  
  const FilterRecommendation({
    required this.tempHardness,
    required this.totalHardness,
    required this.cpd,
    required this.filterType,
    required this.filterSize,
    required this.bypass,
    required this.capacity,
    required this.createdAt,
  });
  
  // Create a copy with updated fields
  FilterRecommendation copyWith({
    int? tempHardness,
    int? totalHardness,
    int? cpd,
    String? filterType,
    String? filterSize,
    String? bypass,
    int? capacity,
    DateTime? createdAt,
  }) {
    return FilterRecommendation(
      tempHardness: tempHardness ?? this.tempHardness,
      totalHardness: totalHardness ?? this.totalHardness,
      cpd: cpd ?? this.cpd,
      filterType: filterType ?? this.filterType,
      filterSize: filterSize ?? this.filterSize,
      bypass: bypass ?? this.bypass,
      capacity: capacity ?? this.capacity,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'tempHardness': tempHardness,
      'totalHardness': totalHardness,
      'cpd': cpd,
      'filterType': filterType,
      'filterSize': filterSize,
      'bypass': bypass,
      'capacity': capacity,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory FilterRecommendation.fromJson(Map<String, dynamic> json) {
    return FilterRecommendation(
      tempHardness: json['tempHardness'] as int,
      totalHardness: json['totalHardness'] as int,
      cpd: json['cpd'] as int,
      filterType: json['filterType'] as String,
      filterSize: json['filterSize'] as String,
      bypass: json['bypass'] as String,
      capacity: json['capacity'] as int,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterRecommendation &&
        other.tempHardness == tempHardness &&
        other.totalHardness == totalHardness &&
        other.cpd == cpd &&
        other.filterType == filterType &&
        other.filterSize == filterSize &&
        other.bypass == bypass &&
        other.capacity == capacity &&
        other.createdAt == createdAt;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      tempHardness,
      totalHardness,
      cpd,
      filterType,
      filterSize,
      bypass,
      capacity,
      createdAt,
    );
  }
}
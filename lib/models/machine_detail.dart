class MachineDetail {
  final String machineId;
  final List<Specification> specifications;
  final List<MaintenanceProcedure> maintenanceProcedures;
  final List<TroubleshootingGuide> troubleshootingGuides;
  final List<PartDiagram> partDiagrams;

  MachineDetail({
    required this.machineId,
    required this.specifications,
    required this.maintenanceProcedures,
    required this.troubleshootingGuides,
    required this.partDiagrams,
  });

  // Factory method to create from JSON
  factory MachineDetail.fromJson(Map<String, dynamic> json) {
    return MachineDetail(
      machineId: json['machineId'],
      specifications: (json['specifications'] as List)
          .map((spec) => Specification.fromJson(spec))
          .toList(),
      maintenanceProcedures: (json['maintenanceProcedures'] as List)
          .map((proc) => MaintenanceProcedure.fromJson(proc))
          .toList(),
      troubleshootingGuides: (json['troubleshootingGuides'] as List)
          .map((guide) => TroubleshootingGuide.fromJson(guide))
          .toList(),
      partDiagrams: (json['partDiagrams'] as List)
          .map((diagram) => PartDiagram.fromJson(diagram))
          .toList(),
    );
  }
}

class Specification {
  final String category;
  final String name;
  final String value;
  final String? unit;

  Specification({
    required this.category,
    required this.name,
    required this.value,
    this.unit,
  });

  factory Specification.fromJson(Map<String, dynamic> json) {
    return Specification(
      category: json['category'],
      name: json['name'],
      value: json['value'],
      unit: json['unit'],
    );
  }
}

class MaintenanceProcedure {
  final String title;
  final String description;
  final String frequency;
  final List<MaintenanceStep> steps;

  MaintenanceProcedure({
    required this.title,
    required this.description,
    required this.frequency,
    required this.steps,
  });

  factory MaintenanceProcedure.fromJson(Map<String, dynamic> json) {
    return MaintenanceProcedure(
      title: json['title'],
      description: json['description'],
      frequency: json['frequency'],
      steps: (json['steps'] as List)
          .map((step) => MaintenanceStep.fromJson(step))
          .toList(),
    );
  }
}

class MaintenanceStep {
  final int order;
  final String instruction;
  final String? imagePath;

  MaintenanceStep({
    required this.order,
    required this.instruction,
    this.imagePath,
  });

  factory MaintenanceStep.fromJson(Map<String, dynamic> json) {
    return MaintenanceStep(
      order: json['order'],
      instruction: json['instruction'],
      imagePath: json['imagePath'],
    );
  }
}

class TroubleshootingGuide {
  final String issue;
  final String description;
  final List<TroubleshootingSolution> solutions;

  TroubleshootingGuide({
    required this.issue,
    required this.description,
    required this.solutions,
  });

  factory TroubleshootingGuide.fromJson(Map<String, dynamic> json) {
    return TroubleshootingGuide(
      issue: json['issue'],
      description: json['description'],
      solutions: (json['solutions'] as List)
          .map((solution) => TroubleshootingSolution.fromJson(solution))
          .toList(),
    );
  }
}

class TroubleshootingSolution {
  final int priority;
  final String solution;
  final List<String> steps;

  TroubleshootingSolution({
    required this.priority,
    required this.solution,
    required this.steps,
  });

  factory TroubleshootingSolution.fromJson(Map<String, dynamic> json) {
    return TroubleshootingSolution(
      priority: json['priority'],
      solution: json['solution'],
      steps: (json['steps'] as List).map((step) => step.toString()).toList(),
    );
  }
}

class PartDiagram {
  final String title;
  final String imagePath;
  final List<DiagramPart> parts;

  PartDiagram({
    required this.title,
    required this.imagePath,
    required this.parts,
  });

  factory PartDiagram.fromJson(Map<String, dynamic> json) {
    return PartDiagram(
      title: json['title'],
      imagePath: json['imagePath'],
      parts: (json['parts'] as List)
          .map((part) => DiagramPart.fromJson(part))
          .toList(),
    );
  }
}

class DiagramPart {
  final String partNumber;
  final String name;
  final String description;

  DiagramPart({
    required this.partNumber,
    required this.name,
    required this.description,
  });

  factory DiagramPart.fromJson(Map<String, dynamic> json) {
    return DiagramPart(
      partNumber: json['partNumber'],
      name: json['name'],
      description: json['description'],
    );
  }
}
class Machine {
  final String manufacturer;
  final String model;
  final String imagePath;
  final String? description;
  final String? documentPath;
  final String machineId;

  Machine({
    required this.manufacturer,
    required this.model,
    required this.imagePath,
    this.description,
    this.documentPath,
    String? machineId,
  }) : machineId = machineId ?? '${manufacturer.toLowerCase()}_${model.toLowerCase().replaceAll(' ', '')}';

  // Getter to provide a combined name for display purposes
  String get name => '$manufacturer\n$model';
}

// Get the list of machines from the original app
List<Machine> getMachines() {
  return [
    Machine(manufacturer: 'Schaerer', model: 'SCA', imagePath: 'assets/images/MK2.png'),
    Machine(manufacturer: 'Schaerer', model: 'SCB', imagePath: 'assets/images/MK3.png'),
    Machine(manufacturer: 'Schaerer', model: 'SCBBF', imagePath: 'assets/images/MK4.png'),
    Machine(manufacturer: 'Schaerer', model: 'SOUL S10', imagePath: 'assets/images/SOULS10.png'),
    Machine(manufacturer: 'Thermoplan', model: 'MARLOW', imagePath: 'assets/images/MARLOW.png'),
    Machine(manufacturer: 'Thermoplan', model: 'MARLOW 1.2', imagePath: 'assets/images/MARLOW12.png'),
  ];
}
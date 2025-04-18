// lib/riverpod/notifiers/machine_detail_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/machine.dart';
import '../../models/machine_detail.dart';
import '../../services/firebase_machine_service.dart';
import '../states/machine_detail_state.dart';

part 'machine_detail_notifier.g.dart';

@riverpod
class MachineDetailNotifier extends _$MachineDetailNotifier {
  late final FirebaseMachineService _machineService;

  @override
  MachineDetailState build(String machineId) {
    _machineService = FirebaseMachineService();
    _loadMachineDetails(machineId);
    return MachineDetailState.initial();
  }

  Future<void> _loadMachineDetails(String machineId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Try to fetch from Firestore first
      try {
        final details = await _machineService.getMachineDetails(machineId);
        
        if (details != null) {
          state = state.copyWith(machineDetail: details, isLoading: false);
          return;
        }
      } catch (firestoreError) {
        // Continue to fallback if Firestore fails
      }
      
      // Fallback to mock data
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Get the machine to generate mock data
      final machine = getMachines().firstWhere(
        (m) => m.machineId == machineId,
        orElse: () => Machine(
          manufacturer: 'Unknown',
          model: 'Model',
          imagePath: '',
          machineId: machineId,
        ),
      );
      
      // Generate mock data - in a real app, you'd load this from a service
      final mockDetail = _getMockMachineDetail(machine);
      
      state = state.copyWith(machineDetail: mockDetail, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: "Failed to load machine details: $e", isLoading: false);
    }
  }

  void refreshMachineDetails(String machineId) {
    _loadMachineDetails(machineId);
  }

  // Mock data generator - in a real app, this would come from a service or JSON file
  MachineDetail _getMockMachineDetail(Machine machine) {
    return MachineDetail(
      machineId: machine.machineId,
      specifications: [
        Specification(
          category: 'Dimensions',
          name: 'Height',
          value: '750',
          unit: 'mm',
        ),
        Specification(
          category: 'Dimensions',
          name: 'Width',
          value: '420',
          unit: 'mm',
        ),
        Specification(
          category: 'Dimensions',
          name: 'Depth',
          value: '580',
          unit: 'mm',
        ),
        Specification(
          category: 'Power',
          name: 'Voltage',
          value: '220-240',
          unit: 'V',
        ),
        Specification(
          category: 'Power',
          name: 'Frequency',
          value: '50/60',
          unit: 'Hz',
        ),
        Specification(
          category: 'Power',
          name: 'Power',
          value: '2900-3300',
          unit: 'W',
        ),
        Specification(
          category: 'Capacity',
          name: 'Bean Hopper',
          value: '1.1',
          unit: 'kg',
        ),
        Specification(
          category: 'Capacity',
          name: 'Water Tank',
          value: '4',
          unit: 'L',
        ),
        Specification(
          category: 'Performance',
          name: 'Daily Output',
          value: '250',
          unit: 'cups',
        ),
        Specification(
          category: 'Software',
          name: 'Firmware Version',
          value: '1.42.4',
          unit: '',
        ),
        Specification(
          category: 'Software',
          name: 'Drinks Database',
          value: '4.1',
          unit: '',
        ),
      ],
      maintenanceProcedures: [
        MaintenanceProcedure(
          title: 'Daily Cleaning',
          description: 'Essential daily cleaning to maintain hygiene and coffee quality',
          frequency: 'Daily',
          steps: [
            MaintenanceStep(
              order: 1,
              instruction: 'Turn off the machine and allow to cool for 15 minutes',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 2,
              instruction: 'Remove and empty the drip tray and grounds container',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 3,
              instruction: 'Wipe down all external surfaces with approved sanitizing solution',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 4,
              instruction: 'Clean the steam wand by running it for 2-3 seconds and wiping with a damp cloth',
              imagePath: null,
            ),
          ],
        ),
        MaintenanceProcedure(
          title: 'Weekly Cleaning Cycle',
          description: 'Deep cleaning for brew group and internal components',
          frequency: 'Weekly',
          steps: [
            MaintenanceStep(
              order: 1,
              instruction: 'Insert cleaning tablet into the ground coffee compartment',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 2,
              instruction: 'Navigate to maintenance menu and select "Cleaning Cycle"',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 3,
              instruction: 'Follow on-screen instructions and wait for cycle to complete (approx. 15 min)',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 4,
              instruction: 'Rinse brew group with clean water after completion',
              imagePath: null,
            ),
          ],
        ),
        MaintenanceProcedure(
          title: 'Monthly Maintenance',
          description: 'Preventative maintenance for optimal performance',
          frequency: 'Monthly',
          steps: [
            MaintenanceStep(
              order: 1,
              instruction: 'Remove and clean bean hopper thoroughly',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 2,
              instruction: 'Remove brew group, rinse under warm water, and lubricate moving parts',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 3,
              instruction: 'Check and clean water tank seals',
              imagePath: null,
            ),
            MaintenanceStep(
              order: 4,
              instruction: 'Inspect steam wand for blockages and clean thoroughly',
              imagePath: null,
            ),
          ],
        ),
      ],
      troubleshootingGuides: _generateTroubleshootingGuides(machine),
      partDiagrams: _generatePartDiagrams(machine),
    );
  }

  // Generate mock troubleshooting guides based on the machine type
  List<TroubleshootingGuide> _generateTroubleshootingGuides(Machine machine) {
    return [
      TroubleshootingGuide(
        issue: 'No Power / Machine Won\'t Turn On',
        description: 'Machine fails to power on when the power button is pressed',
        solutions: [
          TroubleshootingSolution(
            priority: 1,
            solution: 'Check power supply',
            steps: [
              'Ensure the machine is properly plugged into a working outlet',
              'Check if the power cord is damaged or loose',
              'Verify that the power switch is in the ON position',
              'Test the outlet with another device to confirm it has power'
            ],
          ),
          TroubleshootingSolution(
            priority: 2,
            solution: 'Check fuses',
            steps: [
              'Locate the fuse compartment (usually near the power inlet)',
              'Remove the fuse and check if it\'s blown',
              'Replace with an identical fuse if needed',
              'If fuse blows again immediately, contact technical support'
            ],
          ),
          TroubleshootingSolution(
            priority: 3,
            solution: 'Power board issues',
            steps: [
              'Disconnect machine from power',
              'Open service panel according to service manual',
              'Check for visual signs of damage on the power board',
              'Measure voltage at test points as specified in service manual',
              'Replace power board if faulty'
            ],
          ),
        ],
      ),
      TroubleshootingGuide(
        issue: 'Coffee Too Weak',
        description: 'Coffee produced is watery or lacks flavor and strength',
        solutions: [
          TroubleshootingSolution(
            priority: 1,
            solution: 'Adjust grind settings',
            steps: [
              'Check current grind setting - it may be too coarse',
              'Adjust to a finer grind (lower number) incrementally',
              'Make a test coffee after each adjustment',
              'Continue until desired strength is achieved'
            ],
          ),
          TroubleshootingSolution(
            priority: 2,
            solution: 'Check coffee settings',
            steps: [
              'Navigate to the coffee strength settings in the menu',
              'Increase the coffee dose setting',
              'Reduce water volume if applicable',
              'Save new settings and test'
            ],
          ),
          TroubleshootingSolution(
            priority: 3,
            solution: 'Clean the brew group',
            steps: [
              'Remove the brew group according to the manual',
              'Rinse thoroughly under warm water',
              'Remove any coffee residue from the screens and channels',
              'Allow to dry before reinstalling'
            ],
          ),
        ],
      ),
      TroubleshootingGuide(
        issue: 'Steam Wand Not Working',
        description: 'Little or no steam produced, or steam pressure is weak',
        solutions: [
          TroubleshootingSolution(
            priority: 1,
            solution: 'Clean steam wand',
            steps: [
              'Turn off the machine and let it cool down',
              'Remove the external steam wand tip',
              'Soak in descaler solution for 30 minutes',
              'Use the cleaning pin to clear any blockages in the small holes',
              'Rinse thoroughly and reattach'
            ],
          ),
          TroubleshootingSolution(
            priority: 2,
            solution: 'Check boiler temperature',
            steps: [
              'Enter service mode (refer to service manual for access)',
              'Navigate to diagnostic menu',
              'Check steam boiler temperature reading',
              'Verify it reaches 125-135°C during steam operation',
              'If temperature is low, check heating element and thermostat'
            ],
          ),
          TroubleshootingSolution(
            priority: 3,
            solution: 'Inspect solenoid valve',
            steps: [
              'Disconnect machine from power',
              'Access the steam system components',
              'Locate the steam solenoid valve',
              'Check for mechanical blockages or electrical issues',
              'Clean or replace as needed'
            ],
          ),
        ],
      ),
      TroubleshootingGuide(
        issue: 'Error Code E01: Temperature Sensor',
        description: 'Machine displays E01 error indicating temperature sensor failure',
        solutions: [
          TroubleshootingSolution(
            priority: 1,
            solution: 'Reset the machine',
            steps: [
              'Turn off the machine completely',
              'Disconnect from power for at least 30 seconds',
              'Reconnect and turn on the machine',
              'Check if error persists'
            ],
          ),
          TroubleshootingSolution(
            priority: 2,
            solution: 'Check sensor connections',
            steps: [
              'Disconnect machine from power',
              'Access the temperature sensor connections',
              'Check for loose connections or damaged wires',
              'Reconnect any loose wires and secure connections',
              'Test machine operation after reassembly'
            ],
          ),
          TroubleshootingSolution(
            priority: 3,
            solution: 'Replace temperature sensor',
            steps: [
              'Order the correct replacement sensor (part #TH-435)',
              'Follow service manual procedure for sensor replacement',
              'Calibrate new sensor using service menu if required',
              'Test machine operation after replacement'
            ],
          ),
        ],
      ),
    ];
  }

  // Generate mock part diagrams based on the machine type
  List<PartDiagram> _generatePartDiagrams(Machine machine) {
    return [
      PartDiagram(
        title: 'Brew Group Assembly',
        imagePath: 'assets/images/brewer.png', 
        parts: [
          DiagramPart(
            partNumber: 'BG-100',
            name: 'Brew Group Assembly',
            description: 'Complete brew group assembly with pistons, screens, and mounting brackets',
          ),
          DiagramPart(
            partNumber: 'BG-101',
            name: 'Upper Piston',
            description: 'Upper brewing piston with O-ring seals and guide pins',
          ),
          DiagramPart(
            partNumber: 'BG-102',
            name: 'Lower Piston',
            description: 'Lower brewing piston with water distribution screen and pressure chamber',
          ),
          DiagramPart(
            partNumber: 'BG-103',
            name: 'Brewing Chamber',
            description: 'Main brewing chamber with coffee inlet and water distribution channels',
          ),
          DiagramPart(
            partNumber: 'BG-104',
            name: 'Seal Kit',
            description: 'Complete set of O-rings and gaskets for brew group overhaul',
          ),
        ],
      ),
      PartDiagram(
        title: 'Steam System',
        imagePath: 'assets/images/boiler.png',
        parts: [
          DiagramPart(
            partNumber: 'ST-200',
            name: 'Steam Wand Assembly',
            description: 'Complete steam wand with pivot assembly and internal tubes',
          ),
          DiagramPart(
            partNumber: 'ST-201',
            name: 'Steam Tip',
            description: 'Replaceable steam wand tip with multiple steam holes',
          ),
          DiagramPart(
            partNumber: 'ST-202',
            name: 'Steam Valve',
            description: 'Main steam control valve with manual knob and seal assembly',
          ),
          DiagramPart(
            partNumber: 'ST-203',
            name: 'Steam Boiler',
            description: '1.5L stainless steel boiler with heating element and temperature probe',
          ),
          DiagramPart(
            partNumber: 'ST-204',
            name: 'Pressure Relief Valve',
            description: 'Safety pressure relief valve rated for 2.5 bar maximum pressure',
          ),
        ],
      ),
      PartDiagram(
        title: 'Grinder Assembly',
        imagePath: 'assets/images/grinder.png',
        parts: [
          DiagramPart(
            partNumber: '33.2016.1000',
            name: 'Antriebsmotor',
            description: 'Labor unit motor',
          ),
          DiagramPart(
            partNumber: '33.4038.1000',
            name: 'Set Mahlmesser 5500',
            description: 'Grinding disc set 5500',
          ),
          DiagramPart(
            partNumber: '062431',
            name: 'Motor 24V DC Mühle',
            description: 'Motor 24V DC grinder',
          ),
          DiagramPart(
            partNumber: '062437',
            name: 'Auslass Kaffeemehl 33',
            description: 'Ground coffee outlet 33',
          ),
          DiagramPart(
            partNumber: '066999',
            name: 'Steuerhebel MKB / SCB MK3',
            description: 'Fan 2 SCB MK3 control cable',
          ),
          DiagramPart(
            partNumber: '067275',
            name: 'Wellenlager Nacharbeit',
            description: 'Rework shaft bearing',
          ),
          DiagramPart(
            partNumber: '069071',
            name: 'Fingerschutz Mühle+Feder',
            description: 'Finger protection grinder+spring',
          ),
          DiagramPart(
            partNumber: '070432',
            name: 'Schneckenwelle Mühle',
            description: 'Grinder worm shaft',
          ),
          DiagramPart(
            partNumber: '070474',
            name: 'Mahlgradeinstellung 360°',
            description: 'Grinding degree setting ring 360°',
          ),
          DiagramPart(
            partNumber: '071002',
            name: 'DURCHFUEHRTUELLE MUEHLE',
            description: 'Grommet bushing, Grinder',
          ),
          DiagramPart(
            partNumber: '074111',
            name: 'Mühle 56 ET',
            description: 'Grinder 56',
          ),
          DiagramPart(
            partNumber: '074678',
            name: 'Axialluefter 60x60x25 24V DC+Mansch. 20',
            description: 'Axial fan 60x60x25 24V DC+sleeve. 20',
          ),
        ],
      ),
    ];
  }
}
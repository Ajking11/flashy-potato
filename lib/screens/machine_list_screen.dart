import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/machine.dart';
import '../providers/preferences_provider.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';
import 'machine_detail_screen.dart';

class MachineListScreen extends StatefulWidget {
  final VoidCallback onDashboardPressed;

  const MachineListScreen({super.key, required this.onDashboardPressed});

  @override
  State<MachineListScreen> createState() => _MachineListScreenState();
}

class _MachineListScreenState extends State<MachineListScreen> {
  late Future<List<Machine>> _machinesFuture;

  Future<List<Machine>> _fetchMachines() async {
    // Simulate a network delay if desired.
    await Future.delayed(const Duration(seconds: 1));
    return getMachines();
  }

  @override
  void initState() {
    super.initState();
    _machinesFuture = _fetchMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Machine Information',
          style: CostaTextStyle.appBarTitle,
        ),
        backgroundColor: costaRed,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onDashboardPressed,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Machine>>(
          future: _machinesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final machines = snapshot.data ?? [];
              return Container(
                color: latte,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    RepaintBoundary(
                      child: FadeAnimation(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Text(
                            'Select the machine to view its "Information & Configuration"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'CostaTextO',
                              color: deepRed,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: FadeAnimation(
                        delay: const Duration(milliseconds: 200),
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: machines.length,
                          itemBuilder: (context, index) {
                            final machine = machines[index];
                            return _buildMachineCard(context, machine);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMachineCard(BuildContext context, Machine machine) {
    return Consumer<PreferencesProvider>(
      builder: (context, prefsProvider, child) {
        // Use RepaintBoundary for the card which could rebuild when favorite status changes
        return RepaintBoundary(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MachineDetailScreen(machine: machine),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          machine.imagePath,
                          fit: BoxFit.contain,
                          // Use only cacheWidth to maintain aspect ratio
                          cacheWidth: 300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                machine.manufacturer,
                                style: CostaTextStyle.bodyText2.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                machine.model,
                                style: CostaTextStyle.subtitle2,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            prefsProvider.isMachineFavorite(machine.machineId)
                                ? Icons.star
                                : Icons.star_border,
                            color: prefsProvider.isMachineFavorite(machine.machineId)
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          onPressed: () {
                            prefsProvider.toggleFavoriteMachine(machine.machineId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
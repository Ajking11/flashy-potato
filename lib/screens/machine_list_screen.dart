import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/machine.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';
import '../services/image_service.dart';

class MachineListScreen extends ConsumerStatefulWidget {
  const MachineListScreen({super.key});

  @override
  ConsumerState<MachineListScreen> createState() => _MachineListScreenState();
}

class _MachineListScreenState extends ConsumerState<MachineListScreen> {
  late Future<List<Machine>> _machinesFuture;

  Future<List<Machine>> _fetchMachines() async {
    try {
      // Get machines from Firebase
      return await getMachinesFromFirestore();
    } catch (e) {
      // Fallback to local data if Firebase fails
      return getMachines();
    }
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
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Machine>>(
          future: _machinesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(costaRed),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline, 
                        color: costaRed,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unable to load machines',
                        style: CostaTextStyle.subtitle1.copyWith(
                          color: deepRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: CostaTextStyle.bodyText2.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _machinesFuture = _fetchMachines();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: costaRed,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.coffee, 
                        color: costaRed,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No machines available',
                        style: CostaTextStyle.subtitle1.copyWith(
                          color: deepRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check back later for updates',
                        textAlign: TextAlign.center,
                        style: CostaTextStyle.bodyText2.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _machinesFuture = _fetchMachines();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: costaRed,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
                                color: Colors.black.withAlpha((255 * 0.05).round()),
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

  // Helper method to build the machine image based on its path
  Widget _buildMachineImage(Machine machine) {
    assert(() {
      debugPrint('======== Machine Image Debug ========');
      debugPrint('Building image for ${machine.manufacturer} ${machine.model}');
      debugPrint('Image path type: ${machine.imagePath.runtimeType}');
      debugPrint('Image path value: ${machine.imagePath}');
      return true;
    }());
    
    // Use the ImageService to handle machine images
    return ImageService().loadMachineImage(
      imagePath: machine.imagePath,
      manufacturer: machine.manufacturer,
      model: machine.model,
      fit: BoxFit.contain,
      cacheWidth: 300,
    );
  }

  Widget _buildMachineCard(BuildContext context, Machine machine) {
    // Debug machine data in debug mode only
    assert(() {
      debugPrint('======== Machine Card Debug ========');
      debugPrint('Building card for machine: ${machine.manufacturer} ${machine.model}');
      debugPrint('Image path: ${machine.imagePath}');
      debugPrint('Image path type: ${machine.imagePath.runtimeType}');
      debugPrint('Machine ID: ${machine.machineId}');
      
      // Inspect the image path to identify any potential issues
      if (machine.imagePath != null) {
        if (machine.imagePath!.startsWith('gs://')) {
          debugPrint('WARNING: Firebase Storage path detected. These need to be converted to download URLs: ${machine.imagePath}');
        } else if (!machine.imagePath!.startsWith('http') && 
                  !machine.imagePath!.startsWith('https') &&
                  !machine.imagePath!.startsWith('assets/')) {
          debugPrint('WARNING: Invalid image path format: ${machine.imagePath}');
        }
      }
      debugPrint('====================================');
      return true;
    }());
    
    // Use RepaintBoundary for the card
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
            context.pushNamed('machine-detail', pathParameters: {'machineId': machine.machineId});
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: _buildMachineImage(machine),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
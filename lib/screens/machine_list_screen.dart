import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/machine.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';
import '../riverpod/providers/preferences_providers.dart';
import '../riverpod/notifiers/preferences_notifier.dart';

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

  // Helper method to build the machine image based on its path
  Widget _buildMachineImage(Machine machine) {
    assert(() {
      debugPrint('======== Machine Image Debug ========');
      debugPrint('Building image for ${machine.manufacturer} ${machine.model}');
      debugPrint('Image path type: ${machine.imagePath.runtimeType}');
      debugPrint('Image path value: ${machine.imagePath}');
      return true;
    }());
    
    // Special handling for Firebase Storage paths (gs://)
    if (machine.imagePath != null && machine.imagePath!.startsWith('gs://')) {
      assert(() {
        debugPrint('WARNING: Firebase Storage path detected. These need to be converted to HTTP URLs: ${machine.imagePath}');
        debugPrint('Using placeholder instead of Firebase Storage path');
        return true;
      }());
      // Use a placeholder for now
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 40,
              color: costaRed.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              'Storage URL',
              style: const TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
    
    // If imagePath is null or empty, show placeholder
    if (machine.imagePath == null || machine.imagePath!.isEmpty) {
      assert(() {
        debugPrint('Using placeholder for ${machine.manufacturer} ${machine.model}');
        return true;
      }());
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee_maker,
              size: 60,
              color: costaRed.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              '${machine.manufacturer}\n${machine.model}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: deepRed,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    // Try to load a network image if the path starts with http/https
    if (machine.imagePath != null && 
        (machine.imagePath!.startsWith('http') || machine.imagePath!.startsWith('https'))) {
      assert(() {
        debugPrint('==========================================');
        debugPrint('Loading NETWORK image for ${machine.manufacturer} ${machine.model}');
        debugPrint('URL: ${machine.imagePath}');
        debugPrint('==========================================');
        return true;
      }());
      
      // Assign to variable to prevent multiple access
      final imageUrl = machine.imagePath!;
      
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: AlwaysStoppedAnimation<Color>(costaRed),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          assert(() {
            debugPrint('Network image error: $error');
            return true;
          }());
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  'Network Image Error',
                  style: const TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    
    // If we have a path that doesn't start with http, try to load as asset
    if (machine.imagePath != null && machine.imagePath!.isNotEmpty) {
      assert(() {
        debugPrint('==========================================');
        debugPrint('Loading ASSET image for ${machine.manufacturer} ${machine.model}');
        debugPrint('Path: ${machine.imagePath}');
        debugPrint('==========================================');
        return true;
      }());
      
      // Assign to variable to prevent multiple access
      final assetPath = machine.imagePath!;
      
      return Image.asset(
        assetPath,
        fit: BoxFit.contain,
        // Use only cacheWidth to maintain aspect ratio
        cacheWidth: 300,
        errorBuilder: (context, error, stackTrace) {
          assert(() {
            debugPrint('Asset image error: $error');
            return true;
          }());
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  'Asset Not Found: ${machine.imagePath}',
                  style: const TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    
    // If we get here, use a generic placeholder with machine info
    assert(() {
      debugPrint('Using default placeholder for ${machine.manufacturer} ${machine.model}');
      return true;
    }());
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.coffee_maker,
            size: 60,
            color: costaRed.withOpacity(0.7),
          ),
          const SizedBox(height: 8),
          // Display the manufacturer and model
          const Text(
            machine.manufacturer,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: deepRed,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            machine.model,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
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
    
    final isFavorite = ref.watch(isMachineFavoriteProvider(machine.machineId));
    
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
                    IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.star
                            : Icons.star_border,
                        color: isFavorite
                            ? Colors.amber
                            : Colors.grey,
                      ),
                      onPressed: () {
                        ref.read(preferencesNotifierProvider.notifier)
                            .toggleFavoriteMachine(machine.machineId);
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
  }
}
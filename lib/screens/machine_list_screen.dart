import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/machine.dart';
import '../providers/preferences_provider.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';
import 'machine_detail_screen.dart';

class MachineListScreen extends StatelessWidget {
  const MachineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Background container with latte color
            Container(
              decoration: const BoxDecoration(
                color: latte,
              ),
            ),
            // Content
            Column(
              children: [
                // Header text with consistent typography
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FadeAnimation(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: cardDecoration,
                      child: Text(
                        'Select the machine to view the current "Information & Configuration"',
                        textAlign: TextAlign.center,
                        style: CostaTextStyle.subtitle2,
                      ),
                    ),
                  ),
                ),
                // Grid of machines
                Expanded(
                  child: FadeAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: _buildMachineGrid(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the AppBar with the Filter app styling
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Machine Information',
        textAlign: TextAlign.center,
        style: CostaTextStyle.appBarTitle,
      ),
      backgroundColor: costaRed,
      elevation: 0.0,
      centerTitle: true,
      leading: _buildAppBarIcon('assets/icons/cup.svg'),
      // No actions/help button
    );
  }

  // Build the cup icon in AppBar (consistent with Filter app)
  Widget _buildAppBarIcon(String assetPath) {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffF7F8F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        assetPath,
        height: 20,
        width: 20,
        semanticsLabel: 'Costa Coffee cup icon',
      ),
    );
  }

  // Build the grid of machines with Filter app styling
  Widget _buildMachineGrid(BuildContext context) {
    // Use same list of machines from original app
    final List<Machine> machines = getMachines();
    
    return Consumer<PreferencesProvider>(
      builder: (context, prefsProvider, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: machines.length,
          itemBuilder: (context, index) {
            final machine = machines[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
              child: InkWell(
                onTap: () {
                  // Navigate to machine details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MachineDetailScreen(machine: machine),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Favorite button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            prefsProvider.isMachineFavorite(machine.machineId)
                                ? Icons.star
                                : Icons.star_border,
                            color: prefsProvider.isMachineFavorite(machine.machineId)
                                ? Colors.amber
                                : Colors.grey,
                            size: 24,
                          ),
                          onPressed: () {
                            prefsProvider.toggleFavoriteMachine(machine.machineId);
                          },
                        ),
                      ),
                      // Machine image
                      Expanded(
                        child: Image.asset(
                          machine.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Machine manufacturer
                      Text(
                        machine.manufacturer,
                        textAlign: TextAlign.center,
                        style: CostaTextStyle.bodyText2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Machine model
                      Text(
                        machine.model,
                        textAlign: TextAlign.center,
                        style: CostaTextStyle.subtitle2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}
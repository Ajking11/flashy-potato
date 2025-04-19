// lib/screens/machine_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/machine.dart';
import '../constants.dart';
import '../widgets/specifications_tab.dart';
import '../widgets/maintenance_tab.dart';
import '../widgets/troubleshooting_tab.dart';
import '../widgets/parts_diagram_tab.dart';
import '../widgets/fade_animation.dart';
import '../riverpod/providers/machine_detail_providers.dart';
import '../riverpod/notifiers/machine_detail_notifier.dart';
import 'document_repository_screen.dart';

class MachineDetailScreen extends ConsumerStatefulWidget {
  final Machine machine;

  const MachineDetailScreen({
    super.key,
    required this.machine,
  });

  @override
  ConsumerState<MachineDetailScreen> createState() => _MachineDetailScreenState();
}

class _MachineDetailScreenState extends ConsumerState<MachineDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Changed to 5 to include Documents tab
    
    // Explicitly trigger loading of machine details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(machineDetailNotifierProvider(widget.machine.machineId).notifier)
         .refreshMachineDetails(widget.machine.machineId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.machine.manufacturer,
              style: CostaTextStyle.appBarTitle.copyWith(
                fontSize: 16, 
              ),
            ),
            Text(
              widget.machine.model,
              style: CostaTextStyle.appBarTitle,
            ),
          ],
        ),
        backgroundColor: costaRed,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: costaRed,
              unselectedLabelColor: Colors.grey,
              indicatorColor: costaRed,
              isScrollable: true,
              tabs: const [
                Tab(
                  icon: Icon(Icons.info_outline),
                  text: 'Specs',
                ),
                Tab(
                  icon: Icon(Icons.build_outlined),
                  text: 'Maintenance',
                ),
                Tab(
                  icon: Icon(Icons.help_outline),
                  text: 'Troubleshoot',
                ),
                Tab(
                  icon: Icon(Icons.view_module_outlined),
                  text: 'Parts',
                ),
                Tab(
                  icon: Icon(Icons.folder_outlined),
                  text: 'Documents',
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final isLoading = ref.watch(isMachineDetailLoadingProvider(widget.machine.machineId));
    final error = ref.watch(machineDetailErrorProvider(widget.machine.machineId));
    final machineDetail = ref.watch(machineDetailProvider(widget.machine.machineId));

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(costaRed),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: accentRed,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                error,
                style: CostaTextStyle.subtitle2.copyWith(color: accentRed),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Refresh the data
                  ref.read(machineDetailNotifierProvider(widget.machine.machineId).notifier)
                     .refreshMachineDetails(widget.machine.machineId);
                },
                style: primaryButtonStyle,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (machineDetail == null) {
      // If we reach here, create a simple placeholder detail
      // This should rarely happen since we now have better fallback to mock data
      assert(() {
        debugPrint("No machine details found, creating simple placeholder tabs");
        return true;
      }());
      return Container(
        color: latte,
        child: TabBarView(
          controller: _tabController,
          children: [
            // Specifications Tab - Placeholder
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Specifications will be available soon',
                      style: TextStyle(fontSize: 16, color: deepRed),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // Maintenance Tab - Placeholder
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.build_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Maintenance procedures will be available soon',
                      style: TextStyle(fontSize: 16, color: deepRed),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // Troubleshooting Tab - Placeholder
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Troubleshooting guides will be available soon',
                      style: TextStyle(fontSize: 16, color: deepRed),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // Parts Tab - Placeholder
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_module_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Parts diagrams will be available soon',
                      style: TextStyle(fontSize: 16, color: deepRed),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // Documents Tab - This should work even without machine details
            FadeAnimation(
              child: DocumentRepositoryScreen(initialMachineId: widget.machine.machineId),
            ),
          ],
        ),
      );
    }

    return Container(
      color: latte,
      child: TabBarView(
        controller: _tabController,
        children: [
          // Specifications Tab
          FadeAnimation(
            child: SpecificationsTab(specifications: machineDetail.specifications),
          ),
          
          // Maintenance Tab
          FadeAnimation(
            child: MaintenanceTab(procedures: machineDetail.maintenanceProcedures),
          ),
          
          // Troubleshooting Tab
          FadeAnimation(
            child: TroubleshootingTab(guides: machineDetail.troubleshootingGuides),
          ),
          
          // Parts Diagram Tab
          FadeAnimation(
            child: PartsDiagramTab(diagrams: machineDetail.partDiagrams),
          ),
          
          // Documents Tab
          FadeAnimation(
            child: DocumentRepositoryScreen(initialMachineId: widget.machine.machineId),
          ),
        ],
      ),
    );
  }

  // All mock data has been moved to the MachineDetailNotifier class
}
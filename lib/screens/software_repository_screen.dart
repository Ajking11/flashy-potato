import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/software.dart';
import '../models/machine.dart';
import '../riverpod/notifiers/software_notifier.dart';
import '../riverpod/providers/software_providers.dart';
import '../riverpod/providers/machine_providers.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';

class SoftwareRepositoryScreen extends ConsumerStatefulWidget {
  final String? initialMachineId; // Optional: to pre-filter by machine

  const SoftwareRepositoryScreen({
    super.key,
    this.initialMachineId,
  });

  @override
  ConsumerState<SoftwareRepositoryScreen> createState() => _SoftwareRepositoryScreenState();
}

class _SoftwareRepositoryScreenState extends ConsumerState<SoftwareRepositoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showOnlyDownloaded = false;
  
  @override
  void initState() {
    super.initState();
    // If initial machine ID is provided, apply the filter
    if (widget.initialMachineId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(softwareNotifierProvider.notifier)
            .filterByMachine(widget.initialMachineId);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If we're on a tab, don't show the AppBar
    final bool showAppBar = widget.initialMachineId == null;
    
    return showAppBar
        ? Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Text(
                    'Software Repository',
                    style: CostaTextStyle.appBarTitle,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Firebase',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: costaRed,
              elevation: 0,
              centerTitle: false,
              actions: [
                // Toggle for offline software
                IconButton(
                  icon: Icon(
                    _showOnlyDownloaded 
                      ? Icons.download_for_offline
                      : Icons.download_for_offline_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Show offline software only',
                  onPressed: () {
                    setState(() {
                      _showOnlyDownloaded = !_showOnlyDownloaded;
                    });
                  },
                ),
              ],
            ),
            body: _buildContent(),
          )
        : _buildContent();
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Search and filter bar
        _buildSearchBar(),
        
        // Software list
        Expanded(
          child: _buildSoftwareList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final selectedMachineId = ref.watch(softwareSelectedMachineIdProvider);
    final selectedCategory = ref.watch(softwareSelectedCategoryProvider);
    final hasFilters = selectedMachineId != null || selectedCategory != null;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: latte,
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              decoration: cardDecoration,
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search software...',
                  prefixIcon: const Icon(Icons.search, color: costaRed),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(softwareNotifierProvider.notifier)
                                .setSearchQuery('');
                            _searchFocusNode.unfocus();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                onChanged: (value) {
                  ref.read(softwareNotifierProvider.notifier)
                      .setSearchQuery(value);
                },
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Filter button
          Container(
            decoration: BoxDecoration(
              color: hasFilters ? costaRed : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasFilters ? costaRed : Colors.grey.shade300,
                width: hasFilters ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showFilterBottomSheet(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.tune,
                        color: hasFilters ? Colors.white : costaRed,
                        size: 24,
                      ),
                      if (hasFilters)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${(selectedMachineId != null ? 1 : 0) + (selectedCategory != null ? 1 : 0)}',
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: costaRed,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Comprehensive filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final selectedMachineId = ref.watch(softwareSelectedMachineIdProvider);
          final selectedCategory = ref.watch(softwareSelectedCategoryProvider);
          final filteredSoftwareList = ref.watch(filteredSoftwareListProvider);
          final allSoftwareList = ref.watch(softwareListProvider);
          final hasFilters = selectedMachineId != null || selectedCategory != null;
          
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.tune, color: costaRed, size: 24),
                        const SizedBox(width: 12),
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: deepRed,
                          ),
                        ),
                        const Spacer(),
                        if (hasFilters)
                          TextButton.icon(
                            onPressed: () {
                              ref.read(softwareNotifierProvider.notifier).clearFilters();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Clear All'),
                            style: TextButton.styleFrom(
                              foregroundColor: costaRed,
                            ),
                          ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  
                  // Result count
                  if (hasFilters)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${filteredSoftwareList.length} of ${allSoftwareList.length} software items match your filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Filter options
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Machine filter section
                          if (widget.initialMachineId == null) ...[
                            const SizedBox(height: 8),
                            _buildFilterSection(
                              title: 'Machine',
                              icon: Icons.devices,
                              currentValue: selectedMachineId != null 
                                ? _getShortMachineName(selectedMachineId) 
                                : null,
                              onTap: () => _showMachineFilterSheet(context),
                              onClear: selectedMachineId != null 
                                ? () => ref.read(softwareNotifierProvider.notifier).filterByMachine(null)
                                : null,
                            ),
                          ],
                          
                          // Category filter section
                          const SizedBox(height: 16),
                          _buildFilterSection(
                            title: 'Category',
                            icon: Icons.category,
                            currentValue: selectedCategory,
                            onTap: () => _showCategoryFilterSheet(context),
                            onClear: selectedCategory != null 
                              ? () => ref.read(softwareNotifierProvider.notifier).filterByCategory(null)
                              : null,
                          ),
                          
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Helper method to build filter sections in bottom sheet
  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    String? currentValue,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final isActive = currentValue != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive 
                  ? costaRed.withValues(alpha: 0.05) 
                  : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive 
                    ? costaRed.withValues(alpha: 0.3) 
                    : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isActive ? costaRed : Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentValue ?? 'All',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? costaRed : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (onClear != null) ...[
                    IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.close, color: costaRed),
                      iconSize: 20,
                      visualDensity: VisualDensity.compact,
                    ),
                  ] else ...[
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Show bottom sheet for machine filter selection
  void _showMachineFilterSheet(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true, // Makes the sheet taller
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sheet handle for better UX
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Sheet header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.devices, color: costaRed),
                      const SizedBox(width: 8),
                      const Text(
                        'Select Machine',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: deepRed,
                        ),
                      ),
                      const Spacer(),
                      // Reset button if a filter is selected
                      Consumer(
                        builder: (context, ref, _) {
                          final selectedMachineId = ref.watch(softwareSelectedMachineIdProvider);
                          if (selectedMachineId != null) {
                            return TextButton.icon(
                              onPressed: () {
                                ref.read(softwareNotifierProvider.notifier).filterByMachine(null);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.restart_alt, size: 16),
                              label: const Text('Reset'),
                              style: TextButton.styleFrom(
                                foregroundColor: costaRed,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // All machines option
                Consumer(
                  builder: (context, ref, _) {
                    final selectedMachineId = ref.watch(softwareSelectedMachineIdProvider);
                    return ListTile(
                      leading: const Icon(
                        Icons.device_hub,
                        color: costaRed,
                      ),
                      title: const Text('All Machines'),
                      selected: selectedMachineId == null,
                      selectedTileColor: costaRed.withValues(alpha: 0.1),
                      selectedColor: costaRed,
                      onTap: () {
                        ref.read(softwareNotifierProvider.notifier).filterByMachine(null);
                        Navigator.pop(context);
                      },
                    );
                  }
                ),
                
                // Machine list
                Flexible(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final machines = ref.watch(displayableMachinesProvider);
                      final selectedMachineId = ref.watch(softwareSelectedMachineIdProvider);
                      
                      // Debug logging
                      debugPrint('Software machine filter sheet - machines count: ${machines.length}');
                      for (var machine in machines) {
                        debugPrint('Machine: ${machine.manufacturer} ${machine.model} - displayInApp: ${machine.displayInApp}');
                      }
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: machines.length,
                        itemBuilder: (context, index) {
                          final machine = machines[index];
                          final isSelected = selectedMachineId == machine.machineId;
                          
                          return ListTile(
                            leading: isSelected
                              ? const Icon(Icons.check_circle, color: costaRed)
                              : const Icon(Icons.coffee, color: Colors.brown),
                            title: Text('${machine.manufacturer} ${machine.model}'),
                            selected: isSelected,
                            selectedTileColor: costaRed.withValues(alpha: 0.1),
                            selectedColor: costaRed,
                            onTap: () {
                              ref.read(softwareNotifierProvider.notifier).filterByMachine(machine.machineId);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show bottom sheet for category filter selection
  void _showCategoryFilterSheet(BuildContext context) {
    final categories = SoftwareCategory.getAllCategories();
    final selectedCategory = ref.read(softwareSelectedCategoryProvider);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true, // Makes the sheet taller
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sheet handle for better UX
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Sheet header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.category, color: costaRed),
                      const SizedBox(width: 8),
                      const Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: deepRed,
                        ),
                      ),
                      const Spacer(),
                      // Reset button if a filter is selected
                      if (selectedCategory != null)
                        TextButton.icon(
                          onPressed: () {
                            ref.read(softwareNotifierProvider.notifier).filterByCategory(null);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.restart_alt, size: 16),
                          label: const Text('Reset'),
                          style: TextButton.styleFrom(
                            foregroundColor: costaRed,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // All categories option
                ListTile(
                  leading: const Icon(
                    Icons.category,
                    color: costaRed,
                  ),
                  title: const Text('All Categories'),
                  selected: selectedCategory == null,
                  selectedTileColor: costaRed.withValues(alpha: 0.1),
                  selectedColor: costaRed,
                  onTap: () {
                    ref.read(softwareNotifierProvider.notifier).filterByCategory(null);
                    Navigator.pop(context);
                  },
                ),
                
                // Category list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category;
                      
                      return ListTile(
                        leading: Icon(
                          _getCategoryIcon(category),
                          color: isSelected ? costaRed : _getCategoryColor(category),
                        ),
                        title: Text(category),
                        selected: isSelected,
                        selectedTileColor: costaRed.withValues(alpha: 0.1),
                        selectedColor: costaRed,
                        onTap: () {
                          ref.read(softwareNotifierProvider.notifier).filterByCategory(category);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSoftwareList() {
    final isLoading = ref.watch(isSoftwareLoadingProvider);
    final filteredSoftwareList = ref.watch(filteredSoftwareListProvider);
    
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(costaRed),
        ),
      );
    }

    var softwareList = filteredSoftwareList;
    
    // Apply offline filter if needed
    if (_showOnlyDownloaded) {
      softwareList = softwareList.where((sw) => sw.isDownloaded).toList();
    }

    if (softwareList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_sim,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No software found',
              style: CostaTextStyle.subtitle1.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing your search or filters',
              style: CostaTextStyle.bodyText1.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            // Refresh button
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(softwareNotifierProvider.notifier).refreshSoftware();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Software'),
              style: ElevatedButton.styleFrom(
                backgroundColor: costaRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    
    // Pre-build list items for better performance and to avoid scroll issues
    final List<Widget> listItems = [];
    
    // Add Firebase indicator as first item
    listItems.add(
      Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud, color: Colors.blue, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Software from Firebase',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Pull to refresh',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      )
    );
    
    // Add software cards
    for (int i = 0; i < softwareList.length; i++) {
      final software = softwareList[i];
      listItems.add(
        FadeAnimation(
          delay: Duration(milliseconds: 50 * i),
          child: _buildSoftwareCard(software),
        )
      );
    }

    // Use RefreshIndicator for pull-to-refresh functionality
    return RefreshIndicator(
      onRefresh: () => ref.read(softwareNotifierProvider.notifier).refreshSoftware(),
      color: costaRed,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listItems.length,
        itemBuilder: (context, index) => listItems[index],
        // Adding physics parameters to help with scroll issues
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildSoftwareCard(Software software) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (software.isDownloaded) {
            // If downloaded, navigate to viewer or installer
            _openSoftware(software);
          } else {
            // If not downloaded, show download prompt
            _showDownloadPrompt(software);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Software header with category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getCategoryColor(software.category).withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(software.category),
                    color: _getCategoryColor(software.category),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    software.category,
                    style: CostaTextStyle.bodyText2.copyWith(
                      color: _getCategoryColor(software.category),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (software.isDownloaded)
                    const Icon(
                      Icons.offline_pin,
                      color: Colors.green,
                      size: 20,
                    ),
                ],
              ),
            ),
            
            // Software content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and version
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          software.name,
                          style: CostaTextStyle.subtitle1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: costaRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: costaRed.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'v${software.version}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: costaRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    software.description,
                    style: CostaTextStyle.bodyText1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Machine compatibility
                  if (software.machineIds.isNotEmpty || software.concession.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...software.machineIds.map((machineId) => _buildMachineChip(machineId)),
                        ...software.concession.map((machineId) => _buildMachineChip(machineId)),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  // Software details
                  Row(
                    children: [
                      // File size
                      Icon(
                        Icons.sd_storage_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${software.fileSizeKB} KB',
                        style: CostaTextStyle.caption,
                      ),
                      const SizedBox(width: 16),
                      
                      // Upload date
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(software.uploadDate),
                        style: CostaTextStyle.caption,
                      ),
                      
                      // Download count
                      if (software.downloadCount > 0) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.download_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${software.downloadCount}',
                          style: CostaTextStyle.caption,
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // Download button
                      _buildDownloadButton(software),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineChip(String machineId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        _getShortMachineName(machineId),
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildDownloadButton(Software software) {
    return Consumer(
      builder: (context, ref, _) {
        final downloadProgress = ref.watch(softwareDownloadProgressProvider(software.id));
        final isDownloading = downloadProgress > 0;
        
        // Use AnimatedSwitcher for smooth transitions between button states
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: _buildDownloadButtonState(software, isDownloading, downloadProgress, ref),
        );
      }
    );
  }
  
  // Helper to build the appropriate button state
  Widget _buildDownloadButtonState(Software software, bool isDownloading, double downloadProgress, WidgetRef ref) {
    // If software is downloaded, show remove button
    if (software.isDownloaded) {
      return TextButton.icon(
        key: const ValueKey('remove_button'),
        onPressed: () {
          ref.read(softwareNotifierProvider.notifier)
              .removeDownload(software.id);
        },
        icon: const Icon(Icons.delete_outline, size: 16),
        label: const Text('Remove'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          padding: EdgeInsets.zero,
          minimumSize: const Size(80, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    } 
    // If software is currently downloading, show progress
    else if (isDownloading) {
      return SizedBox(
        key: const ValueKey('progress_indicator'),
        width: 80,
        height: 30, // Match height of buttons for smooth transition
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress indicator
            SizedBox(
              width: 80,
              height: 4,
              child: LinearProgressIndicator(
                value: downloadProgress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(costaRed),
              ),
            ),
            const SizedBox(height: 4),
            // Progress text
            Text(
              '${(downloadProgress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    } 
    // If software is not downloaded and not downloading, show download button
    else {
      return TextButton.icon(
        key: const ValueKey('download_button'),
        onPressed: () {
          // Start download
          ref.read(softwareNotifierProvider.notifier)
              .downloadSoftware(software.id);
        },
        icon: const Icon(Icons.download_outlined, size: 16),
        label: const Text('Download'),
        style: TextButton.styleFrom(
          foregroundColor: costaRed,
          padding: EdgeInsets.zero,
          minimumSize: const Size(80, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
  }
  

  // Get a shorter version of machine name
  String _getShortMachineName(String machineId) {
    final machines = ref.read(displayableMachinesProvider);
    final machine = machines.firstWhere(
      (m) => m.machineId == machineId,
      orElse: () => Machine(
        manufacturer: '',
        model: machineId,
        imagePath: '',
      ),
    );
    
    // Just return the model to save space
    return machine.model.isNotEmpty ? machine.model : machineId;
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  // Show prompt to download software before using
  void _showDownloadPrompt(Software software) {
    // Method to start the download (to be called from the dialog)
    Future<void> startDownload() async {
      try {
        // Cache values for use in closures
        final String softwareId = software.id;
        
        // Start download with throttled progress updates (implemented in the notifier)
        await ref.read(softwareNotifierProvider.notifier)
            .downloadSoftware(softwareId);
            
        // Short delay to ensure file is completely saved
        await Future.delayed(const Duration(milliseconds: 300));
        
        if (!mounted) return;
            
        // Check if software is now available
        final sw = ref.read(softwareNotifierProvider.notifier)
            .getSoftwareById(softwareId);
            
        if (sw != null && sw.isDownloaded) {
          // Add a small delay before opening for a smoother transition
          await Future.delayed(const Duration(milliseconds: 200));
          if (!mounted) return;
          _openSoftware(sw);
        } else {
          _showErrorSnackBar('Software download completed but file is not accessible. Please try again.');
        }
      } catch (error) {
        if (!mounted) return;
        _showErrorSnackBar('Failed to download: $error');
      }
    }
    
    // Show the download prompt dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Download Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The software "${software.name}" needs to be downloaded before use.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Size: ${software.fileSizeKB} KB',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Close dialog with a smoother animation
              Navigator.pop(dialogContext);
              
              // Small delay before starting download to allow dialog to close smoothly
              Future.delayed(const Duration(milliseconds: 100), () {
                // Start download
                startDownload();
              });
            },
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: costaRed,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // This has been removed in favor of showing the password in the details view

  // Open/handle the software
  void _openSoftware(Software software) {
    try {
      // Navigate using GoRouter
      context.go('/software/${software.id}');
    } catch (e) {
      // Handle any exceptions safely to prevent crashes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open software: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // This method has been removed in favor of SoftwareDetailScreen

  // Helper method to get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case SoftwareCategory.firmware:
        return Colors.blue;
      case SoftwareCategory.utility:
        return Colors.green;
      case SoftwareCategory.diagnostic:
        return Colors.orange;
      case SoftwareCategory.driver:
        return Colors.purple;
      case SoftwareCategory.calibration:
        return Colors.teal;
      case SoftwareCategory.update:
        return costaRed;
      case SoftwareCategory.configuration:
        return Colors.amber;
      case SoftwareCategory.promo:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get category icon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case SoftwareCategory.firmware:
        return Icons.memory;
      case SoftwareCategory.utility:
        return Icons.handyman;
      case SoftwareCategory.diagnostic:
        return Icons.build;
      case SoftwareCategory.driver:
        return Icons.developer_board;
      case SoftwareCategory.calibration:
        return Icons.tune;
      case SoftwareCategory.update:
        return Icons.system_update;
      case SoftwareCategory.configuration:
        return Icons.settings;
      case SoftwareCategory.promo:
        return Icons.local_offer;
      default:
        return Icons.code;
    }
  }
}
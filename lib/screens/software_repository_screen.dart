import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/software.dart';
import '../models/machine.dart';
import '../providers/software_provider.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';
import 'software_detail_screen.dart';

class SoftwareRepositoryScreen extends StatefulWidget {
  final String? initialMachineId; // Optional: to pre-filter by machine

  const SoftwareRepositoryScreen({
    super.key,
    this.initialMachineId,
  });

  @override
  State<SoftwareRepositoryScreen> createState() => _SoftwareRepositoryScreenState();
}

class _SoftwareRepositoryScreenState extends State<SoftwareRepositoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showOnlyDownloaded = false;
  
  @override
  void initState() {
    super.initState();
    // If initial machine ID is provided, apply the filter
    if (widget.initialMachineId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SoftwareProvider>(context, listen: false)
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
                      color: Colors.white.withOpacity(0.2),
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
        
        // Filter chips
        _buildFilterChips(),
        
        // Software list
        Expanded(
          child: _buildSoftwareList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: latte,
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
                      Provider.of<SoftwareProvider>(context, listen: false)
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
            Provider.of<SoftwareProvider>(context, listen: false)
                .setSearchQuery(value);
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<SoftwareProvider>(
      builder: (context, softwareProvider, child) {
        final selectedMachineId = softwareProvider.selectedMachineId;
        final selectedCategory = softwareProvider.selectedCategory;
        final hasFilters = selectedMachineId != null || selectedCategory != null;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: latte,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter buttons row - connected with square inner edges
              Row(
                children: [
                  // Connected filter buttons taking full width
                  Expanded(
                    child: Row(
                      children: [
                        // Machine filter dropdown - only show if not pre-filtered
                        if (widget.initialMachineId == null)
                          Expanded(
                            flex: 1,
                            child: _buildFilterDropdown(
                              label: 'Machines',  // Shortened label
                              value: selectedMachineId == null 
                                ? 'All' 
                                : _getShortMachineName(selectedMachineId),
                              icon: Icons.devices,
                              onTap: () => _showMachineFilterSheet(context, softwareProvider),
                              isActive: selectedMachineId != null,
                              isLeftButton: true,
                            ),
                          ),
                        
                        // Category filter dropdown
                        Expanded(
                          flex: 1,
                          child: _buildFilterDropdown(
                            label: 'Categories',  // Shortened label
                            value: selectedCategory ?? 'All',
                            icon: Icons.category,
                            onTap: () => _showCategoryFilterSheet(context, softwareProvider),
                            isActive: selectedCategory != null,
                            isRightButton: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Active filters display
              if (hasFilters) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (selectedMachineId != null)
                      _buildActiveFilterChip(
                        _getMachineName(selectedMachineId),
                        Icons.devices,
                        () => softwareProvider.filterByMachine(null),
                      ),
                    if (selectedCategory != null)
                      _buildActiveFilterChip(
                        selectedCategory,
                        _getCategoryIcon(selectedCategory),
                        () => softwareProvider.filterByCategory(null),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // Helper method to build a styled filter dropdown button with label and value
  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
    bool isLeftButton = false,
    bool isRightButton = false,
  }) {
    // Create a BorderRadius that is square on one side
    BorderRadius borderRadius;
    if (isLeftButton) {
      // Left button - rounded on left, square on right
      borderRadius = const BorderRadius.horizontal(
        left: Radius.circular(25),
        right: Radius.zero,
      );
    } else if (isRightButton) {
      // Right button - square on left, rounded on right
      borderRadius = const BorderRadius.horizontal(
        left: Radius.zero,
        right: Radius.circular(25),
      );
    } else {
      // Default - fully rounded
      borderRadius = BorderRadius.circular(25);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? costaRed.withValues(alpha: 0.1) : Colors.white,
            borderRadius: borderRadius,
            border: Border.all(
              color: isActive ? costaRed : Colors.grey.shade300,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? costaRed : Colors.grey.shade700,
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label at top (smaller)
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 10,
                    ),
                  ),
                  // Value below (more prominent)
                  Text(
                    value,
                    style: TextStyle(
                      color: isActive ? costaRed : Colors.grey.shade800,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.arrow_drop_down,
                color: isActive ? costaRed : Colors.grey.shade700,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build an active filter chip
  Widget _buildActiveFilterChip(String label, IconData icon, VoidCallback onRemove) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: costaRed,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      avatar: Icon(
        icon,
        size: 16,
        color: costaRed,
      ),
      deleteIcon: const Icon(
        Icons.close,
        size: 16,
        color: costaRed,
      ),
      onDeleted: onRemove,
      backgroundColor: costaRed.withValues(alpha: 0.1),
      side: const BorderSide(color: costaRed),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  // Show bottom sheet for machine filter selection
  void _showMachineFilterSheet(
    BuildContext context,
    SoftwareProvider softwareProvider,
  ) {
    final machines = getMachines();
    
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
                      if (softwareProvider.selectedMachineId != null)
                        TextButton.icon(
                          onPressed: () {
                            softwareProvider.filterByMachine(null);
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
                
                // All machines option
                ListTile(
                  leading: const Icon(
                    Icons.device_hub,
                    color: costaRed,
                  ),
                  title: const Text('All Machines'),
                  selected: softwareProvider.selectedMachineId == null,
                  selectedTileColor: costaRed.withValues(alpha: 0.1),
                  selectedColor: costaRed,
                  onTap: () {
                    softwareProvider.filterByMachine(null);
                    Navigator.pop(context);
                  },
                ),
                
                // Machine list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: machines.length,
                    itemBuilder: (context, index) {
                      final machine = machines[index];
                      final isSelected = softwareProvider.selectedMachineId == machine.machineId;
                      
                      return ListTile(
                        leading: isSelected
                          ? const Icon(Icons.check_circle, color: costaRed)
                          : const Icon(Icons.coffee, color: Colors.brown),
                        title: Text('${machine.manufacturer} ${machine.model}'),
                        selected: isSelected,
                        selectedTileColor: costaRed.withValues(alpha: 0.1),
                        selectedColor: costaRed,
                        onTap: () {
                          softwareProvider.filterByMachine(machine.machineId);
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

  // Show bottom sheet for category filter selection
  void _showCategoryFilterSheet(
    BuildContext context,
    SoftwareProvider softwareProvider,
  ) {
    final categories = SoftwareCategory.getAllCategories();
    
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
                      if (softwareProvider.selectedCategory != null)
                        TextButton.icon(
                          onPressed: () {
                            softwareProvider.filterByCategory(null);
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
                  selected: softwareProvider.selectedCategory == null,
                  selectedTileColor: costaRed.withValues(alpha: 0.1),
                  selectedColor: costaRed,
                  onTap: () {
                    softwareProvider.filterByCategory(null);
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
                      final isSelected = softwareProvider.selectedCategory == category;
                      
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
                          softwareProvider.filterByCategory(category);
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
    return Consumer<SoftwareProvider>(
      builder: (context, softwareProvider, child) {
        if (softwareProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(costaRed),
            ),
          );
        }

        var softwareList = softwareProvider.filteredSoftwareList;
        
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
                    softwareProvider.refreshSoftware();
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

        // Use RefreshIndicator for pull-to-refresh functionality
        return RefreshIndicator(
          onRefresh: () => softwareProvider.refreshSoftware(),
          color: costaRed,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: softwareList.length + 1, // Add one for the Firebase indicator
            itemBuilder: (context, index) {
              // First item is the Firebase indicator
              if (index == 0) {
                return Container(
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
                );
              }
              
              // Adjust index to account for the Firebase indicator
              final swIndex = index - 1;
              final software = softwareList[swIndex];
              
              return FadeAnimation(
                delay: Duration(milliseconds: 50 * swIndex),
                child: _buildSoftwareCard(software),
              );
            },
          ),
        );
      },
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
                        _formatDate(software.releaseDate),
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
    final softwareProvider = Provider.of<SoftwareProvider>(context, listen: true);
    final isDownloading = softwareProvider.isDownloading(software.id);
    final downloadProgress = softwareProvider.getDownloadProgress(software.id);
    
    // If software is downloaded, show remove button
    if (software.isDownloaded) {
      return TextButton.icon(
        onPressed: () {
          Provider.of<SoftwareProvider>(context, listen: false)
              .removeDownload(software.id);
        },
        icon: const Icon(Icons.delete_outline, size: 16),
        label: const Text('Remove'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    } 
    // If software is currently downloading, show progress
    else if (isDownloading) {
      return Column(
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
      );
    } 
    // If software is not downloaded and not downloading, show download button
    else {
      return TextButton.icon(
        onPressed: () {
          // Start download
          Provider.of<SoftwareProvider>(context, listen: false)
              .downloadSoftware(software.id);
        },
        icon: const Icon(Icons.download_outlined, size: 16),
        label: const Text('Download'),
        style: TextButton.styleFrom(
          foregroundColor: costaRed,
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
  }
  
  // Helper method to get machine name from ID
  String _getMachineName(String machineId) {
    final machines = getMachines();
    final machine = machines.firstWhere(
      (m) => m.machineId == machineId,
      orElse: () => Machine(
        manufacturer: 'Unknown',
        model: machineId,
        imagePath: '',
      ),
    );
    
    return '${machine.manufacturer} ${machine.model}';
  }

  // Get a shorter version of machine name
  String _getShortMachineName(String machineId) {
    final machines = getMachines();
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Close dialog
              Navigator.pop(context);
              // Start download
              Provider.of<SoftwareProvider>(context, listen: false)
                  .downloadSoftware(software.id)
                  .then((_) async {
                // Add a small delay to ensure file is completely written to disk
                await Future.delayed(const Duration(milliseconds: 500));
                
                // After download completes, verify file exists before using
                final swProvider = Provider.of<SoftwareProvider>(context, listen: false);
                final sw = swProvider.getSoftwareById(software.id);
                
                if (sw != null && sw.isDownloaded && mounted) {
                  _openSoftware(sw);
                } else {
                  // Show error if software isn't available after download
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Software download completed but file is not accessible. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }).catchError((error) {
                // Show error message if download fails
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to download: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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

  // This has been removed in favor of showing the password in the details view

  // Open/handle the software
  void _openSoftware(Software software) {
    try {
      // Instead of showing a dialog, navigate to a full-screen page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SoftwareDetailScreen(software: software),
        ),
      );
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
  
  // No longer used - replaced by SoftwareDetailScreen
  void _unusedShowSoftwareDetailsDialog(Software software) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getCategoryIcon(software.category), color: _getCategoryColor(software.category)),
            const SizedBox(width: 8),
            Expanded(child: Text(software.name, style: CostaTextStyle.subtitle1)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Version badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: costaRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: costaRed.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Version ${software.version}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: costaRed,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Description
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(software.description),
              const SizedBox(height: 16),
              
              // Installation Password (if available)
              if (software.password != null && software.password!.isNotEmpty) ...[
                const Text('Machine Password:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, color: Colors.orange, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              software.password!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Enter this password on the machine when prompted during installation',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Compatible machines
              if (software.machineIds.isNotEmpty || software.concession.isNotEmpty) ...[
                const Text('Compatible with:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...software.machineIds.map((id) => Chip(
                      label: Text(_getShortMachineName(id)),
                      backgroundColor: Colors.grey.shade100,
                    )),
                    ...software.concession.map((id) => Chip(
                      label: Text(_getShortMachineName(id)),
                      backgroundColor: Colors.grey.shade100,
                    )),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              
              // File details
              const Text('File details:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Size: ${software.fileSizeKB} KB'),
              Text('Released: ${_formatDate(software.releaseDate)}'),
              if (software.downloadCount > 0)
                Text('Downloaded ${software.downloadCount} times'),
              if (software.sha256FileHash != null && software.sha256FileHash!.length >= 16)
                Text('SHA256: ${software.sha256FileHash!.substring(0, 16)}...', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 16),
              
              // Installation instructions
              if (software.password != null && software.password!.isNotEmpty) ...[
                const Text('Installation Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('1. Transfer this file to a USB drive'),
                const Text('2. Insert the USB drive into the machine'),
                const Text('3. Navigate to the software installation menu'),
                const Text('4. Select the file and enter the password when prompted'),
                const SizedBox(height: 16),
              ],
              
              // Note that this is a simulation
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This app shows software details only. To install, transfer the file to the target machine.',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Share ${software.name} feature would be implemented here'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: costaRed,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
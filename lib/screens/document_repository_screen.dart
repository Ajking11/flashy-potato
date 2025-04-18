import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/document.dart';
import '../models/machine.dart';
import '../riverpod/notifiers/document_notifier.dart';
import '../riverpod/providers/document_providers.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';

class DocumentRepositoryScreen extends ConsumerStatefulWidget {
  final String? initialMachineId; // Optional: to pre-filter by machine

  const DocumentRepositoryScreen({
    super.key,
    this.initialMachineId,
  });

  @override
  ConsumerState<DocumentRepositoryScreen> createState() => _DocumentRepositoryScreenState();
}

class _DocumentRepositoryScreenState extends ConsumerState<DocumentRepositoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showOnlyDownloaded = false;
  
  @override
  void initState() {
    super.initState();
    // If initial machine ID is provided, apply the filter
    if (widget.initialMachineId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(documentNotifierProvider.notifier)
            .filterByMachine(widget.initialMachineId);
      });
    }
    
    // No need to load machine list here
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
                    'Document Repository',
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
                // Toggle for offline documents
                IconButton(
                  icon: Icon(
                    _showOnlyDownloaded 
                      ? Icons.download_for_offline
                      : Icons.download_for_offline_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Show offline documents only',
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
        
        // Document list
        Expanded(
          child: _buildDocumentList(),
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
            hintText: 'Search documents...',
            prefixIcon: const Icon(Icons.search, color: costaRed),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(documentNotifierProvider.notifier)
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
            ref.read(documentNotifierProvider.notifier)
                .setSearchQuery(value);
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final selectedMachineId = ref.watch(selectedMachineIdProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
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
                          onTap: () => _showMachineFilterSheet(context),
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
                        onTap: () => _showCategoryFilterSheet(context),
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
                    () => ref.read(documentNotifierProvider.notifier).filterByMachine(null),
                  ),
                if (selectedCategory != null)
                  _buildActiveFilterChip(
                    selectedCategory,
                    _getCategoryIcon(selectedCategory),
                    () => ref.read(documentNotifierProvider.notifier).filterByCategory(null),
                  ),
              ],
            ),
          ],
        ],
      ),
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
  void _showMachineFilterSheet(BuildContext context) {
    final machines = getMachines();
    final selectedMachineId = ref.read(selectedMachineIdProvider);
    
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
                      if (selectedMachineId != null)
                        TextButton.icon(
                          onPressed: () {
                            ref.read(documentNotifierProvider.notifier).filterByMachine(null);
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
                Consumer(
                  builder: (context, ref, _) {
                    final currentSelectedMachineId = ref.watch(selectedMachineIdProvider);
                    return ListTile(
                      leading: const Icon(
                        Icons.device_hub,
                        color: costaRed,
                      ),
                      title: const Text('All Machines'),
                      selected: currentSelectedMachineId == null,
                      selectedTileColor: costaRed.withValues(alpha: 0.1),
                      selectedColor: costaRed,
                      onTap: () {
                        ref.read(documentNotifierProvider.notifier).filterByMachine(null);
                        Navigator.pop(context);
                      },
                    );
                  }
                ),
                
                // Machine list
                Flexible(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final currentSelectedMachineId = ref.watch(selectedMachineIdProvider);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: machines.length,
                        itemBuilder: (context, index) {
                          final machine = machines[index];
                          final isSelected = currentSelectedMachineId == machine.machineId;
                          
                          return ListTile(
                            leading: isSelected
                              ? const Icon(Icons.check_circle, color: costaRed)
                              : const Icon(Icons.coffee, color: Colors.brown),
                            title: Text('${machine.manufacturer} ${machine.model}'),
                            selected: isSelected,
                            selectedTileColor: costaRed.withValues(alpha: 0.1),
                            selectedColor: costaRed,
                            onTap: () {
                              ref.read(documentNotifierProvider.notifier).filterByMachine(machine.machineId);
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
    final categories = DocumentCategory.getAllCategories();
    final selectedCategory = ref.read(selectedCategoryProvider);
    
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
                            ref.read(documentNotifierProvider.notifier).filterByCategory(null);
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
                Consumer(
                  builder: (context, ref, _) {
                    final currentSelectedCategory = ref.watch(selectedCategoryProvider);
                    return ListTile(
                      leading: const Icon(
                        Icons.category,
                        color: costaRed,
                      ),
                      title: const Text('All Categories'),
                      selected: currentSelectedCategory == null,
                      selectedTileColor: costaRed.withValues(alpha: 0.1),
                      selectedColor: costaRed,
                      onTap: () {
                        ref.read(documentNotifierProvider.notifier).filterByCategory(null);
                        Navigator.pop(context);
                      },
                    );
                  }
                ),
                
                // Category list
                Flexible(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final currentSelectedCategory = ref.watch(selectedCategoryProvider);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = currentSelectedCategory == category;
                          
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
                              ref.read(documentNotifierProvider.notifier).filterByCategory(category);
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

  Widget _buildDocumentList() {
    final isLoading = ref.watch(isDocumentsLoadingProvider);
    final allDocuments = ref.watch(filteredDocumentsProvider);
    
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(costaRed),
        ),
      );
    }

    // Apply offline filter if needed
    final documents = _showOnlyDownloaded 
        ? allDocuments.where((doc) => doc.isDownloaded).toList()
        : allDocuments;

    if (documents.isEmpty) {
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
              'No documents found',
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
                ref.read(documentNotifierProvider.notifier).refreshDocuments();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Documents'),
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
      onRefresh: () => ref.read(documentNotifierProvider.notifier).refreshDocuments(),
      color: costaRed,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: documents.length + 1, // Add one for the Firebase indicator
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
                    'Documents from Firebase',
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
          final docIndex = index - 1;
          final document = documents[docIndex];
          
          return FadeAnimation(
            delay: Duration(milliseconds: 50 * docIndex),
            child: _buildDocumentCard(document),
          );
        },
      ),
    );
  }

  Widget _buildDocumentCard(TechnicalDocument document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Check if document is downloaded
          if (document.isDownloaded) {
            // If downloaded, navigate to viewer
            context.pushNamed('document-viewer', pathParameters: {'documentId': document.id});
          } else {
            // If not downloaded, show download prompt
            _showDownloadPrompt(document);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document header with category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getCategoryColor(document.category).withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(document.category),
                    color: _getCategoryColor(document.category),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    document.category,
                    style: CostaTextStyle.bodyText2.copyWith(
                      color: _getCategoryColor(document.category),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (document.isDownloaded)
                    const Icon(
                      Icons.offline_pin,
                      color: Colors.green,
                      size: 20,
                    ),
                ],
              ),
            ),
            
            // Document content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    document.title,
                    style: CostaTextStyle.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    document.description,
                    style: CostaTextStyle.bodyText1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Document details
                  Row(
                    children: [
                      // File size
                      Text(
                        '${document.fileSizeKB} KB',
                        style: CostaTextStyle.caption,
                      ),
                      const SizedBox(width: 16),
                      
                      // Upload date
                      Text(
                        'Updated: ${_formatDate(document.uploadDate)}',
                        style: CostaTextStyle.caption,
                      ),
                      const Spacer(),
                      
                      // Download button
                      _buildDownloadButton(document),
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

  Widget _buildDownloadButton(TechnicalDocument document) {
    return Consumer(
      builder: (context, ref, _) {
        final downloadProgress = ref.watch(documentDownloadProgressProvider(document.id));
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
          child: _buildDownloadButtonState(document, isDownloading, downloadProgress, ref),
        );
      }
    );
  }
  
  // Helper to build the appropriate button state
  Widget _buildDownloadButtonState(TechnicalDocument document, bool isDownloading, double downloadProgress, WidgetRef ref) {
    // If document is downloaded, show remove button
    if (document.isDownloaded) {
      return TextButton.icon(
        key: const ValueKey('remove_button'),
        onPressed: () {
          ref.read(documentNotifierProvider.notifier).removeDownload(document.id);
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
    // If document is currently downloading, show progress
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
    // If document is not downloaded and not downloading, show download button
    else {
      return TextButton.icon(
        key: const ValueKey('download_button'),
        onPressed: () {
          // Start download
          ref.read(documentNotifierProvider.notifier).downloadDocument(document.id);
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
  
  // Helper method to get machine name from ID
  String _getMachineName(String machineId) {
    final machines = getMachines();
    final machine = machines.firstWhere(
      (m) => m.machineId == machineId,
      orElse: () => Machine(
        manufacturer: 'Unknown',
        model: 'Machine',
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
        manufacturer: 'Unknown',
        model: 'Machine',
        imagePath: '',
      ),
    );
    
    // Just return the model to save space
    return machine.model;
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  // Show prompt to download document before viewing
  void _showDownloadPrompt(TechnicalDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The document "${document.title}" needs to be downloaded before viewing.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Size: ${document.fileSizeKB} KB',
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
              // Cache required objects before async operations
              final navigator = Navigator.of(context);
              final goRouter = GoRouter.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final String documentId = document.id;
              
              // Close dialog with a smoother animation
              navigator.pop();
              
              // Small delay before starting download to allow dialog to close smoothly
              Future.delayed(const Duration(milliseconds: 100), () {
                // Start download
                ref.read(documentNotifierProvider.notifier)
                    .downloadDocument(documentId)
                    .then((_) async {
                  // File should already have a small delay from the notifier
                  
                  if (!mounted) return;
                  
                  // After download completes, verify file exists before navigating
                  final doc = ref.read(documentByIdProvider(documentId));
                  
                  if (doc != null && doc.isDownloaded) {
                    // Add a small delay before navigation for a smoother transition
                    await Future.delayed(const Duration(milliseconds: 200));
                    if (!mounted) return;
                    goRouter.pushNamed('document-viewer', pathParameters: {'documentId': documentId});
                  } else {
                    // Show error if document isn't available after download
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Document download completed but file is not accessible. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }).catchError((error) {
                  // Check if widget is still mounted before accessing context
                  if (!mounted) return;
                  
                  // Show error message if download fails
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Failed to download: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
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

  // Helper method to get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case DocumentCategory.manual:
        return Colors.blue;
      case DocumentCategory.maintenance:
        return Colors.green;
      case DocumentCategory.troubleshooting:
        return Colors.orange;
      case DocumentCategory.parts:
        return Colors.purple;
      case DocumentCategory.training:
        return Colors.teal;
      case DocumentCategory.technical:
        return costaRed;
      case DocumentCategory.bulletin:
        return Colors.amber;
      case DocumentCategory.install:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get category icon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case DocumentCategory.manual:
        return Icons.menu_book;
      case DocumentCategory.maintenance:
        return Icons.build;
      case DocumentCategory.troubleshooting:
        return Icons.help_outline;
      case DocumentCategory.parts:
        return Icons.category;
      case DocumentCategory.training:
        return Icons.school;
      case DocumentCategory.technical:
        return Icons.description;
      case DocumentCategory.bulletin:
        return Icons.announcement;
      case DocumentCategory.install:
        return Icons.install_desktop;
      default:
        return Icons.insert_drive_file;
    }
  }
}
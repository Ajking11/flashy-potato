import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/document.dart';
import '../models/machine.dart';
import '../providers/document_provider.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';

class DocumentRepositoryScreen extends StatefulWidget {
  final String? initialMachineId; // Optional: to pre-filter by machine

  const DocumentRepositoryScreen({
    super.key,
    this.initialMachineId,
  });

  @override
  State<DocumentRepositoryScreen> createState() => _DocumentRepositoryScreenState();
}

class _DocumentRepositoryScreenState extends State<DocumentRepositoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showOnlyDownloaded = false;
  late List<Machine> _machines;
  
  @override
  void initState() {
    super.initState();
    // If initial machine ID is provided, apply the filter
    if (widget.initialMachineId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<DocumentProvider>(context, listen: false)
            .filterByMachine(widget.initialMachineId);
      });
    }
    
    // Load machine list
    _machines = getMachines();
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
              title: const Text(
                'Document Repository',
                style: CostaTextStyle.appBarTitle,
              ),
              backgroundColor: costaRed,
              elevation: 0,
              centerTitle: true,
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
                      Provider.of<DocumentProvider>(context, listen: false)
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
            Provider.of<DocumentProvider>(context, listen: false)
                .setSearchQuery(value);
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        final selectedMachineId = documentProvider.selectedMachineId;
        final selectedCategory = documentProvider.selectedCategory;
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
                              onTap: () => _showMachineFilterSheet(context, documentProvider),
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
                            onTap: () => _showCategoryFilterSheet(context, documentProvider),
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
                        () => documentProvider.filterByMachine(null),
                      ),
                    if (selectedCategory != null)
                      _buildActiveFilterChip(
                        selectedCategory,
                        _getCategoryIcon(selectedCategory),
                        () => documentProvider.filterByCategory(null),
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
    DocumentProvider documentProvider,
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
                      if (documentProvider.selectedMachineId != null)
                        TextButton.icon(
                          onPressed: () {
                            documentProvider.filterByMachine(null);
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
                  selected: documentProvider.selectedMachineId == null,
                  selectedTileColor: costaRed.withValues(alpha: 0.1),
                  selectedColor: costaRed,
                  onTap: () {
                    documentProvider.filterByMachine(null);
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
                      final isSelected = documentProvider.selectedMachineId == machine.machineId;
                      
                      return ListTile(
                        leading: isSelected
                          ? const Icon(Icons.check_circle, color: costaRed)
                          : const Icon(Icons.coffee, color: Colors.brown),
                        title: Text('${machine.manufacturer} ${machine.model}'),
                        selected: isSelected,
                        selectedTileColor: costaRed.withValues(alpha: 0.1),
                        selectedColor: costaRed,
                        onTap: () {
                          documentProvider.filterByMachine(machine.machineId);
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
    DocumentProvider documentProvider,
  ) {
    final categories = DocumentCategory.getAllCategories();
    
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
                      if (documentProvider.selectedCategory != null)
                        TextButton.icon(
                          onPressed: () {
                            documentProvider.filterByCategory(null);
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
                  selected: documentProvider.selectedCategory == null,
                  selectedTileColor: costaRed.withValues(alpha: 0.1),
                  selectedColor: costaRed,
                  onTap: () {
                    documentProvider.filterByCategory(null);
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
                      final isSelected = documentProvider.selectedCategory == category;
                      
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
                          documentProvider.filterByCategory(category);
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

  Widget _buildDocumentList() {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        if (documentProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(costaRed),
            ),
          );
        }

        var documents = documentProvider.filteredDocuments;
        
        // Apply offline filter if needed
        if (_showOnlyDownloaded) {
          documents = documents.where((doc) => doc.isDownloaded).toList();
        }

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
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            return FadeAnimation(
              delay: Duration(milliseconds: 50 * index),
              child: _buildDocumentCard(document),
            );
          },
        );
      },
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
          context.pushNamed('document-viewer', pathParameters: {'documentId': document.id});
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
    if (document.isDownloaded) {
      return TextButton.icon(
        onPressed: () {
          Provider.of<DocumentProvider>(context, listen: false)
              .removeDownload(document.id);
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
    } else {
      return TextButton.icon(
        onPressed: () {
          Provider.of<DocumentProvider>(context, listen: false)
              .downloadDocument(document.id);
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
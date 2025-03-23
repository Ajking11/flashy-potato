import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document.dart';
import '../models/machine.dart';
import '../providers/document_provider.dart';
import '../constants.dart';
import '../widgets/fade_animation.dart';
import 'document_viewer_screen.dart';

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
  List<Machine> _machines = [];
  
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
                      ? Icons.offline_pin
                      : Icons.offline_pin_outlined,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: latte,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Machine filter dropdown
                if (widget.initialMachineId == null) // Only show if not pre-filtered
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.only(right: 8),
                    child: DropdownButton<String>(
                      value: selectedMachineId,
                      hint: const Text('Machine'),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: costaRed),
                      onChanged: (String? newValue) {
                        documentProvider.filterByMachine(newValue);
                      },
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Machines'),
                        ),
                        ..._machines.map((machine) {
                          return DropdownMenuItem<String>(
                            value: machine.machineId,
                            child: Text('${machine.manufacturer} ${machine.model}'),
                          );
                        }),
                      ],
                    ),
                  ),
                
                // Category filter dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text('Category'),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: costaRed),
                    onChanged: (String? newValue) {
                      documentProvider.filterByCategory(newValue);
                    },
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...DocumentCategory.getAllCategories().map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Clear filters button (only show if filters are applied)
                if (hasFilters)
                  TextButton.icon(
                    onPressed: () {
                      documentProvider.clearFilters();
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear Filters'),
                    style: TextButton.styleFrom(
                      foregroundColor: costaRed,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentViewerScreen(document: document),
            ),
          );
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
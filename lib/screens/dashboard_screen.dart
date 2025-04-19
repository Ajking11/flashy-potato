import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../models/machine.dart';
import '../widgets/fade_animation.dart';
import '../riverpod/providers/preferences_providers.dart';
import '../riverpod/providers/document_providers.dart';
import '../riverpod/notifiers/document_notifier.dart';
import '../riverpod/notifiers/preferences_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use try-catch to handle potential errors with provider access
    List<dynamic> allDocuments = [];
    try {
      // Safely access provider
      allDocuments = ref.watch(documentsProvider);
    } catch (e) {
      // If error in provider access, use empty list
      debugPrint('Error accessing documents provider: $e');
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FSE Toolbox',
          style: CostaTextStyle.appBarTitle,
        ),
        backgroundColor: costaRed,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.pushNamed('preferences');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Updates & Notifications
                FadeAnimation(
                  delay: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Updates & Notifications'),
                      _buildUpdatesCard(context, ref),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Quick Actions
                FadeAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Quick Actions'),
                      _buildQuickActionsGrid(context),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Favorite Machines
                FadeAnimation(
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Favorite Machines'),
                      _buildFavoriteMachinesGrid(context, ref),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Recent Documents (only show if there are documents)
                if (allDocuments.isNotEmpty) ...[
                  FadeAnimation(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Recent Documents'),
                        _buildRecentDocumentsCard(context, ref),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // App version
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Version $appVersion',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Container(
            height: 18,
            width: 3,
            decoration: BoxDecoration(
              color: costaRed,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: CostaTextStyle.subtitle1.copyWith(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'title': '\nFilters',
        'icon': Icons.water_drop,
        'color': Colors.blue,
        'onTap': () {
          context.go('/filters');
        },
      },
      {
        'title': '\nMachines',
        'icon': Icons.coffee,
        'color': Colors.brown,
        'onTap': () {
          context.go('/machines');
        },
      },
      {
        'title': '\nDocument',
        'icon': Icons.folder_outlined,
        'color': Colors.orange,
        'onTap': () {
          context.go('/documents');
        },
      },
      {
        'title': '\nSoftware',
        'icon': Icons.system_update_outlined,
        'color': Colors.green,
        'onTap': () {
          context.go('/software');
        },
      },
    ];

    // Changed from ListView.builder to Row with Expanded
    return SizedBox(
      height: 100,
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: action['onTap'],
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: action['color'].withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            action['icon'],
                            color: action['color'],
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          action['title'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpdatesCard(BuildContext context, WidgetRef ref) {
    // Safely access user preferences
    final userPreferences = ref.watch(userPreferencesProvider);
    
    // Safely access documents with error handling
    List<dynamic> allDocuments = [];
    try {
      allDocuments = ref.watch(documentsProvider);
    } catch (e) {
      debugPrint('Error accessing documents provider in updates card: $e');
    }
    
    // ignore: unused_local_variable
    final isOutdated = DateTime.now().difference(userPreferences.lastUpdateCheck).inDays > 3;
    final downloadedCount = allDocuments.where((doc) => doc.isDownloaded).length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                color: Colors.orange,
                size: 20,
              ),
            ),
            title: const Text(
              'New Filter Guidelines Released',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: const Text(
              'Updated installation procedure for Finest filters with high mineral content water',
              style: TextStyle(fontSize: 12),
              maxLines: 2,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Detailed notice coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              constraints: const BoxConstraints(
                maxHeight: 32,
                maxWidth: 32,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_outlined,
                color: Colors.blue,
                size: 20,
              ),
            ),
            title: Text(
              '$downloadedCount Documents Available Offline',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: const Text(
              'Access all your downloaded technical documents even without internet',
              style: TextStyle(fontSize: 12),
              maxLines: 2,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                // Navigate to documents route using go_router
                context.go('/documents');
              },
              constraints: const BoxConstraints(
                maxHeight: 32,
                maxWidth: 32,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteMachinesGrid(BuildContext context, WidgetRef ref) {
    final userPreferences = ref.watch(userPreferencesProvider);
    final favoriteIds = userPreferences.favoriteMachineIds;
    
    if (favoriteIds.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.star_border,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              const Text(
                'No favorite machines yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Add machines to your favorites from the machines list',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/machines');
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Favorites'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: costaRed,
                  side: const BorderSide(color: costaRed),
                  minimumSize: const Size(150, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final allMachines = getMachines();
    final favoriteMachines = allMachines
        .where((machine) => favoriteIds.contains(machine.machineId))
        .toList();
    
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: favoriteMachines.length,
      itemBuilder: (context, index) {
        final machine = favoriteMachines[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              context.pushNamed('machine-detail', pathParameters: {'machineId': machine.machineId});
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        ref.read(preferencesNotifierProvider.notifier)
                            .toggleFavoriteMachine(machine.machineId);
                      },
                      child: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: machine.imagePath != null
                      ? Image.asset(
                          machine.imagePath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.coffee_maker,
                              size: 40,
                              color: Colors.grey,
                            );
                          },
                        )
                      : const Icon(
                          Icons.coffee_maker,
                          size: 40,
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    machine.manufacturer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    machine.model,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentDocumentsCard(BuildContext context, WidgetRef ref) {
    // Safely access provider with error handling
    List<dynamic> allDocuments = [];
    try {
      allDocuments = ref.watch(documentsProvider);
    } catch (e) {
      debugPrint('Error accessing documents provider in recent documents card: $e');
    }
    
    final recentDocs = allDocuments.isNotEmpty 
        ? allDocuments.take(3).toList() 
        : [];
    
    if (recentDocs.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.description_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              const Text(
                'No recent documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Access documents from the Documents section',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/documents');
                },
                icon: const Icon(Icons.folder_outlined, size: 16),
                label: const Text('Browse Documents'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: costaRed,
                  side: const BorderSide(color: costaRed),
                  minimumSize: const Size(150, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Create document list items
    final List<Widget> documentItems = [];
    
    // Add each document as a list item, with dividers between
    for (int i = 0; i < recentDocs.length; i++) {
      final doc = recentDocs[i];
      
      documentItems.add(
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: Colors.blue,
              size: 20,
            ),
          ),
          title: Text(
            doc.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            doc.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            icon: Icon(
              doc.isDownloaded ? Icons.check_circle : Icons.download_outlined,
              color: doc.isDownloaded ? Colors.green : Colors.grey,
              size: 20,
            ),
            onPressed: () {
              if (doc.isDownloaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document already downloaded'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                try {
                  ref.read(documentNotifierProvider.notifier)
                      .downloadDocument(doc.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document downloaded for offline use'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  debugPrint('Error downloading document: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error downloading document: ${e.toString()}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            constraints: const BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        )
      );
      
      // Add divider if not the last item
      if (i < recentDocs.length - 1) {
        documentItems.add(const Divider(height: 1));
      }
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...documentItems,
          InkWell(
            onTap: () {
              context.go('/documents');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  'View All Documents',
                  style: TextStyle(
                    color: costaRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../services/logger_service.dart';
import '../widgets/fade_animation.dart';
import '../models/document.dart';
import '../models/software.dart';
import '../riverpod/providers/document_providers.dart';
import '../riverpod/providers/software_providers.dart';
import '../riverpod/notifiers/document_notifier.dart';
import '../riverpod/notifiers/software_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentUploads = _getRecentUploads(ref);
    
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
            onPressed: () => context.pushNamed('preferences'),
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
                _buildSection(
                  title: 'Updates & Notifications',
                  delay: const Duration(milliseconds: 100),
                  child: _buildUpdatesCard(context, ref),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Quick Actions',
                  delay: const Duration(milliseconds: 200),
                  child: _buildQuickActionsGrid(context),
                ),
                const SizedBox(height: 16),
                if (recentUploads.isNotEmpty) ...[
                  _buildSection(
                    title: 'Recent Uploads',
                    delay: const Duration(milliseconds: 400),
                    child: _buildRecentUploadsCard(context, ref),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildVersionFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> _safelyGetDocuments(WidgetRef ref) {
    try {
      final documents = ref.watch(documentsProvider);
      return documents;
    } catch (e) {
      logger.e('DashboardScreen', 'Error accessing documents provider', e);
      return [];
    }
  }

  List<dynamic> _safelyGetSoftware(WidgetRef ref) {
    try {
      final software = ref.watch(softwareListProvider);
      return software;
    } catch (e) {
      logger.e('DashboardScreen', 'Error accessing software provider', e);
      return [];
    }
  }

  List<dynamic> _getRecentUploads(WidgetRef ref) {
    final documents = _safelyGetDocuments(ref);
    final software = _safelyGetSoftware(ref);
    
    // Combine documents and software into a single list
    final List<dynamic> combined = [...documents, ...software];
    
    // Sort by upload/release date (most recent first)
    if (combined.isNotEmpty) {
      combined.sort((a, b) {
        final DateTime aDate = a is TechnicalDocument 
            ? a.uploadDate 
            : (a as Software).releaseDate;
        final DateTime bDate = b is TechnicalDocument 
            ? b.uploadDate 
            : (b as Software).releaseDate;
        return bDate.compareTo(aDate);
      });
    }
    
    // Return the 3 most recent
    return combined.take(3).toList();
  }

  Widget _buildSection({
    required String title,
    required Duration delay,
    required Widget child,
  }) {
    return FadeAnimation(
      delay: delay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title),
          child,
        ],
      ),
    );
  }

  Widget _buildVersionFooter() {
    return Center(
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
            style: CostaTextStyle.subtitle1.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      _QuickAction(
        title: 'Filters',
        icon: Icons.water_drop,
        color: Colors.blue,
        onTap: () => context.go('/filters'),
      ),
      _QuickAction(
        title: 'Machines',
        icon: Icons.coffee,
        color: Colors.brown,
        onTap: () => context.go('/machines'),
      ),
      _QuickAction(
        title: 'Document',
        icon: Icons.folder_outlined,
        color: Colors.orange,
        onTap: () => context.go('/documents'),
      ),
      _QuickAction(
        title: 'Software',
        icon: Icons.system_update_outlined,
        color: Colors.green,
        onTap: () => context.go('/software'),
      ),
    ];

    return SizedBox(
      height: 100,
      child: Row(
        children: actions.map((action) => _buildActionItem(action)).toList(),
      ),
    );
  }

  Widget _buildActionItem(_QuickAction action) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: action.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: action.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      color: action.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\n${action.title}',
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
  }

  Widget _buildUpdatesCard(BuildContext context, WidgetRef ref) {
    final allDocuments = _safelyGetDocuments(ref);
    final downloadedCount = allDocuments.where((doc) => doc.isDownloaded).length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          _buildUpdateItem(
            icon: Icons.campaign_outlined,
            iconColor: Colors.orange,
            title: 'New Filter Guidelines Released',
            subtitle: 'Updated installation procedure for Finest filters with high mineral content water',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Detailed notice coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildUpdateItem(
            icon: Icons.folder_outlined,
            iconColor: Colors.blue,
            title: '$downloadedCount Documents Available Offline',
            subtitle: 'Access all your downloaded technical documents even without internet',
            onPressed: () => context.go('/documents'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
        maxLines: 2,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios, size: 16),
        onPressed: onPressed,
        constraints: const BoxConstraints(
          maxHeight: 32,
          maxWidth: 32,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildRecentUploadsCard(BuildContext context, WidgetRef ref) {
    final recentUploads = _getRecentUploads(ref);
    final isDocumentsLoading = ref.watch(isDocumentsLoadingProvider);
    final isSoftwareLoading = ref.watch(isSoftwareLoadingProvider);
    
    // Show loading if either is still loading
    if (isDocumentsLoading || isSoftwareLoading) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        child: const Padding(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(color: costaRed),
                SizedBox(height: 16),
                Text('Loading recent uploads...'),
              ],
            ),
          ),
        ),
      );
    }
    
    if (recentUploads.isEmpty) {
      return _buildEmptyUploadsCard(context);
    }
    
    final List<Widget> uploadItems = [];
    
    for (int i = 0; i < recentUploads.length; i++) {
      final item = recentUploads[i];
      
      uploadItems.add(
        _buildUploadItem(context, ref, item),
      );
      
      if (i < recentUploads.length - 1) {
        uploadItems.add(const Divider(height: 1));
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
          ...uploadItems,
          _buildViewAllButton(context),
        ],
      ),
    );
  }




  void _handleDocumentDownload(BuildContext context, WidgetRef ref, dynamic doc) {
    if (doc.isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document already downloaded'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      try {
        ref.read(documentNotifierProvider.notifier).downloadDocument(doc.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document downloaded for offline use'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        logger.e('DashboardScreen', 'Error downloading document', e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading document: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _handleSoftwareDownload(BuildContext context, WidgetRef ref, dynamic software) {
    if (software.isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Software already downloaded'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      try {
        ref.read(softwareNotifierProvider.notifier).downloadSoftware(software.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Software downloaded for offline use'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        logger.e('DashboardScreen', 'Error downloading software', e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading software: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildUploadItem(BuildContext context, WidgetRef ref, dynamic item) {
    final bool isDocument = item is TechnicalDocument;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDocument 
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.purple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isDocument ? Icons.picture_as_pdf : Icons.memory,
          color: isDocument ? Colors.blue : Colors.purple,
          size: 20,
        ),
      ),
      title: Text(
        isDocument ? item.title : item.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        '${isDocument ? 'Document' : 'Software'}: ${isDocument ? item.description : item.description}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: IconButton(
        icon: Icon(
          item.isDownloaded ? Icons.check_circle : Icons.download_outlined,
          color: item.isDownloaded ? Colors.green : Colors.grey,
          size: 20,
        ),
        onPressed: () => isDocument 
            ? _handleDocumentDownload(context, ref, item)
            : _handleSoftwareDownload(context, ref, item),
        constraints: const BoxConstraints(
          maxHeight: 32,
          maxWidth: 32,
        ),
      ),
      onTap: () {
        if (isDocument) {
          context.go('/documents/${item.id}');
        } else {
          context.go('/software/${item.id}');
        }
      },
    );
  }

  Widget _buildEmptyUploadsCard(BuildContext context) {
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
              Icons.upload_file,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            const Text(
              'No recent uploads',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Documents and software will appear here when uploaded',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/documents'), // Default to documents, could make this smarter
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
            'View All Content',
            style: TextStyle(
              color: costaRed,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
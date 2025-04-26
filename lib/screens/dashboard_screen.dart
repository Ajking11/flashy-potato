import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../services/logger_service.dart';
import '../widgets/fade_animation.dart';
import '../riverpod/providers/document_providers.dart';
import '../riverpod/notifiers/document_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDocuments = _safelyGetDocuments(ref);
    
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
                if (allDocuments.isNotEmpty) ...[
                  _buildSection(
                    title: 'Recent Documents',
                    delay: const Duration(milliseconds: 400),
                    child: _buildRecentDocumentsCard(context, ref),
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
      return ref.watch(documentsProvider);
    } catch (e) {
      logger.e('DashboardScreen', 'Error accessing documents provider', e);
      return [];
    }
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

  Widget _buildRecentDocumentsCard(BuildContext context, WidgetRef ref) {
    final allDocuments = _safelyGetDocuments(ref);
    final recentDocs = allDocuments.isNotEmpty 
        ? allDocuments.take(3).toList() 
        : [];
    
    if (recentDocs.isEmpty) {
      return _buildEmptyDocumentsCard(context);
    }
    
    final List<Widget> documentItems = [];
    
    for (int i = 0; i < recentDocs.length; i++) {
      final doc = recentDocs[i];
      
      documentItems.add(
        _buildDocumentItem(context, ref, doc),
      );
      
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
          _buildViewAllDocumentsButton(context),
        ],
      ),
    );
  }

  Widget _buildEmptyDocumentsCard(BuildContext context) {
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
              onPressed: () => context.go('/documents'),
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

  Widget _buildDocumentItem(BuildContext context, WidgetRef ref, dynamic doc) {
    return ListTile(
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
        onPressed: () => _handleDocumentDownload(context, ref, doc),
        constraints: const BoxConstraints(
          maxHeight: 32,
          maxWidth: 32,
        ),
        padding: EdgeInsets.zero,
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

  Widget _buildViewAllDocumentsButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/documents'),
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
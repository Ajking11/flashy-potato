import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';

class ConnectionStatusIcon extends ConsumerStatefulWidget {
  final double size;
  final EdgeInsets padding;

  const ConnectionStatusIcon({
    super.key,
    this.size = 24,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  ConsumerState<ConnectionStatusIcon> createState() => _ConnectionStatusIconState();
}

class _ConnectionStatusIconState extends ConsumerState<ConnectionStatusIcon>
    with TickerProviderStateMixin {
  final _connectivityService = ConnectivityService.instance;
  final _syncService = SyncService.instance;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.unknown;
  SyncStatus _syncStatus = SyncStatus.idle;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Listen to connectivity changes
    _connectivityService.connectivityStream.listen((status) {
      if (mounted) {
        setState(() {
          _connectivityStatus = status;
        });
      }
    });
    
    // Listen to sync status changes
    _syncService.syncStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _syncStatus = status;
        });
        
        if (status == SyncStatus.syncing) {
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController.stop();
          _pulseController.reset();
        }
      }
    });
    
    // Initialize current status
    _connectivityStatus = _connectivityService.currentStatus;
    _syncStatus = _syncService.currentStatus;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getIconColor() {
    switch (_connectivityStatus) {
      case ConnectivityStatus.offline:
        return Colors.red;
      case ConnectivityStatus.online:
        if (_syncStatus == SyncStatus.syncing) {
          return Colors.orange;
        }
        return Colors.green;
      case ConnectivityStatus.unknown:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (_connectivityStatus) {
      case ConnectivityStatus.offline:
        return Icons.cloud_off;
      case ConnectivityStatus.online:
        if (_syncStatus == SyncStatus.syncing) {
          return Icons.sync;
        }
        return Icons.cloud_done;
      case ConnectivityStatus.unknown:
        return Icons.cloud_queue;
    }
  }

  String _getTooltip() {
    switch (_connectivityStatus) {
      case ConnectivityStatus.offline:
        return 'Offline - tap for details';
      case ConnectivityStatus.online:
        if (_syncStatus == SyncStatus.syncing) {
          return 'Syncing data...';
        }
        return 'Online - all features available';
      case ConnectivityStatus.unknown:
        return 'Checking connection...';
    }
  }

  void _showConnectionDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConnectionStatusDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _getTooltip(),
      child: InkWell(
        onTap: () => _showConnectionDetails(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: widget.padding,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _syncStatus == SyncStatus.syncing 
                    ? _pulseAnimation.value 
                    : 1.0,
                child: Icon(
                  _getIcon(),
                  color: _getIconColor(),
                  size: widget.size,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ConnectionStatusDialog extends StatelessWidget {
  final _syncService = SyncService.instance;
  final _connectivityService = ConnectivityService.instance;

  ConnectionStatusDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = _connectivityService.currentStatus;
    final syncStatus = _syncService.currentStatus;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getDialogIcon(connectivityStatus, syncStatus),
            color: _getDialogIconColor(connectivityStatus, syncStatus),
          ),
          const SizedBox(width: 8),
          Text(_getDialogTitle(connectivityStatus, syncStatus)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getStatusDescription(connectivityStatus, syncStatus),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          if (connectivityStatus == ConnectivityStatus.offline) ...[
            const Text(
              'Available offline features:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const _OfflineFeatureItem(
              icon: Icons.folder,
              text: 'View downloaded documents',
            ),
            const _OfflineFeatureItem(
              icon: Icons.file_download,
              text: 'Access downloaded software',
            ),
            const _OfflineFeatureItem(
              icon: Icons.search,
              text: 'Search offline content',
            ),
            const _OfflineFeatureItem(
              icon: Icons.settings,
              text: 'Use filter calculations',
            ),
            const SizedBox(height: 16),
          ],
          FutureBuilder<Map<String, dynamic>>(
            future: _syncService.getSyncInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final info = snapshot.data!;
                final lastSync = info['lastSyncTimestamp'] as String?;
                
                return Text(
                  lastSync != null 
                      ? 'Last sync: ${_formatDateTime(DateTime.parse(lastSync))}'
                      : 'No previous sync data',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      actions: [
        if (connectivityStatus == ConnectivityStatus.offline)
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _checkConnectivity(context);
            },
            child: const Text('Check Connection'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  IconData _getDialogIcon(ConnectivityStatus connectivity, SyncStatus sync) {
    switch (connectivity) {
      case ConnectivityStatus.offline:
        return Icons.cloud_off;
      case ConnectivityStatus.online:
        return sync == SyncStatus.syncing ? Icons.sync : Icons.cloud_done;
      case ConnectivityStatus.unknown:
        return Icons.cloud_queue;
    }
  }

  Color _getDialogIconColor(ConnectivityStatus connectivity, SyncStatus sync) {
    switch (connectivity) {
      case ConnectivityStatus.offline:
        return Colors.red;
      case ConnectivityStatus.online:
        return sync == SyncStatus.syncing ? Colors.orange : Colors.green;
      case ConnectivityStatus.unknown:
        return Colors.grey;
    }
  }

  String _getDialogTitle(ConnectivityStatus connectivity, SyncStatus sync) {
    switch (connectivity) {
      case ConnectivityStatus.offline:
        return 'Offline Mode';
      case ConnectivityStatus.online:
        return sync == SyncStatus.syncing ? 'Syncing Data' : 'Online';
      case ConnectivityStatus.unknown:
        return 'Connection Status';
    }
  }

  String _getStatusDescription(ConnectivityStatus connectivity, SyncStatus sync) {
    switch (connectivity) {
      case ConnectivityStatus.offline:
        return 'You are currently offline. You can still access downloaded content and use filter calculations.';
      case ConnectivityStatus.online:
        if (sync == SyncStatus.syncing) {
          return 'Connected to the internet and syncing the latest content.';
        }
        return 'Connected to the internet. All features are available.';
      case ConnectivityStatus.unknown:
        return 'Checking your internet connection...';
    }
  }

  Future<void> _checkConnectivity(BuildContext context) async {
    try {
      final status = await _connectivityService.checkConnectivity();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == ConnectivityStatus.online 
                  ? 'Connection restored!' 
                  : 'Still offline',
            ),
            backgroundColor: status == ConnectivityStatus.online 
                ? Colors.green 
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to check connectivity'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _OfflineFeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OfflineFeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
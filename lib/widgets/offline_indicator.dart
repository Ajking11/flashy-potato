import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';

class OfflineIndicator extends StatefulWidget {
  final Widget child;
  final bool showSyncStatus;
  final EdgeInsets margin;
  final Duration animationDuration;

  const OfflineIndicator({
    super.key,
    required this.child,
    this.showSyncStatus = true,
    this.margin = const EdgeInsets.all(8.0),
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator>
    with TickerProviderStateMixin {
  final _connectivityService = ConnectivityService.instance;
  final _syncService = SyncService.instance;
  
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.unknown;
  SyncStatus _syncStatus = SyncStatus.idle;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
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
        _updateVisibility();
      }
    });
    
    // Listen to sync status changes
    _syncService.syncStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _syncStatus = status;
        });
        _updateVisibility();
        
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
    _updateVisibility();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _updateVisibility() {
    final shouldBeVisible = _connectivityStatus == ConnectivityStatus.offline ||
        (_syncStatus == SyncStatus.syncing && widget.showSyncStatus);
    
    if (shouldBeVisible && !_isVisible) {
      _isVisible = true;
      _slideController.forward();
    } else if (!shouldBeVisible && _isVisible) {
      _isVisible = false;
      _slideController.reverse();
    }
  }

  Color _getIndicatorColor() {
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

  IconData _getIndicatorIcon() {
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

  String _getIndicatorText() {
    switch (_connectivityStatus) {
      case ConnectivityStatus.offline:
        return 'Offline Mode';
      case ConnectivityStatus.online:
        if (_syncStatus == SyncStatus.syncing) {
          return 'Syncing...';
        }
        return 'Online';
      case ConnectivityStatus.unknown:
        return 'Checking connection...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: widget.margin,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getIndicatorColor(),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _syncStatus == SyncStatus.syncing 
                              ? _pulseAnimation.value 
                              : 1.0,
                          child: Icon(
                            _getIndicatorIcon(),
                            color: Colors.white,
                            size: 16,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getIndicatorText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_connectivityStatus == ConnectivityStatus.offline)
                      _buildOfflineActions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _showOfflineInfo(context),
          child: const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 16,
          ),
        ),
      ],
    );
  }

  void _showOfflineInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => OfflineInfoDialog(),
    );
  }
}

class OfflineInfoDialog extends StatelessWidget {
  final _syncService = SyncService.instance;
  final _connectivityService = ConnectivityService.instance;

  OfflineInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.cloud_off, color: Colors.red),
          SizedBox(width: 8),
          Text('Offline Mode'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You are currently offline. You can still:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          const _OfflineCapabilityItem(
            icon: Icons.folder,
            text: 'View downloaded documents',
          ),
          const _OfflineCapabilityItem(
            icon: Icons.file_download,
            text: 'Access downloaded software',
          ),
          const _OfflineCapabilityItem(
            icon: Icons.search,
            text: 'Search offline content',
          ),
          const _OfflineCapabilityItem(
            icon: Icons.settings,
            text: 'Use filter calculations',
          ),
          const SizedBox(height: 16),
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

class _OfflineCapabilityItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OfflineCapabilityItem({
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
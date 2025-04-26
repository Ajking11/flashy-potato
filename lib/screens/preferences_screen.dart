// lib/screens/preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../riverpod/notifiers/preferences_notifier.dart';
// We only need the notifier directly, not the granular providers
// import '../riverpod/providers/preferences_providers.dart';
import '../constants.dart';
import '../services/session_manager.dart';
import '../services/notification_service.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final preferencesState = ref.watch(preferencesNotifierProvider);
    final preferencesNotifier = ref.watch(preferencesNotifierProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preferences',
          style: CostaTextStyle.appBarTitle,
        ),
        backgroundColor: costaRed,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          if (preferencesState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(costaRed),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account information section
                _buildSectionHeader(context, 'Account Information'),
                Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: costaRed,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Signed in as',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              color: costaRed,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                SessionManager.getCurrentUserEmail() ?? 'Not signed in',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Notification section
                _buildSectionHeader(context, 'Notifications'),
                Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      FutureBuilder<bool>(
                        future: notificationService.areNotificationsEnabled(),
                        builder: (context, snapshot) {
                          final bool notificationsEnabled = snapshot.data ?? true;
                          return SwitchListTile(
                            title: const Text('Enable Notifications'),
                            subtitle: const Text(
                                'Turn on/off all notifications for this app'),
                            value: notificationsEnabled,
                            onChanged: (value) async {
                              if (value) {
                                await notificationService.enableNotifications();
                              } else {
                                await notificationService.disableNotifications();
                              }
                              // Force rebuild
                              setState(() {});
                            },
                            secondary: const Icon(
                              Icons.notifications_active_outlined,
                              color: costaRed,
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      FutureBuilder<bool>(
                        future: notificationService.areDocumentNotificationsEnabled(),
                        builder: (context, snapshot) {
                          final bool documentNotificationsEnabled = snapshot.data ?? true;
                          return SwitchListTile(
                            title: const Text('Document Updates'),
                            subtitle: const Text(
                                'Get notified when documents are updated'),
                            value: documentNotificationsEnabled,
                            onChanged: (value) async {
                              if (value) {
                                await notificationService.subscribeToDocumentUpdates();
                              } else {
                                await notificationService.unsubscribeFromDocumentUpdates();
                              }
                              // Update preferences too to maintain consistency
                              preferencesNotifier.updateNotificationPreferences(
                                notifyDocumentUpdates: value,
                              );
                              // Force rebuild
                              setState(() {});
                            },
                            secondary: const Icon(
                              Icons.article_outlined,
                              color: costaRed,
                            ),
                          );
                        }
                      ),
                      const Divider(height: 1),
                      FutureBuilder<bool>(
                        future: notificationService.areSoftwareNotificationsEnabled(),
                        builder: (context, snapshot) {
                          final bool softwareNotificationsEnabled = snapshot.data ?? true;
                          return SwitchListTile(
                            title: const Text('Software Updates'),
                            subtitle: const Text(
                                'Get notified about new software updates'),
                            value: softwareNotificationsEnabled,
                            onChanged: (value) async {
                              if (value) {
                                await notificationService.subscribeToSoftwareUpdates();
                              } else {
                                await notificationService.unsubscribeFromSoftwareUpdates();
                              }
                              // Update preferences too to maintain consistency
                              preferencesNotifier.updateNotificationPreferences(
                                notifySoftwareUpdates: value,
                              );
                              // Force rebuild
                              setState(() {});
                            },
                            secondary: const Icon(
                              Icons.system_update_outlined,
                              color: costaRed,
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),

                // Favorites section has been removed

                // App info
                _buildSectionHeader(context, 'About'),
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text('Version'),
                        subtitle: Text(appVersion),
                        leading: Icon(
                          Icons.info_outline,
                          color: costaRed,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Last Update Check'),
                        subtitle: Text(
                          _formatDate(preferencesState.preferences.lastUpdateCheck),
                        ),
                        leading: const Icon(
                          Icons.update,
                          color: costaRed,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            preferencesNotifier.updateLastUpdateCheck();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checked for updates'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Sign Out button at the bottom of the page
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Capture router at the beginning to use after async operations
                      final router = GoRouter.of(context);
                      
                      // Show sign out confirmation dialog with better styling
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dialog header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: costaRed.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.logout_rounded,
                                        color: costaRed,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: deepRed,
                                        fontFamily: 'CostaDisplayO',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Dialog content
                                const Text(
                                  'Are you sure you want to sign out?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Color(0xFF333333),
                                    fontFamily: 'CostaTextO',
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Dialog buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Cancel button
                                    OutlinedButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: costaRed,
                                        side: const BorderSide(color: costaRed),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 12),
                                    // Confirm button
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: costaRed,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      child: const Text('Sign Out'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      
                      if (confirm == true) {
                        // Capture the router before async operation
                        final currentRouter = router;
                        
                        await SessionManager.clearSession();
                        
                        // Use the captured router reference
                        currentRouter.go('/login');
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: costaRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: CostaTextStyle.subtitle1,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // This method was used for favorites and has been removed
}
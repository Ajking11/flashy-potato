// lib/screens/preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/preferences_provider.dart';
import '../constants.dart';
import '../services/session_manager.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preferences',
          style: CostaTextStyle.appBarTitle,
        ),
        backgroundColor: costaRed,
        elevation: 0,
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, prefsProvider, child) {
          if (prefsProvider.isLoading) {
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
                        Row(
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              color: costaRed,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
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
                      SwitchListTile(
                        title: const Text('Document Updates'),
                        subtitle: const Text(
                            'Get notified when documents are updated'),
                        value: prefsProvider.preferences.notifyDocumentUpdates,
                        onChanged: (value) {
                          prefsProvider.updateNotificationPreferences(
                            notifyDocumentUpdates: value,
                          );
                        },
                        secondary: const Icon(
                          Icons.article_outlined,
                          color: costaRed,
                        ),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Important Information'),
                        subtitle: const Text(
                            'Get notified about important FSE information'),
                        value: prefsProvider.preferences.notifyImportantInfo,
                        onChanged: (value) {
                          prefsProvider.updateNotificationPreferences(
                            notifyImportantInfo: value,
                          );
                        },
                        secondary: const Icon(
                          Icons.info_outline,
                          color: costaRed,
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorites management
                _buildSectionHeader(context, 'Favorites'),
                Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favorite Machines',
                          style: CostaTextStyle.subtitle2,
                        ),
                        const SizedBox(height: 8),
                        prefsProvider.preferences.favoriteMachineIds.isEmpty
                            ? const Text(
                                'No favorite machines yet. Mark machines as favorites from the machine list.',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: prefsProvider.preferences.favoriteMachineIds
                                    .map((id) => Chip(
                                          label: Text(_getMachineName(id)),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 16,
                                          ),
                                          onDeleted: () {
                                            prefsProvider.toggleFavoriteMachine(id);
                                          },
                                        ))
                                    .toList(),
                              ),
                        const SizedBox(height: 16),
                        Text(
                          'Favorite Filters',
                          style: CostaTextStyle.subtitle2,
                        ),
                        const SizedBox(height: 8),
                        prefsProvider.preferences.favoriteFilterTypes.isEmpty
                            ? const Text(
                                'No favorite filters yet. Mark filters as favorites from the filter results.',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: prefsProvider.preferences.favoriteFilterTypes
                                    .map((type) => Chip(
                                          label: Text(type),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 16,
                                          ),
                                          onDeleted: () {
                                            prefsProvider.toggleFavoriteFilter(type);
                                          },
                                        ))
                                    .toList(),
                              ),
                      ],
                    ),
                  ),
                ),

                // App info
                _buildSectionHeader(context, 'About'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Version'),
                        subtitle: const Text(appVersion),
                        leading: const Icon(
                          Icons.info_outline,
                          color: costaRed,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Last Update Check'),
                        subtitle: Text(
                          _formatDate(prefsProvider.preferences.lastUpdateCheck),
                        ),
                        leading: const Icon(
                          Icons.update,
                          color: costaRed,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            prefsProvider.updateLastUpdateCheck();
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
                        await SessionManager.clearSession();
                        if (!mounted) return;
                        
                        // Navigate back to login screen using captured router
                        router.go('/login');
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

  String _getMachineName(String machineId) {
    // In a real app, you would look up the machine name from your data.
    final parts = machineId.split('_');
    if (parts.length >= 2) {
      return '${parts[0][0].toUpperCase()}${parts[0].substring(1)} ${parts[1][0].toUpperCase()}${parts[1].substring(1)}';
    }
    return machineId;
  }
}
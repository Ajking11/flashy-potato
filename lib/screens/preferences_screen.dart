import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';
import '../constants.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

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
                // Theme section (conditionally displayed)
                if (showDarkModeToggle) ...[
                  _buildSectionHeader(context, 'Appearance'),
                  Card(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Dark Mode'),
                          subtitle:
                              const Text('Use dark theme throughout the app'),
                          value: prefsProvider.isDarkMode,
                          onChanged: (value) {
                            prefsProvider.toggleDarkMode();
                          },
                          secondary: Icon(
                            prefsProvider.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: costaRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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
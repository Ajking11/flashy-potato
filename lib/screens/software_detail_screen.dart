import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/software.dart';
import '../constants.dart';
import '../models/machine.dart';
import '../riverpod/notifiers/software_notifier.dart';
import '../riverpod/notifiers/usb_transfer_notifier.dart';
import '../riverpod/providers/usb_transfer_providers.dart' as usb_transfer_providers;
import '../riverpod/providers/software_providers.dart' as software_providers;

class SoftwareDetailScreen extends ConsumerWidget {
  final Software? software;
  final String? softwareId;

  const SoftwareDetailScreen({
    super.key,
    required this.software,
  }) : softwareId = null;
  
  // Named constructor for loading by ID
  const SoftwareDetailScreen.fromId({
    super.key,
    required this.softwareId,
  }) : software = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load software by ID if software is null
    if (software == null && softwareId != null) {
      // Watch the async software provider to get the software with the given ID
      final softwareAsync = ref.watch(software_providers.softwareByIdProvider(softwareId!));
      
      return softwareAsync.when(
        data: (softwareData) {
          if (softwareData == null) {
            // Software not found
            return Scaffold(
              appBar: AppBar(
                title: const Text('Not Found'),
                backgroundColor: costaRed,
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Software not found', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('The requested software could not be loaded.'),
                  ],
                ),
              ),
            );
          }
          
          // Software found, build the UI
          return _buildScreenWithSoftware(context, ref, softwareData);
        },
        loading: () => Scaffold(
          appBar: AppBar(
            title: const Text('Loading...'),
            backgroundColor: costaRed,
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: costaRed),
                SizedBox(height: 16),
                Text('Loading software details...')
              ],
            ),
          ),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
            backgroundColor: costaRed,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Error loading software', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('$error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(software_providers.softwareByIdProvider(softwareId!)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    // Use provided software if available
    return _buildScreenWithSoftware(context, ref, software!);
  }
  
  Widget _buildScreenWithSoftware(BuildContext context, WidgetRef ref, Software software) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          software.name,
          style: CostaTextStyle.appBarTitle,
        ),
        backgroundColor: costaRed,
        actions: [
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Share ${software.name} feature would be implemented here'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Software header with category and version
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getCategoryColor(software.category).withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _getCategoryColor(software.category).withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category with icon
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(software.category),
                        color: _getCategoryColor(software.category),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        software.category,
                        style: TextStyle(
                          color: _getCategoryColor(software.category),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Version badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: costaRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: costaRed.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'v${software.version}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: costaRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Software name and description
                  Text(
                    software.name,
                    style: CostaTextStyle.headline2.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    software.description,
                    style: CostaTextStyle.bodyText1,
                  ),
                ],
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // We removed the "Downloaded and ready to use" box as requested

                  // Installation Password (if available)
                  if (software.password != null && software.password!.isNotEmpty) ...[
                    const Text('Machine Password', style: CostaTextStyle.subtitle1),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_outline, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                software.password!,
                                style: const TextStyle(
                                  fontFamily: 'CostaDisplayO',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Enter this password on the machine when prompted during installation',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Compatible machines
                  if (software.machineIds.isNotEmpty || software.concession.isNotEmpty) ...[
                    const Text('Compatible with', style: CostaTextStyle.subtitle1),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Machine IDs
                        ...software.machineIds.map((machineId) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            _getShortMachineName(machineId),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )),
                        
                        // Concession machines
                        ...software.concession.map((machineId) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            _getShortMachineName(machineId),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // File details
                  const Text('File details', style: CostaTextStyle.subtitle1),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.sd_storage_outlined,
                          'Size',
                          '${software.fileSizeKB} KB',
                        ),
                        const Divider(),
                        _buildDetailRow(
                          Icons.calendar_today_outlined,
                          'Released',
                          _formatDate(software.uploadDate),
                        ),
                        if (software.uploadedBy != null && software.uploadedBy!.isNotEmpty) ...[
                          const Divider(),
                          _buildDetailRow(
                            Icons.person_outline,
                            'Author',
                            software.uploadedBy!,
                          ),
                        ],
                        if (software.downloadCount > 0) ...[
                          const Divider(),
                          _buildDetailRow(
                            Icons.download_outlined,
                            'Downloads',
                            '${software.downloadCount}',
                          ),
                        ],
                        if (software.sha256FileHash != null && software.sha256FileHash!.length >= 16) ...[
                          const Divider(),
                          _buildDetailRow(
                            Icons.security_outlined,
                            'SHA256',
                            '${software.sha256FileHash!.substring(0, 16)}...',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Installation instructions
                  if (software.password != null && software.password!.isNotEmpty) ...[
                    const Text('Installation Instructions', style: CostaTextStyle.subtitle1),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInstructionStep(1, 'Transfer this file to a USB drive'),
                          const SizedBox(height: 12),
                          _buildInstructionStep(2, 'Insert the USB drive into the machine'),
                          const SizedBox(height: 12),
                          _buildInstructionStep(3, 'Navigate to the software installation menu'),
                          const SizedBox(height: 12),
                          _buildInstructionStep(4, 'Select the file and enter the password when prompted'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Note about app functionality
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This app provides software details and download capability. To install the software, transfer it to the target machine.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom action button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer(
            builder: (context, widgetRef, _) {
              final downloadProgress = widgetRef.watch(software_providers.softwareDownloadProgressProvider(software.id));
              final isDownloading = downloadProgress > 0;
              
              // Use AnimatedSwitcher for smooth transitions
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _buildActionButton(context, software, isDownloading, downloadProgress),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  // Helper method to build an instruction step
  Widget _buildInstructionStep(int number, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue.shade900,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June', 
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Get a shorter version of machine name
  String _getShortMachineName(String machineId) {
    final machines = getMachines();
    final machine = machines.firstWhere(
      (m) => m.machineId == machineId,
      orElse: () => Machine(
        manufacturer: '',
        model: machineId,
        imagePath: '',
      ),
    );
    
    // Just return the model to save space
    return machine.model.isNotEmpty ? machine.model : machineId;
  }

  // Helper method to get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case SoftwareCategory.firmware:
        return Colors.blue;
      case SoftwareCategory.utility:
        return Colors.green;
      case SoftwareCategory.diagnostic:
        return Colors.orange;
      case SoftwareCategory.driver:
        return Colors.purple;
      case SoftwareCategory.calibration:
        return Colors.teal;
      case SoftwareCategory.update:
        return costaRed;
      case SoftwareCategory.configuration:
        return Colors.amber;
      case SoftwareCategory.promo:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get category icon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case SoftwareCategory.firmware:
        return Icons.memory;
      case SoftwareCategory.utility:
        return Icons.handyman;
      case SoftwareCategory.diagnostic:
        return Icons.build;
      case SoftwareCategory.driver:
        return Icons.developer_board;
      case SoftwareCategory.calibration:
        return Icons.tune;
      case SoftwareCategory.update:
        return Icons.system_update;
      case SoftwareCategory.configuration:
        return Icons.settings;
      case SoftwareCategory.promo:
        return Icons.local_offer;
      default:
        return Icons.code;
    }
  }
  
  // Build the dynamic action button
  Widget _buildActionButton(BuildContext context, Software software, bool isDownloading, double downloadProgress) {
    // If software is already downloaded, show transfer button
    if (software.isDownloaded) {
      return ElevatedButton.icon(
        key: const ValueKey('transfer_button'),
        onPressed: () {
          // Show USB loading instructions dialog
          _showUsbLoadingDialog(context, software);
        },
        icon: const Icon(Icons.save_alt),
        label: const Text('Transfer Software to Device'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      );
    }
    // If software is currently downloading, show progress button
    else if (isDownloading) {
      return Container(
        key: const ValueKey('progress_button'),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress text
            Text(
              'Downloading: ${(downloadProgress * 100).toInt()}%',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: downloadProgress,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(costaRed),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      );
    }
    // If software is not downloaded and not downloading, show download button
    else {
      return Consumer(
        builder: (context, consumerRef, _) {
          return ElevatedButton.icon(
            key: const ValueKey('download_button'),
            onPressed: () {
              // Start download
              consumerRef.read(softwareNotifierProvider.notifier)
                  .downloadSoftware(software.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download started'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1), // Shorter duration for smoother experience
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Software'),
            style: ElevatedButton.styleFrom(
              backgroundColor: costaRed,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          );
        }
      );
    }
  }
  
  // Shows an interactive USB loading wizard using Riverpod for state management
  void _showUsbLoadingDialog(BuildContext context, Software software) {
    // Launch the USB transfer wizard with the software
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ProviderScope(
          child: UsbTransferWizard(
            software: software,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }
}

// USB Transfer Wizard Screen with Riverpod
class UsbTransferWizard extends ConsumerWidget {
  final Software software;
  final ScrollController? scrollController;
  
  const UsbTransferWizard({
    super.key,
    required this.software,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state through utility providers for granular rebuilds
    final currentStep = ref.watch(usb_transfer_providers.currentStepProvider(software.id));
    final isUsbDetected = ref.watch(usb_transfer_providers.isUsbDetectedProvider(software.id));
    final isTransferStarted = ref.watch(usb_transfer_providers.isTransferStartedProvider(software.id));
    final isTransferComplete = ref.watch(usb_transfer_providers.isTransferCompleteProvider(software.id));
    final transferProgress = ref.watch(usb_transfer_providers.transferProgressProvider(software.id));
    final transferStatus = ref.watch(usb_transfer_providers.transferStatusProvider(software.id));
    
    // Get the notifier to modify state
    final notifier = ref.read(usbTransferNotifierProvider(software.id).notifier);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'USB Transfer Wizard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    // Show confirmation dialog if transfer is in progress
                    if (isTransferStarted && !isTransferComplete) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Cancel Transfer?'),
                          content: const Text('Are you sure you want to cancel the transfer? The process will be interrupted.'),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('Continue Transfer'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.pop(); // Close dialog
                                context.pop(); // Close bottom sheet
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Cancel Transfer'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          // Handle step-specific actions with improved async management
          if (currentStep == 0) {
            // First, move to next step
            notifier.nextStep();
            // Then start USB detection (prevents race conditions)
            Future.microtask(() => notifier.detectUsb());
          } else if (currentStep == 1) {
            // We're at the USB detection step
            if (isUsbDetected) {
              // USB detected, first go to transfer step
              notifier.nextStep();
              // Then start transfer on the next frame to avoid state update conflicts
              Future.microtask(() => notifier.startTransfer());
            } else {
              // First retry detection
              notifier.detectUsb();
              
              // For demo purposes only with improved async handling
              // In a real app, you'd rely on actual detection
              Future.microtask(() {
                // Delay detection for realistic simulation, but use microtask to avoid
                // concurrent state modifications
                Future.delayed(const Duration(milliseconds: 2000), () {
                  notifier.simulateUsbDetected();
                });
              });
            }
          } else if (currentStep == 2 && isTransferComplete) {
            // Done with transfer, can close the wizard
            context.pop();
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            notifier.previousStep();
          }
        },
        controlsBuilder: (context, details) {
          // Custom controls based on current step
          final bool isFirstStep = details.currentStep == 0;
          final bool isLastStep = details.currentStep == 2;
          
          // Button text varies by step
          String continueText = 'Continue';
          if (details.currentStep == 0) {
            continueText = 'Select Storage Location';
          } else if (details.currentStep == 1) {
            continueText = isUsbDetected ? 'Start Transfer' : 'Select Location';
          } else if (details.currentStep == 2) {
            continueText = isTransferComplete ? 'Finish' : 'Transferring...';
          }
          
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: (details.currentStep == 2 && !isTransferComplete) ? null : details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    // Disable button when waiting or transferring
                    disabledBackgroundColor: Colors.blue.withValues(alpha: 0.5),
                    disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                  ),
                  child: Text(continueText),
                ),
                if (!isFirstStep && !isLastStep)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
              ],
            ),
          );
        },
        steps: [
          // Step 1: Introduction
          Step(
            title: const Text('Prepare External Storage'),
            subtitle: const Text('Get your storage device ready'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This wizard will help you transfer the software package to external storage or USB drive.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                // Software details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getCategoryIcon(software.category),
                            color: _getCategoryColor(software.category),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            software.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'v${software.version}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Size: ${software.fileSizeKB} KB',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Before continuing:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildCheckItem('Connect your USB drive or prepare external storage', true),
                      _buildCheckItem('Storage should have at least 1GB of free space', true),
                      _buildCheckItem('You may need a USB OTG adapter for mobile devices', false),
                    ],
                  ),
                ),
              ],
            ),
            isActive: currentStep == 0,
          ),
          
          // Step 2: Select Storage Location (formerly Connect USB)
          Step(
            title: const Text('Select Storage Location'),
            subtitle: Text(isUsbDetected ? 'Location selected' : 'Select a location'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Storage selection animation or status
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isUsbDetected ? Icons.folder : Icons.folder_open,
                        size: 48,
                        color: isUsbDetected ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isUsbDetected 
                            ? 'Storage Location Selected' 
                            : 'Select a USB drive or folder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUsbDetected ? Colors.green : Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Storage selection instructions
                if (!isUsbDetected)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue.shade800),
                            const SizedBox(width: 8),
                            const Text(
                              'External Storage Access:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Connect your USB drive to your device (using OTG adapter if needed)'),
                        const Text(
                          '• You\'ll be asked to select the destination folder'),
                        const Text(
                          '• Navigate to your USB drive in the file picker'),
                        const Text(
                          '• Grant permissions if prompted'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.touch_app, color: Colors.blue.shade800, size: 16),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Tap "Continue" to open the storage selection dialog.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (isUsbDetected)
                  Builder(
                    builder: (context) {
                      // Watch for USB display name from state
                      final usbDisplayName = ref.watch(
                        usbTransferNotifierProvider(software.id).select((state) => state.usbDisplayName)
                      );
                      final mountPath = ref.watch(
                        usbTransferNotifierProvider(software.id).select((state) => state.usbMountPath)
                      );
                      
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green.shade800),
                                const SizedBox(width: 8),
                                const Text(
                                  'Selected Storage Location:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Name: ${usbDisplayName ?? "External Storage"}'),
                            if (mountPath != null)
                              Text(
                                'Path: ${mountPath.length > 40 ? "${mountPath.substring(0, 37)}..." : mountPath}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 8),
                            const Text(
                              'Ready to transfer files to the selected location.',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
            isActive: currentStep == 1,
            state: isUsbDetected ? StepState.complete : StepState.indexed,
          ),
          
          // Step 3: Transfer Files with improved error handling
          Step(
            title: const Text('Transfer Software'),
            subtitle: Text(isTransferComplete ? 'Completed' : 'Ready to transfer'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced transfer status with better error handling
                Builder(
                  builder: (context) {
                    // Get comprehensive status info with a single watch
                    // Use the prefixed provider to avoid ambiguity
                    final statusInfo = ref.watch(usb_transfer_providers.transferStatusInfoProvider(software.id));
                    
                    // Access the Map values properly
                    final bool hasError = statusInfo['hasError'] as bool;
                    final bool isComplete = statusInfo['isComplete'] as bool;
                    final Color displayColor = statusInfo['displayColor'] as Color;
                    final IconData iconData = statusInfo['icon'] as IconData;
                    final String statusText = statusInfo['status'] as String;
                    final String? errorDetails = statusInfo['error'] as String?;
                    
                    // Determine background and border colors based on state
                    final bgColor = hasError ? Colors.red.shade50 : 
                                   (isComplete ? Colors.green.shade50 : Colors.blue.shade50);
                    final borderColor = hasError ? Colors.red.shade200 : 
                                       (isComplete ? Colors.green.shade200 : Colors.blue.shade200);
                    
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(iconData, color: displayColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: displayColor.withAlpha(200),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Show error details if available
                          if (hasError && errorDetails != null && errorDetails.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Error details: $errorDetails',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          
                          // Only show progress indicators if there's no error
                          if (!hasError) ...[
                            const SizedBox(height: 16),
                            // Progress bar
                            LinearProgressIndicator(
                              value: transferProgress,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(displayColor),
                            ),
                            const SizedBox(height: 8),
                            // Progress percentage
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${(transferProgress * 100).toInt()}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: displayColor.withAlpha(200),
                                ),
                              ),
                            ),
                          ],
                          
                          // Show retry button on error
                          if (hasError) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (currentStep == 1) {
                                    notifier.detectUsb();
                                  } else {
                                    notifier.startTransfer();
                                  }
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Transfer details or completion message
                if (isTransferComplete)
                  _buildTransferCompletionWidget(software, transferStatus),
                if (isTransferStarted && !isTransferComplete && !ref.watch(usb_transfer_providers.hasTransferErrorProvider(software.id)))
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transfer Process:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildProcessStep('Preparing file for transfer', transferProgress >= 0.25),
                        _buildProcessStep('Verifying package integrity', transferProgress >= 0.4),
                        _buildProcessStep('Saving to selected location', transferProgress >= 0.7),
                        _buildProcessStep('Finalizing transfer', transferProgress >= 1.0),
                      ],
                    ),
                  ),
                if (!isTransferStarted)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ready to Transfer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('Package: ${software.name} v${software.version}'),
                        Text('Size: ${software.fileSizeKB} KB'),
                        Builder(
                          builder: (context) {
                            final usbDisplayName = ref.watch(
                              usbTransferNotifierProvider(software.id).select((state) => state.usbDisplayName)
                            );
                            return Text('Destination: ${usbDisplayName ?? "Selected Storage Location"}');
                          }
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Click "Start Transfer" to begin copying files to the selected location.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  
                // Password reminder if applicable
                if (software.password != null && software.password!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.vpn_key, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Installation Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'You will need this password when installing the software on the machine:',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.orange.shade300),
                          ),
                          child: Text(
                            software.password!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            isActive: currentStep == 2,
            state: isTransferComplete ? StepState.complete : StepState.indexed,
          ),
        ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods moved to static methods or widget methods
  
  // Helper method to build a checklist item
  Widget _buildCheckItem(String text, bool checked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build a process step
  Widget _buildProcessStep(String text, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.timelapse,
            color: completed ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: completed ? Colors.green.shade700 : Colors.grey.shade700,
              fontWeight: completed ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods to get category color and icon - copied from parent class for convenience
  Color _getCategoryColor(String category) {
    switch (category) {
      case SoftwareCategory.firmware:
        return Colors.blue;
      case SoftwareCategory.utility:
        return Colors.green;
      case SoftwareCategory.diagnostic:
        return Colors.orange;
      case SoftwareCategory.driver:
        return Colors.purple;
      case SoftwareCategory.calibration:
        return Colors.teal;
      case SoftwareCategory.update:
        return costaRed;
      case SoftwareCategory.configuration:
        return Colors.amber;
      case SoftwareCategory.promo:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case SoftwareCategory.firmware:
        return Icons.memory;
      case SoftwareCategory.utility:
        return Icons.handyman;
      case SoftwareCategory.diagnostic:
        return Icons.build;
      case SoftwareCategory.driver:
        return Icons.developer_board;
      case SoftwareCategory.calibration:
        return Icons.tune;
      case SoftwareCategory.update:
        return Icons.system_update;
      case SoftwareCategory.configuration:
        return Icons.settings;
      case SoftwareCategory.promo:
        return Icons.local_offer;
      default:
        return Icons.code;
    }
  }

  Widget _buildTransferCompletionWidget(Software software, String transferStatus) {
    // Check if the software is a ZIP file
    final fileName = software.filePath.split('/').last;
    final isZipFile = fileName.toLowerCase().endsWith('.zip');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic completion message from transfer status
          Text(
            transferStatus,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          Text('Package: ${software.name} v${software.version}'),
          Text(
            isZipFile 
                ? 'Contents extracted to: USB root directory' 
                : 'Location: USB root directory'
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Output: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: isZipFile 
                      ? 'Multiple files + COSTA_EXTRACTION_INFO.txt'
                      : '$fileName, COSTA_EXTRACTION_INFO.txt',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            isZipFile 
                ? 'Software package has been extracted and is ready for installation. You can now safely disconnect the USB drive.'
                : 'You can now safely disconnect the USB drive and use it to install the software on your machine.',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          if (isZipFile) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Files have been extracted directly to the USB root for easy access.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
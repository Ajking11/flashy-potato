import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/notifiers/filter_notifier.dart';
import '../riverpod/providers/filter_providers.dart';
import '../widgets/input_card.dart';
import '../widgets/result_card.dart';
import '../widgets/result_card_shimmer.dart';
import '../widgets/fade_animation.dart';
import '../constants.dart';

class FilterJsonScreen extends ConsumerStatefulWidget {
  const FilterJsonScreen({super.key});

  @override
  ConsumerState<FilterJsonScreen> createState() => _FilterJsonScreenState();
}

class _FilterJsonScreenState extends ConsumerState<FilterJsonScreen>
    with SingleTickerProviderStateMixin {
  // Controllers for user input fields
  final TextEditingController tempHardnessController = TextEditingController();
  final TextEditingController totalHardnessController = TextEditingController();
  final TextEditingController cpdController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Animation controller for loading spinner
  late AnimationController _loadingAnimationController;

  @override
  void initState() {
    super.initState();
    // Initialize loading animation controller without immediately repeating
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Control animation based on provider state
    final isLoading = ref.read(isFilterLoadingProvider);
    final isCalculating = ref.read(isFilterCalculatingProvider);
    _updateAnimationState(isLoading || isCalculating);
  }

  // Method to control animation state
  void _updateAnimationState(bool shouldAnimate) {
    if (shouldAnimate) {
      if (!_loadingAnimationController.isAnimating) {
        _loadingAnimationController.repeat();
      }
    } else {
      if (_loadingAnimationController.isAnimating) {
        _loadingAnimationController.stop();
      }
    }
  }

  // Filter data based on user input
  void filterData() async {
    if (!_formKey.currentState!.validate()) return;

    final tempHardness = int.tryParse(tempHardnessController.text);
    final totalHardness = int.tryParse(totalHardnessController.text);
    final cpd = int.tryParse(cpdController.text);

    if (tempHardness == null || totalHardness == null || cpd == null) {
      return;
    }

    try {
      await ref.read(filterNotifierProvider.notifier)
          .getFilterRecommendation(tempHardness, totalHardness, cpd);
      
      // Check for errors
      final error = ref.read(filterErrorProvider);
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error,
              style: CostaTextStyle.bodyText2.copyWith(color: Colors.white),
            ),
            backgroundColor: accentRed,
            duration: const Duration(seconds: 5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: CostaTextStyle.bodyText2.copyWith(color: Colors.white),
          ),
          backgroundColor: accentRed,
          duration: const Duration(seconds: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }
  }

  // Build AppBar with consistent typography
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Water Filter Finder',
        textAlign: TextAlign.center,
        style: CostaTextStyle.appBarTitle,
      ),
      backgroundColor: costaRed,
      elevation: 0.0,
      centerTitle: false,
    );
  }

  // Custom loading spinner with Costa branding
  Widget _buildLoadingSpinner({Key? key}) {
    return Center(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_loadingAnimationController),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: costaRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_cafe,
                color: costaRed,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading...",
            style: CostaTextStyle.subtitle2.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Build calculating view
  Widget _buildCalculatingView({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Show shimmer placeholder while calculating
          const ResultCardShimmer(),
          const SizedBox(height: 24),
          Text(
            "Finding the best filter for your water...",
            style: CostaTextStyle.bodyText2.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Build results view
  Widget _buildResultsView({Key? key}) {
    // Get user input values as integers
    final tempHardness = int.tryParse(tempHardnessController.text) ?? 0;
    final totalHardness = int.tryParse(totalHardnessController.text) ?? 0;
    final cpd = int.tryParse(cpdController.text) ?? 0;
    
    final filteredData = ref.watch(filteredDataProvider);
    final filterSize = ref.watch(filterSizeProvider);
    final bypass = ref.watch(bypassProvider);
    final capacity = ref.watch(capacityProvider);
    final showExpandedDetails = ref.watch(showExpandedDetailsProvider);
    
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FadeAnimation(
            child: ResultCard(
              filteredData: filteredData!,
              filterSize: filterSize!,
              bypass: bypass!,
              capacity: capacity!,
              tempHardness: tempHardness,
              totalHardness: totalHardness,
              cpd: cpd,
              showExpandedDetails: showExpandedDetails,
              toggleExpandedDetails: () {
                ref.read(filterNotifierProvider.notifier).toggleExpandedDetails();
              },
              onNewSearch: null, // Removed the callback since button is removed
            ),
          ),
          const SizedBox(height: 24),
          FadeAnimation(
            delay: const Duration(milliseconds: 300),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Start New Search',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: costaRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Reset form fields
                  tempHardnessController.clear();
                  totalHardnessController.clear();
                  cpdController.clear();
                  
                  // Reset state using the new complete reset implementation
                  ref.read(filterNotifierProvider.notifier).resetSearch();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Build wide screen input view
  Widget _buildWideInputView({Key? key}) {
    return Row(
      key: key,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: FadeAnimation(
              child: Form(
                key: _formKey,
                child: InputCard(
                  tempHardnessController: tempHardnessController,
                  totalHardnessController: totalHardnessController,
                  cpdController: cpdController,
                  formKey: _formKey,
                  onSubmit: filterData,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: FadeAnimation(
              delay: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: italianPorcelain,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        size: 80,
                        color: costaRed.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Enter your water parameters to find the right filter",
                      textAlign: TextAlign.center,
                      style: CostaTextStyle.subtitle1.copyWith(
                        color: deepRed,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "We'll recommend the best filter based on your water hardness and volume needs",
                      textAlign: TextAlign.center,
                      style: CostaTextStyle.bodyText2.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Build narrow screen input view
  Widget _buildNarrowInputView({Key? key}) {
    return SingleChildScrollView(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FadeAnimation(
              delay: const Duration(milliseconds: 100),
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "Find The Perfect Filter",
                      textAlign: TextAlign.center,
                      style: CostaTextStyle.subtitle1.copyWith(color: deepRed),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your water test parameters below to get the best filter recommendation",
                      textAlign: TextAlign.center,
                      style: CostaTextStyle.bodyText2.copyWith(color: deepRed),
                    ),
                  ],
                ),
              ),
            ),
            FadeAnimation(
              delay: const Duration(milliseconds: 200),
              child: Form(
                key: _formKey,
                child: InputCard(
                  tempHardnessController: tempHardnessController,
                  totalHardnessController: totalHardnessController,
                  cpdController: cpdController,
                  formKey: _formKey,
                  onSubmit: filterData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build input view (responsive)
  Widget _buildInputView({Key? key}) {
    if (MediaQuery.of(context).size.width >= 600) {
      return _buildWideInputView(key: key);
    } else {
      return _buildNarrowInputView(key: key);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for state changes
    final isLoading = ref.watch(isFilterLoadingProvider);
    final isCalculating = ref.watch(isFilterCalculatingProvider);
    final hasResults = ref.watch(hasFilterResultsProvider);
    
    // Update animation state
    _updateAnimationState(isLoading || isCalculating);
    
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Background container with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [latte, italianPorcelain],
                ),
              ),
            ),
            // Use AnimatedSwitcher for smooth transitions between states
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _getStateWidget(isLoading, isCalculating, hasResults),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to get the correct widget for current state
  Widget _getStateWidget(bool isLoading, bool isCalculating, bool hasResults) {
    // Give each state a unique key to ensure animation runs
    if (isLoading) {
      return _buildLoadingSpinner(key: const ValueKey('loading'));
    } else if (isCalculating) {
      return _buildCalculatingView(key: const ValueKey('calculating'));
    } else if (hasResults) {
      return _buildResultsView(key: const ValueKey('results'));
    } else {
      return _buildInputView(key: const ValueKey('input'));
    }
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    tempHardnessController.dispose();
    totalHardnessController.dispose();
    cpdController.dispose();
    super.dispose();
  }
}
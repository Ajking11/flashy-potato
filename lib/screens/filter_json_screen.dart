import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../widgets/input_card.dart';
import '../widgets/result_card.dart';
import '../widgets/result_card_shimmer.dart';
import '../widgets/fade_animation.dart';
import '../constants.dart';

class FilterJsonScreen extends StatefulWidget {
  final VoidCallback onDashboardPressed;

  const FilterJsonScreen({super.key, required this.onDashboardPressed});

  @override
  State<FilterJsonScreen> createState() => _FilterJsonScreenState();
}

class _FilterJsonScreenState extends State<FilterJsonScreen>
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
    
    // Check if we need to start the animation (deferred to didChangeDependencies)
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Control animation based on provider state
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    _updateAnimationState(filterProvider.isLoading || filterProvider.isCalculating);
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
      await Provider.of<FilterProvider>(context, listen: false)
          .getFilterRecommendation(tempHardness, totalHardness, cpd);
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
      centerTitle: true,
      // Use the onDashboardPressed callback from the parent for the back button
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onDashboardPressed,
      ),
    );
  }

  // Custom loading spinner with Costa branding
  Widget _buildLoadingSpinner() {
    return Center(
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
  Widget _buildCalculatingView() {
    return SingleChildScrollView(
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
  Widget _buildResultsView(FilterProvider filterProvider) {
    // Get user input values as integers
    final tempHardness = int.tryParse(tempHardnessController.text) ?? 0;
    final totalHardness = int.tryParse(totalHardnessController.text) ?? 0;
    final cpd = int.tryParse(cpdController.text) ?? 0;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FadeAnimation(
        child: ResultCard(
          filteredData: filterProvider.filteredData!,
          filterSize: filterProvider.filterSize!,
          bypass: filterProvider.bypass!,
          capacity: filterProvider.capacity!,
          tempHardness: tempHardness,
          totalHardness: totalHardness,
          cpd: cpd,
          showExpandedDetails: filterProvider.showExpandedDetails,
          toggleExpandedDetails: () {
            filterProvider.toggleExpandedDetails();
          },
          onNewSearch: () {
            filterProvider.resetSearch();
          },
        ),
      ),
    );
  }

  // Build wide screen input view
  Widget _buildWideInputView() {
    return Row(
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
                    Icon(
                      Icons.filter_alt_outlined,
                      size: 80,
                      color: costaRed.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Enter your water parameters to find the right filter",
                      textAlign: TextAlign.center,
                      style: CostaTextStyle.subtitle2.copyWith(
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
  Widget _buildNarrowInputView() {
    return SingleChildScrollView(
      child: Padding(
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
    );
  }

  // Build input view (responsive)
  Widget _buildInputView() {
    if (MediaQuery.of(context).size.width >= 600) {
      return _buildWideInputView();
    } else {
      return _buildNarrowInputView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Background container (doesn't need to rebuild)
            Container(
              decoration: const BoxDecoration(
                color: latte,
              ),
            ),
            // Only use Consumer for parts that need to react to state changes
            Consumer<FilterProvider>(
              builder: (context, filterProvider, child) {
                // Update animation state when provider state changes
                _updateAnimationState(filterProvider.isLoading || filterProvider.isCalculating);
                
                // Choose the appropriate view based on state
                if (filterProvider.isLoading) {
                  return _buildLoadingSpinner();
                } else if (filterProvider.isCalculating) {
                  return _buildCalculatingView();
                } else if (filterProvider.hasResults) {
                  return _buildResultsView(filterProvider);
                } else {
                  return _buildInputView();
                }
              },
            ),
          ],
        ),
      ),
    );
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
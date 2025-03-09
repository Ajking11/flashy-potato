import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../providers/filter_provider.dart';
import '../widgets/input_card.dart';
import '../widgets/result_card.dart';
import '../widgets/result_card_shimmer.dart';
import '../widgets/fade_animation.dart';
import '../constants.dart';

class FilterJsonScreen extends StatefulWidget {
  const FilterJsonScreen({super.key});
  @override
  State<FilterJsonScreen> createState() => _FilterJsonScreenState();
}

class _FilterJsonScreenState extends State<FilterJsonScreen> with SingleTickerProviderStateMixin {
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
    // Initialize loading animation controller
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    // Data is already loaded via the FilterProvider.initialize() method in main.dart
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
    // Replace the existing leading widget with a back button
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  );
}

  // Helper function that returns the Container with the cup icon
  /*
  Widget _buildAppBarIcon(String assetPath) {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffF7F8F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        assetPath,
        height: 20,
        width: 20,
        semanticsLabel: 'Costa Coffee cup icon',
      ),
    );
  }
*/

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

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        Widget content;
        
        // Get user input values as integers
        final tempHardness = int.tryParse(tempHardnessController.text) ?? 0;
        final totalHardness = int.tryParse(totalHardnessController.text) ?? 0;
        final cpd = int.tryParse(cpdController.text) ?? 0;
        
        // Loading state
        if (filterProvider.isLoading) {
          content = _buildLoadingSpinner();
        } 
        // Calculating state
        else if (filterProvider.isCalculating) {
          content = SingleChildScrollView(
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
        // Have results? (on any screen size)
        else if (filterProvider.hasResults) {
          content = SingleChildScrollView(
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
        // No results yet - show input form (with responsive layout)
        else if (MediaQuery.of(context).size.width >= 600) {
          // Wide screen layout
          content = Row(
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
        } else {
          // Mobile layout
          content = SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeAnimation(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputCard(
                        tempHardnessController: tempHardnessController,
                        totalHardnessController: totalHardnessController,
                        cpdController: cpdController,
                        formKey: _formKey,
                        onSubmit: filterData,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: latte,
                  ),
                ),
                content,
              ],
            ),
          ),
        );
      }
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
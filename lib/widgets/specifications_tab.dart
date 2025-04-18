import 'package:flutter/material.dart';
import '../models/machine_detail.dart';
import '../constants.dart';

class SpecificationsTab extends StatelessWidget {
  final List<Specification> specifications;

  const SpecificationsTab({
    super.key,
    required this.specifications,
  });

  @override
  Widget build(BuildContext context) {
    // Group specifications by category
    final Map<String, List<Specification>> groupedSpecs = {};
    
    for (var spec in specifications) {
      if (!groupedSpecs.containsKey(spec.category)) {
        groupedSpecs[spec.category] = [];
      }
      groupedSpecs[spec.category]!.add(spec);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technical Specifications',
            style: CostaTextStyle.headline2,
          ),
          const SizedBox(height: 8),
          const Text(
            'Detailed technical information for this machine',
            style: CostaTextStyle.bodyText1,
          ),
          const SizedBox(height: 24),
          
          // Display each category of specifications
          ...groupedSpecs.entries.map((entry) => _buildCategorySection(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<Specification> specs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: costaRed,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              category,
              style: CostaTextStyle.subtitle1.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          
          // Specifications list
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: specs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final spec = specs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spec.name,
                      style: CostaTextStyle.bodyText1,
                    ),
                    Text(
                      spec.unit != null ? '${spec.value} ${spec.unit}' : spec.value,
                      style: CostaTextStyle.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
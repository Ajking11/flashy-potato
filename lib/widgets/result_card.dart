import 'package:flutter/material.dart';
import 'expanded_filter_details.dart';
import '../constants.dart';

class ResultCard extends StatelessWidget {
  final List<dynamic> filteredData;
  final String filterSize;
  final String bypass;
  final int capacity;
  final bool showExpandedDetails;
  final VoidCallback toggleExpandedDetails;
  final int tempHardness;
  final int totalHardness;
  final int cpd;
  final VoidCallback? onNewSearch;

  const ResultCard({
    super.key,
    required this.filteredData,
    required this.filterSize,
    required this.bypass,
    required this.capacity,
    required this.showExpandedDetails,
    required this.toggleExpandedDetails,
    required this.tempHardness,
    required this.totalHardness,
    required this.cpd,
    this.onNewSearch,
  });

  // Get the maximum capacity based on filter type
  int getMaxCapacityForFilter() {
    if (filteredData.isEmpty) return 30000;

    final filterType = filteredData[0]['type'];

    // Set appropriate max capacity based on filter type
    if (filterType.toString().toLowerCase().contains('finest')) {
      return 10000;
    } else if (filterType.toString().toLowerCase().contains('fresh')) {
      return 15000;
    } else {
      // Standard filters can go up to about 23000, but round to 25000 for scale
      return 25000;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic maximum capacity based on filter type
    final int maxCapacity = getMaxCapacityForFilter();
    final double capacityPercentage = (capacity / maxCapacity).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...filteredData.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with filter type
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: deepRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filter Type: ${item['type']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter image with enhanced styling
                      Container(
                        decoration: BoxDecoration(
                          color: italianPorcelain,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/${filterSize.toLowerCase()}.png',
                          fit: BoxFit.contain,
                          height: 120,
                          semanticLabel: '${item['type']} filter, size $filterSize',
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 120,
                            width: 100,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported,
                                size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Combined specifications section
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: latte.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: costaRed.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Test parameters section
                              _buildSectionTitle('Water Test Results'),
                              _buildSpecRow(Icons.science, 'Temp', tempHardness.toString()),
                              _buildSpecRow(Icons.opacity, 'Total', totalHardness.toString()),
                              _buildSpecRow(Icons.local_cafe, 'CPD', cpd.toString()),

                              const Divider(height: 24, thickness: 1, color: Color(0x40CB6A7F)),

                              // Filter specifications section
                              _buildSectionTitle('Filter Specifications'),
                              _buildSpecRow(Icons.straighten, 'Filter Size', filterSize),
                              _buildSpecRow(Icons.settings, 'Bypass', bypass),
                              _buildSpecRow(Icons.speed, 'Capacity', '$capacity L'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Capacity visualization section - wrapped with RepaintBoundary
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.analytics, color: costaRed, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Filter Capacity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: deepRed,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getCapacityColor(capacityPercentage),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${(capacityPercentage * 100).round()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: capacityPercentage,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getCapacityColor(capacityPercentage),
                              ),
                              minHeight: 12,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '0 L',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  '${maxCapacity ~/ 2} L',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  '$maxCapacity L',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons row (Show More Details + New Search)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show More Details button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: toggleExpandedDetails,
                          icon: Icon(
                            showExpandedDetails
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Colors.white,
                          ),
                          label: Text(
                            showExpandedDetails
                                ? 'Show Less Details'
                                : 'Show More Details',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: costaRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),

                      // Only show New Search button if callback is provided
                      if (onNewSearch != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onNewSearch,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('New Search'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: costaRed,
                              side: const BorderSide(color: costaRed),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Expanded details section
                  if (showExpandedDetails) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: italianPorcelain,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: costaRed.withValues(alpha: 0.3)),
                      ),
                      child: ExpandedFilterDetails(item: item),
                    ),
                  ],
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: deepRed,
        ),
      ),
    );
  }

  // Helper method to build specification rows
  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: costaRed),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: deepRed,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to determine capacity color based on percentage
  Color _getCapacityColor(double percentage) {
    if (percentage < 0.3) {
      return Colors.red;
    } else if (percentage < 0.7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
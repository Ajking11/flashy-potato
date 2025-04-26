import 'package:flutter/material.dart';
import 'expanded_filter_details.dart';
import '../constants.dart';
import '../services/image_service.dart';

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


  @override
  Widget build(BuildContext context) {
    // Check if we're on a small screen
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...filteredData.map((item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with filter type
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: costaRed,
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content section - responsive layout
                isSmallScreen 
                  ? _buildMobileLayout(item)
                  : _buildDesktopLayout(item),

                const SizedBox(height: 16),

                // More/Less Details Button - implemented as a text button for subtlety
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton.icon(
                      onPressed: toggleExpandedDetails,
                      icon: Icon(
                        showExpandedDetails
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: costaRed,
                        size: 18,
                      ),
                      label: Text(
                        showExpandedDetails
                            ? 'Show Less Details'
                            : 'Show More Details',
                        style: const TextStyle(
                          color: costaRed,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      ),
                    ),
                  ),
                ),

                // Expanded details section
                if (showExpandedDetails) ...[  
                  const SizedBox(height: 16),
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
            )),
          ],
        ),
      ),
    );
  }

  // Build desktop-specific layout (side-by-side)
  Widget _buildDesktopLayout(dynamic item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter image
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
          child: ImageService().loadAssetImage(
            assetPath: 'assets/images/${filterSize.toLowerCase()}.png',
            fit: BoxFit.contain,
            height: 120,
            errorWidget: (context, error, stackTrace) => Container(
              height: 120,
              width: 80,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported,
                  size: 30, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Specifications section
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
                Row(
                  children: [
                    Expanded(
                      child: _buildSpecRow(Icons.science, 'Temp', '$tempHardness°dH'),
                    ),
                    Expanded(
                      child: _buildSpecRow(Icons.opacity, 'Total', '$totalHardness°dH'),
                    ),
                    Expanded(
                      child: _buildSpecRow(Icons.local_cafe, 'CPD', cpd.toString()),
                    ),
                  ],
                ),

                const Divider(height: 24, thickness: 1, color: Color(0x20CB6A7F)),

                // Filter specifications section
                _buildSectionTitle('Filter Specifications'),
                Row(
                  children: [
                    Expanded(
                      child: _buildSpecRow(Icons.straighten, 'Size', filterSize),
                    ),
                    Expanded(
                      child: _buildSpecRow(Icons.settings, 'Bypass', bypass),
                    ),
                  ],
                ),
                _buildSpecRow(Icons.local_cafe_outlined, 'Capacity', '$capacity L'),
                
                // Filter capacity note
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: italianPorcelain,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: costaRed.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: costaRed.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Filter capacity varies based on water usage. Replace filter when indicated by machine or every 3-6 months.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build mobile-specific layout (stacked)
  Widget _buildMobileLayout(dynamic item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Center the filter image
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
            padding: const EdgeInsets.all(12),
            child: ImageService().loadAssetImage(
              assetPath: 'assets/images/${filterSize.toLowerCase()}.png',
              fit: BoxFit.contain,
              height: 120,
              errorWidget: (context, error, stackTrace) => Container(
                height: 120,
                width: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported,
                    size: 30, color: Colors.grey),
              ),
            ),
          ),
        ),

        // Water test results
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: latte.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: costaRed.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Water Test Results'),
              Row(
                children: [
                  Expanded(
                    child: _buildSpecRow(Icons.science, 'Temp', '$tempHardness°dH'),
                  ),
                  Expanded(
                    child: _buildSpecRow(Icons.opacity, 'Total', '$totalHardness°dH'),
                  ),
                ],
              ),
              _buildSpecRow(Icons.local_cafe, 'CPD', cpd.toString()),
              
              const Divider(height: 16, thickness: 1, color: Color(0x20CB6A7F)),
              
              _buildSectionTitle('Filter Specifications'),
              Row(
                children: [
                  Expanded(
                    child: _buildSpecRow(Icons.straighten, 'Size', filterSize),
                  ),
                  Expanded(
                    child: _buildSpecRow(Icons.settings, 'Bypass', bypass),
                  ),
                ],
              ),
              _buildSpecRow(Icons.local_cafe_outlined, 'Capacity', '$capacity L'),
              
              // Filter capacity note
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: italianPorcelain,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: costaRed.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: costaRed.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Filter capacity varies based on water usage. Replace filter when indicated by machine.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: costaRed),
          const SizedBox(width: 4),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: deepRed,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
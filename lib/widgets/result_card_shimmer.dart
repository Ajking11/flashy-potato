import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

class ResultCardShimmer extends StatelessWidget {
  const ResultCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Header shimmer
            ShimmerLoading(
              height: 50,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 16),
            
            // Content shimmer
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                ShimmerLoading(
                  width: 100,
                  height: 120,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 20),
                
                // Details placeholder
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(height: 20),
                      SizedBox(height: 12),
                      ShimmerLoading(height: 16),
                      SizedBox(height: 8),
                      ShimmerLoading(height: 16),
                      SizedBox(height: 8),
                      ShimmerLoading(height: 16),
                      SizedBox(height: 16),
                      ShimmerLoading(height: 20),
                      SizedBox(height: 12),
                      ShimmerLoading(height: 16),
                      SizedBox(height: 8),
                      ShimmerLoading(height: 16),
                      SizedBox(height: 8),
                      ShimmerLoading(height: 16),
                    ],
                  ),
                ),
              ],
            ),
            
            // Capacity visualization shimmer
            const SizedBox(height: 24),
            ShimmerLoading(
              height: 80,
              borderRadius: BorderRadius.circular(8),
            ),
            
            // Button shimmer
            const SizedBox(height: 16),
            ShimmerLoading(
              height: 48,
              borderRadius: BorderRadius.circular(25),
            ),
          ],
        ),
      ),
    );
  }
}
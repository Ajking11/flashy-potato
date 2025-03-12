import 'package:flutter/material.dart';
import '../constants.dart';

class ExpandedFilterDetails extends StatelessWidget {
  final dynamic item;
  const ExpandedFilterDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.build, 'Installation Instructions'),
        const SizedBox(height: 12),
        _buildInstructionItem('Replace filter when capacity is reached or every 12 months'),
        _buildInstructionItem('Flush the new filter before installation'),
        _buildInstructionItem('Ensure proper installation to avoid leaks'),
        _buildInstructionItem('Monitor water quality regularly'),
        
        const SizedBox(height: 20),
        
        _buildSectionHeader(Icons.star, 'Filter Benefits'),
        const SizedBox(height: 12),
        _buildBenefitItem('Reduces limescale build-up in your machine'),
        _buildBenefitItem('Improves taste and aroma of coffee'),
        _buildBenefitItem('Extends the life of your coffee machine'),
        _buildBenefitItem('Ensures consistent brewing quality'),
      ],
    );
  }
  
  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: costaRed),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 16,
            color: deepRed,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.arrow_right,
              size: 16,
              color: deepRed,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle_outline,
              size: 16,
              color: costaRed,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
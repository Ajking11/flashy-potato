import 'package:flutter/material.dart';
import '../constants.dart';

class ExpandedFilterDetails extends StatefulWidget {
  final dynamic item;
  const ExpandedFilterDetails({super.key, required this.item});

  @override
  State<ExpandedFilterDetails> createState() => _ExpandedFilterDetailsState();
}

class _ExpandedFilterDetailsState extends State<ExpandedFilterDetails> with SingleTickerProviderStateMixin {
  // Animation controller for staggered animations
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  final int _totalItems = 8; // Total number of animated items

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create staggered animations for each item
    _animations = List.generate(_totalItems, (index) {
      // Ensure interval values are between 0.0 and 1.0
      final start = (index * 0.1).clamp(0.0, 0.9);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.build, 'Installation Instructions'),
        const SizedBox(height: 12),
        _buildAnimatedInstructionItem(
          'Replace filter when capacity is reached or every 12 months', 
          _animations[0]
        ),
        _buildAnimatedInstructionItem(
          'Flush the new filter before installation', 
          _animations[1]
        ),
        _buildAnimatedInstructionItem(
          'Ensure proper installation to avoid leaks', 
          _animations[2]
        ),
        _buildAnimatedInstructionItem(
          'Monitor water quality regularly', 
          _animations[3]
        ),
        
        const SizedBox(height: 20),
        
        _buildSectionHeader(Icons.star, 'Filter Benefits'),
        const SizedBox(height: 12),
        _buildAnimatedBenefitItem(
          'Reduces limescale build-up in your machine', 
          _animations[4]
        ),
        _buildAnimatedBenefitItem(
          'Improves taste and aroma of coffee', 
          _animations[5]
        ),
        _buildAnimatedBenefitItem(
          'Extends the life of your coffee machine', 
          _animations[6]
        ),
        _buildAnimatedBenefitItem(
          'Ensures consistent brewing quality', 
          _animations[7]
        ),
        
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _animationController.value,
                backgroundColor: costaRed.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(costaRed),
                minHeight: 4,
              ),
            );
          },
        ),
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
  
  Widget _buildAnimatedInstructionItem(String text, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: _buildInstructionItem(text),
          ),
        );
      },
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
  
  Widget _buildAnimatedBenefitItem(String text, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - animation.value), 0),
          child: Opacity(
            opacity: animation.value,
            child: _buildBenefitItem(text),
          ),
        );
      },
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
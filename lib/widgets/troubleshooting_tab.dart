import 'package:flutter/material.dart';
import '../models/machine_detail.dart';
import '../constants.dart';

class TroubleshootingTab extends StatefulWidget {
  final List<TroubleshootingGuide> guides;

  const TroubleshootingTab({
    super.key,
    required this.guides,
  });

  @override
  State<TroubleshootingTab> createState() => _TroubleshootingTabState();
}

class _TroubleshootingTabState extends State<TroubleshootingTab> {
  int? _expandedGuideIndex;
  int? _expandedSolutionIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Troubleshooting Guides',
            style: CostaTextStyle.headline2,
          ),
          const SizedBox(height: 8),
          const Text(
            'Solutions for common issues with this machine',
            style: CostaTextStyle.bodyText1,
          ),
          const SizedBox(height: 24),
          
          // List of troubleshooting guides
          ...List.generate(
            widget.guides.length,
            (index) => _buildGuideCard(widget.guides[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(TroubleshootingGuide guide, int guideIndex) {
    final isExpanded = _expandedGuideIndex == guideIndex;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Guide header (always shown)
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedGuideIndex = null;
                  _expandedSolutionIndex = null;
                } else {
                  _expandedGuideIndex = guideIndex;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: accentRed,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.issue,
                          style: CostaTextStyle.subtitle1,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: costaRed,
                  ),
                ],
              ),
            ),
          ),
          
          // Guide details (shown when expanded)
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.description,
                    style: CostaTextStyle.bodyText1,
                  ),
                  const SizedBox(height: 16),
                  
                  // Solutions header
                  const Text(
                    'Possible Solutions',
                    style: CostaTextStyle.subtitle2,
                  ),
                  const SizedBox(height: 12),
                  
                  // Solutions list
                  ...List.generate(
                    guide.solutions.length,
                    (index) => _buildSolutionItem(
                      guide.solutions[index],
                      guideIndex,
                      index,
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

  Widget _buildSolutionItem(
    TroubleshootingSolution solution,
    int guideIndex,
    int solutionIndex,
  ) {
    final isExpanded = _expandedGuideIndex == guideIndex && 
                       _expandedSolutionIndex == solutionIndex;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Solution header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedSolutionIndex = null;
                } else {
                  _expandedSolutionIndex = solutionIndex;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(solution.priority),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      solution.priority.toString(),
                      style: CostaTextStyle.bodyText2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      solution.solution,
                      style: CostaTextStyle.bodyText1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: costaRed,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Solution steps
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Steps list
                  ...List.generate(
                    solution.steps.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}.',
                            style: CostaTextStyle.bodyText1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: costaRed,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              solution.steps[index],
                              style: CostaTextStyle.bodyText1,
                            ),
                          ),
                        ],
                      ),
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

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
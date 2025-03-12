import 'package:flutter/material.dart';
import '../models/machine_detail.dart';
import '../constants.dart';

class MaintenanceTab extends StatefulWidget {
  final List<MaintenanceProcedure> procedures;

  const MaintenanceTab({
    super.key,
    required this.procedures,
  });

  @override
  State<MaintenanceTab> createState() => _MaintenanceTabState();
}

class _MaintenanceTabState extends State<MaintenanceTab> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Maintenance Procedures',
            style: CostaTextStyle.headline2,
          ),
          const SizedBox(height: 8),
          Text(
            'Regular maintenance ensures optimal performance and longevity',
            style: CostaTextStyle.bodyText1,
          ),
          const SizedBox(height: 24),
          
          // List of maintenance procedures
          ...List.generate(
            widget.procedures.length,
            (index) => _buildProcedureCard(widget.procedures[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildProcedureCard(MaintenanceProcedure procedure, int index) {
    final isExpanded = _expandedIndex == index;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Procedure header (always shown)
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: costaRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.build_outlined,
                      color: costaRed,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          procedure.title,
                          style: CostaTextStyle.subtitle1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Frequency: ${procedure.frequency}',
                          style: CostaTextStyle.bodyText2,
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
          
          // Procedure details (shown when expanded)
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    procedure.description,
                    style: CostaTextStyle.bodyText1,
                  ),
                  const SizedBox(height: 16),
                  
                  // Steps header
                  Row(
                    children: [
                      const Icon(Icons.list, color: costaRed, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Steps',
                        style: CostaTextStyle.subtitle2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Steps list
                  ...procedure.steps.map((step) => _buildStepItem(step)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem(MaintenanceStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: costaRed,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              step.order.toString(),
              style: CostaTextStyle.bodyText2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Step instruction
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.instruction,
                  style: CostaTextStyle.bodyText1,
                ),
                
                // Optional step image
                if (step.imagePath != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      step.imagePath!,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
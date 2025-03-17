import 'package:flutter/material.dart';
import '../models/machine_detail.dart';
import '../constants.dart';

class PartsDiagramTab extends StatefulWidget {
  final List<PartDiagram> diagrams;

  const PartsDiagramTab({
    super.key,
    required this.diagrams,
  });

  @override
  State<PartsDiagramTab> createState() => _PartsDiagramTabState();
}

class _PartsDiagramTabState extends State<PartsDiagramTab> {
  int _selectedDiagramIndex = 0;
  String? _selectedPartNumber;

  @override
  void initState() {
    super.initState();
    // Initialize with -1 if empty, or 0 if there are items
    _selectedDiagramIndex = widget.diagrams.isNotEmpty ? 0 : -1;
  }

  @override
  Widget build(BuildContext context) {
    // Early return if no diagrams are available
    if (widget.diagrams.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parts Diagrams',
              style: CostaTextStyle.headline2,
            ),
            const SizedBox(height: 8),
            Text(
              'No diagrams available for this machine',
              style: CostaTextStyle.bodyText1,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parts Diagrams',
            style: CostaTextStyle.headline2,
          ),
          const SizedBox(height: 8),
          Text(
            'Diagrams and part information for service and repair',
            style: CostaTextStyle.bodyText1,
          ),
          const SizedBox(height: 24),
          
          // Diagram selector
          _buildDiagramSelector(),
          const SizedBox(height: 24),
          
          // Current diagram
          _buildCurrentDiagram(),
          const SizedBox(height: 20),
          
          // Parts table
          _buildPartsTable(),
        ],
      ),
    );
  }

  Widget _buildDiagramSelector() {
    // Guard against empty diagrams list
    if (widget.diagrams.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.diagrams.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(widget.diagrams[index].title),
              selected: _selectedDiagramIndex == index,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedDiagramIndex = index;
                    _selectedPartNumber = null;
                  });
                }
              },
              selectedColor: costaRed,
              labelStyle: TextStyle(
                color: _selectedDiagramIndex == index ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentDiagram() {
    // Guard against empty diagrams list
    if (widget.diagrams.isEmpty) {
      return Container(
        decoration: cardDecoration,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'No diagrams available',
              style: CostaTextStyle.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final currentDiagram = widget.diagrams[_selectedDiagramIndex];
    
    return Container(
      decoration: cardDecoration,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            currentDiagram.title,
            style: CostaTextStyle.subtitle1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Diagram image with placeholder
          AspectRatio(
            aspectRatio: 4/3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  currentDiagram.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Diagram image not available',
                          style: CostaTextStyle.bodyText1.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartsTable() {
    // Guard against empty diagrams list
    if (widget.diagrams.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentDiagram = widget.diagrams[_selectedDiagramIndex];
    
    return Container(
      decoration: cardDecoration,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: costaRed,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              'Parts List',
              style: CostaTextStyle.subtitle1.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Check if parts list is empty
          if (currentDiagram.parts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No parts available for this diagram',
                  style: CostaTextStyle.bodyText1.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            )
          else ...[
            // Table header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Part Number',
                      style: CostaTextStyle.bodyText2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      style: CostaTextStyle.bodyText2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Parts list
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: currentDiagram.parts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final part = currentDiagram.parts[index];
                final isSelected = part.partNumber == _selectedPartNumber;
                
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedPartNumber = null;
                      } else {
                        _selectedPartNumber = part.partNumber;
                      }
                    });
                  },
                  child: Container(
                    color: isSelected ? costaRed.withValues(alpha: 0.1) : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Part info (always visible)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  part.partNumber,
                                  style: CostaTextStyle.bodyText1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? costaRed : null,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  part.name,
                                  style: CostaTextStyle.bodyText1,
                                ),
                              ),
                              Icon(
                                isSelected ? Icons.expand_less : Icons.expand_more,
                                color: costaRed,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        
                        // Part description (when expanded)
                        if (isSelected) ...[
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description:',
                                  style: CostaTextStyle.bodyText2.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  part.description,
                                  style: CostaTextStyle.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
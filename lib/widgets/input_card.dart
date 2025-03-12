import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class InputCard extends StatelessWidget {
  final TextEditingController tempHardnessController;
  final TextEditingController totalHardnessController;
  final TextEditingController cpdController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  const InputCard({
    super.key,
    required this.tempHardnessController,
    required this.totalHardnessController,
    required this.cpdController,
    required this.formKey,
    required this.onSubmit,
  });

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
          // Header section with help button
          Row(
          children: [
          // Header text
          const Icon(Icons.water_drop, color: deepRed),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Water Parameters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: deepRed,
              ),
            ),
          ),

          // Help button
          Tooltip(
            message: 'How to use this form',
            child: InkWell(
              onTap: () => _showHelpDialog(
                context,
                'How to Use',
                'Enter your water test results and cups per day to find the recommended filter. Tap the help icon (?) next to each field for detailed information.',
                null,
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: italianPorcelain,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: costaRed.withValues(alpha: 0.3)),
                ),
                child: const Icon(
                  Icons.help_outline,
                  size: 18,
                  color: costaRed,
                ),
              ),
            ),
          ),
          ],
        ),

        const Divider(height: 24, thickness: 1, color: Color(0xFFEEEEEE)),

        // Using RepaintBoundary for each input field group
        // since they are updated independently
        RepaintBoundary(
          child: _buildInputFieldGroup(
            context,
            'Temporary Hardness',
            Icons.science,
            tempHardnessController,
            'Temp hardness value (CH)',
            'Temp (CH) – Limescale Test Indicator: The water should develop a golden yellow colour. Usage: When testing for water scale, count the drops based on the TEMP tester.',
          ),
        ),

        const SizedBox(height: 20),

        RepaintBoundary(
          child: _buildInputFieldGroup(
            context,
            'Total Hardness',
            Icons.opacity,
            totalHardnessController,
            'Total hardness value (TH)',
            'Total (TH) – All Other Minerals Test Indicator: The water should turn British racing green. Usage: For minerals other than scale, count the drops using the TOTAL tester.',
          ),
        ),

        const SizedBox(height: 20),

        RepaintBoundary(
          child: _buildInputFieldGroup(
            context,
            'Cups Per Day',
            Icons.local_cafe,
            cpdController,
            'Daily coffee cup volume',
            'Cups per day refers to the average number of cups of coffee you prepare daily. This information can be found in solarvista under the equipment tab.',
            explanationImage: 'assets/images/svcpd.png',
          ),
        ),

        const SizedBox(height: 28),

        // Find Filter Button
        Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: costaRed.withValues(alpha: 0.3),
    blurRadius: 8,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    width: double.infinity,
    child: ElevatedButton.icon(
    onPressed: onSubmit,
    icon: const Icon(Icons.search, color: Colors.white),
    label: const Text(
    'Find Filter',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
      style: ElevatedButton.styleFrom(
        backgroundColor: costaRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
        ),
              ],
          ),
        ),
    );
  }

  // Build a group containing a label, icon, and input field
  Widget _buildInputFieldGroup(
      BuildContext context,
      String label,
      IconData icon,
      TextEditingController controller,
      String hint,
      String explanation, {
        String? explanationImage,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label with icon
        Row(
          children: [
            Icon(icon, size: 16, color: costaRed),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: deepRed,
              ),
            ),
            const Spacer(),
            // Help button
            GestureDetector(
              onTap: () => _showHelpDialog(context, label, explanation, explanationImage),
              child: Container(
                decoration: BoxDecoration(
                  color: costaRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.help_outline,
                  size: 16,
                  color: costaRed,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Input field with styling
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: costaRed, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
              return 'Enter a valid number greater than 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Show help dialog with improved styling and const widgets
  void _showHelpDialog(BuildContext context, String label, String explanation, String? explanationImage) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog header
                Row(
                  children: [
                    const Icon(Icons.help_outline, color: costaRed),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$label Help',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: deepRed,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 1),

                // Dialog content
                Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF333333),
                  ),
                ),
                if (explanationImage != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      explanationImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],

                // Dialog button
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: costaRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
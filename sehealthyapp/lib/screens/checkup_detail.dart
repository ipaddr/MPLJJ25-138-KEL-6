import 'package:flutter/material.dart';
import 'edit_checkup_detail.dart';

class CheckupDetailScreen extends StatelessWidget {
  const CheckupDetailScreen({super.key});

  final String testTitle =
      'Blood Test Results'; // Bisa diganti sesuai pilihan user
  final String testLabel = 'Glucose'; // Label (misal: Glucose, Cholesterol)
  final String testValue = '105 mg/dL'; // Nilai hasil

  void _onEditPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditCheckupDetailScreen()),
    );
  }

  void _onDeletePressed(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this record?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Deleted')));
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildVitalCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details"), leading: const BackButton()),
      backgroundColor: const Color(0xFFE9F3FF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vital Signs
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildVitalCard(
                  "Heart Rate",
                  "72 bpm",
                  Icons.favorite,
                  Colors.red,
                ),
                _buildVitalCard(
                  "Blood Pressure",
                  "120/80",
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildVitalCard(
                  "Temperature",
                  "98.6°F",
                  Icons.thermostat,
                  Colors.orange,
                ),
                _buildVitalCard(
                  "Oxygen",
                  "98%",
                  Icons.bubble_chart,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Blood Test Results (dynamic title & value)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testTitle,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(testLabel, style: const TextStyle(fontSize: 16)),
                      Text(
                        testValue,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Doctor Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Dr. Abdul Hafiz',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Rumah Sakit Umum',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'All vital signs and blood test results are within normal range. '
                    'Slight elevation in glucose levels, but not concerning. '
                    'Recommend regular exercise and balanced diet. Follow-up in 6 months.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onDeletePressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onEditPressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Edit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

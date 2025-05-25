import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'checkup_detail.dart';
import '../dashboard_screen.dart';
import '../health_history/add_health_history.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, dynamic>? upcomingCheckup;

  @override
  void initState() {
    super.initState();
    fetchUpcomingCheckup();
  }

  Future<void> fetchUpcomingCheckup() async {
    try {
      final now = Timestamp.now();
      final query =
          await FirebaseFirestore.instance
              .collection('checkups')
              .where('date', isGreaterThanOrEqualTo: now)
              .orderBy('date')
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          upcomingCheckup = query.docs.first.data();
        });
      }
    } catch (e) {
      print('Error fetching upcoming checkup: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Health History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddHealthHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Checkup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (upcomingCheckup != null)
              _buildUpcomingCheckupCard(upcomingCheckup!)
            else
              const Text(
                'No upcoming checkups',
                style: TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 24),
            // Checkup Card manual (boleh disesuaikan lebih lanjut)
            _buildCheckupCard(
              context: context,
              title: 'Regular Checkup',
              date: 'Apr 15, 2025',
              data: {'Blood Pressure': '120/80 mmHg', 'Heart Rate': '72 bpm'},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCheckupCard(Map<String, dynamic> checkupData) {
    final title = checkupData['checkupType'] ?? 'Checkup';
    final timestamp = checkupData['date'] as Timestamp;
    final dateFormatted = DateFormat('MMM d, yyyy').format(timestamp.toDate());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDEEFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/img5.png',
                width: 20,
                height: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(dateFormatted, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'Soon',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckupCard({
    required BuildContext context,
    required String title,
    required String date,
    required Map<String, String> data,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 4,
            children:
                data.entries
                    .map(
                      (e) => Text(
                        '${e.key}: ${e.value}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckupDetailScreen(),
                  ),
                );
              },
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}

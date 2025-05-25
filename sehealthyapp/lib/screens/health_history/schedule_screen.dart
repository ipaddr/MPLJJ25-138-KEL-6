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

  Future<List<QueryDocumentSnapshot>> getHealthHistory() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('health_history')
            .orderBy('createdAt', descending: true)
            .get();
    return snapshot.docs;
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
            const Text(
              'Health History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<QueryDocumentSnapshot>>(
              future: getHealthHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'No health history data',
                    style: TextStyle(color: Colors.grey),
                  );
                }

                final historyDocs = snapshot.data!;

                return Column(
                  children:
                      historyDocs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final checkupType = data['checkupType'] ?? 'Unknown';
                        final timestamp = data['createdAt'] as Timestamp;
                        final date = DateFormat(
                          'MMM d, yyyy',
                        ).format(timestamp.toDate());

                        final detailData = {
                          'Blood Pressure': data['bloodPressure'] ?? '-',
                          'Heart Rate': data['heartRate'] ?? '-',
                          'Glucose': data['glucose'] ?? '-',
                          'Oxygen': data['oxygen'] ?? '-',
                          'Temperature': data['temperature'] ?? '-',
                        };

                        return _buildCheckupCard(
                          context: context,
                          documentId: doc.id, // kirim ID dokumen Firestore
                          title: checkupType,
                          date: date,
                          data: Map<String, String>.from(detailData),
                        );
                      }).toList(),
                );
              },
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
    required String documentId, // parameter baru
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
          Table(
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
            children:
                data.entries.map((entry) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${entry.key}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          ': ${entry.value}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CheckupDetailScreen(documentId: documentId),
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

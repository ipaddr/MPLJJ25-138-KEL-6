import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../health_history/checkup_detail_edit.dart';

class CheckupDetailScreen extends StatefulWidget {
  final String documentId;

  const CheckupDetailScreen({super.key, required this.documentId});

  @override
  State<CheckupDetailScreen> createState() => _CheckupDetailScreenState();
}

class _CheckupDetailScreenState extends State<CheckupDetailScreen> {
  late Future<DocumentSnapshot> _checkupFuture;

  @override
  void initState() {
    super.initState();
    _loadCheckup();
  }

  void _loadCheckup() {
    _checkupFuture =
        FirebaseFirestore.instance
            .collection('health_history')
            .doc(widget.documentId)
            .get();
  }

  void _onEditPressed(BuildContext context, Map<String, dynamic> data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditCheckupDetailScreen(
              documentId: widget.documentId,
              initialData: data,
            ),
      ),
    );

    if (result != null) {
      await FirebaseFirestore.instance
          .collection('health_history')
          .doc(result['documentId'])
          .update(result);

      setState(() {
        _loadCheckup();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkup updated successfully!')),
      );
    }
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
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('health_history')
                      .doc(widget.documentId)
                      .delete();
                  Navigator.pop(context); // tutup dialog
                  Navigator.pop(context); // kembali ke halaman sebelumnya
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
      appBar: AppBar(title: const Text("Health Detail")),
      backgroundColor: const Color(0xFFE9F3FF),
      body: FutureBuilder<DocumentSnapshot>(
        future: _checkupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          String heartRate = data['heartRate'] ?? 'N/A';
          String bloodPressure = data['bloodPressure'] ?? 'N/A';
          String temperature = data['temperature'] ?? 'N/A';
          String oxygen = data['oxygen'] ?? 'N/A';
          String glucose = data['glucose'] ?? 'N/A';
          String doctorName = data['doctorName'] ?? 'Unknown';
          String hospitalName = data['hospitalName'] ?? 'Unknown';
          String description = data['description'] ?? '-';
          String checkupType = data['checkupType'] ?? 'Blood Test';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildVitalCard(
                      "Heart Rate",
                      "$heartRate bpm",
                      Icons.favorite,
                      Colors.red,
                    ),
                    _buildVitalCard(
                      "Blood Pressure",
                      bloodPressure,
                      Icons.water_drop,
                      Colors.blue,
                    ),
                    _buildVitalCard(
                      "Temperature",
                      "$temperature °C",
                      Icons.thermostat,
                      Colors.orange,
                    ),
                    _buildVitalCard(
                      "Oxygen",
                      "$oxygen%",
                      Icons.bubble_chart,
                      Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Glukosa
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
                        "$checkupType Results",
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Glucose', style: TextStyle(fontSize: 16)),
                          Text(
                            "$glucose mg/dL",
                            style: const TextStyle(
                              fontSize: 15,
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
                // Dokter dan Rumah Sakit
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
                            children: [
                              Text(
                                'Dr. $doctorName',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                hospitalName,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(description, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                const Spacer(),
                // Tombol Delete dan Edit
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
                        onPressed: () => _onEditPressed(context, data),
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
          );
        },
      ),
    );
  }
}

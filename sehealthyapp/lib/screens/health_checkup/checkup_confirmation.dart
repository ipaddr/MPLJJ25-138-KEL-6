import 'package:flutter/material.dart';

class CheckupConfirmationPage extends StatelessWidget {
  final String fullName;
  final String id;
  final String dob;
  final String checkupType;
  final String facility;
  final String date;

  const CheckupConfirmationPage({
    super.key,
    required this.fullName,
    required this.id,
    required this.dob,
    required this.checkupType,
    required this.facility,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Registration Confirmation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFE7F0FF),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Appointment Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Booking ID: #HC25498',
                          style: TextStyle(color: Colors.blue),
                        ),
                        const SizedBox(height: 16),
                        infoRow(Icons.person_outline, 'Patient Name', fullName),
                        infoRow(Icons.credit_card, 'National ID', id),
                        infoRow(Icons.cake_outlined, 'Date of Birth', dob),
                        infoRow(
                          Icons.medical_services_outlined,
                          'Checkup Type',
                          checkupType,
                        ),
                        infoRow(
                          Icons.local_hospital,
                          'Health Facility',
                          facility,
                        ),
                        infoRow(Icons.calendar_today_outlined, 'Date', date),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _appointments = [
    {
      'name': 'Abdul Hafiz',
      'consultation': 'Blood Pressure Checkup',
      'hospital': 'Rumah Sakit Terpadu',
      'status': 'Pending',
      'statusColor': Colors.orange.shade300,
    },
    {
      'name': 'Mike Peterson',
      'consultation': 'Cardiology Consultation',
      'hospital': 'Rumah Sakit Terpadu',
      'status': 'Confirmed',
      'statusColor': Colors.green.shade300,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/hospital.png'), // Ganti dengan asset/logo rumah sakit
              radius: 18,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Welcome, Rumah Sakit Terpadu!',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () {
                // TODO: Logout logic
              },
            )
          ],
        ),
      ),
      body: _currentIndex == 0 ? _buildAppointments() : _buildEducation(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Education',
          ),
        ],
      ),
    );
  }

  Widget _buildAppointments() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _appointments.length,
      itemBuilder: (context, index) {
        final appt = _appointments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        appt['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: appt['statusColor'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appt['status'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  appt['consultation'],
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.apartment_outlined, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        appt['hospital'],
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigasi ke detail appointment
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEducation() {
    return const Center(
      child: Text(
        'Education content will be here.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

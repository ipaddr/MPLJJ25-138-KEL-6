import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_login.dart';
import 'appointment_detail.dart';
import 'education_material.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> appointments = [
    {
      'name': 'Abdul Hafiz',
      'status': 'Pending',
      'specialty': 'Blood Pressure Checkup',
      'location': 'Rumah Sakit Terpadu',
      'statusColor': Colors.orange.shade100,
      'statusTextColor': Colors.orange.shade700,
      'nationalId': '129383000238293',
      'dob': '13 Feb 2004',
      'preferredDate': '15 April 2025',
    },
    {
      'name': 'Mike Peterson',
      'status': 'Confirmed',
      'specialty': 'Cardiology Consultation',
      'location': 'Rumah Sakit Terpadu',
      'statusColor': Colors.green.shade100,
      'statusTextColor': Colors.green.shade700,
      'nationalId': '987654321098765',
      'dob': '22 Oct 1990',
      'preferredDate': '20 April 2025',
    },
  ];

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildAppointments(),
      EducationMaterialPageBody(), // lihat di bawah, custom widget tanpa scaffold
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/hospital_icon.png'),
              radius: 18,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Welcome, Rumah Sakit Terpadu!',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.logout, color: Colors.red.shade600),
              tooltip: 'Logout',
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: 'Education'),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildAppointments() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final appt = appointments[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                )
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      appt['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: appt['statusColor'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appt['status'],
                        style: TextStyle(
                          color: appt['statusTextColor'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  appt['specialty'],
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_hospital, size: 18, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      appt['location'],
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AppointmentDetailScreen(appointment: appt),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  final List<Map<String, dynamic>> appointments = [
    {
      'name': 'Abdul Hafiz',
      'status': 'Pending',
      'specialty': 'Blood Pressure Checkup',
      'location': 'Rumah Sakit Terpadu',
    },
    {
      'name': 'Mike Peterson',
      'status': 'Confirmed',
      'specialty': 'Cardiology Consultation',
      'location': 'Rumah Sakit Terpadu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/hospital_icon.png'),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Welcome,\nRumah Sakit Terpadu!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.red),
                  onPressed: () {},
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                appointment['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: appointment['status'] == 'Confirmed'
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  appointment['status'],
                                  style: TextStyle(
                                    color: appointment['status'] == 'Confirmed'
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            appointment['specialty'],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.local_hospital, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                appointment['location'],
                                style: TextStyle(color: Colors.grey[600]),
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black87,
                            ),
                            child: Text('View Details'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

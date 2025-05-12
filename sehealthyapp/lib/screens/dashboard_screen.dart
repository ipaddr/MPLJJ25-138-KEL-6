import 'package:flutter/material.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardContent(),
    const ScheduleScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/img4.png'),
                    radius: 24,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Hafiz!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Last check: Today',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 36,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your TB Risk: Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  CardHealthCheckup(),
                  CardTBCScreening(),
                  CardHealthHistory(),
                  CardResources(),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Upcoming Checkup',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFDBEAFE),
                      child: Icon(Icons.monitor_heart, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Blood Pressure',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Apr 15, 2025',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Tomorrow',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.color,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, width: 32, height: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// Card: Health Checkup
class CardHealthCheckup extends StatelessWidget {
  const CardHealthCheckup({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuCard(
      color: const Color(0xFFDBEAFE),
      imagePath: 'assets/images/img5.png',
      title: 'Health Checkup',
      subtitle: 'Schedule your next visit',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CardHealthCheckup()),
        );
      },
    );
  }
}

// Card: TBC Screening
class CardTBCScreening extends StatelessWidget {
  const CardTBCScreening({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuCard(
      color: const Color(0xFFD1FAE5),
      imagePath: 'assets/images/img6.png',
      title: 'TBC Screening',
      subtitle: 'Book screening test',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CardTBCScreening()),
        );
      },
    );
  }
}

// Card: Health History
class CardHealthHistory extends StatelessWidget {
  const CardHealthHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuCard(
      color: const Color(0xFFEDE9FE),
      imagePath: 'assets/images/img7.png',
      title: 'Health History',
      subtitle: 'View your records',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CardHealthHistory()),
        );
      },
    );
  }
}

// Card: Resources
class CardResources extends StatelessWidget {
  const CardResources({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuCard(
      color: const Color(0xFFFEF9C3),
      imagePath: 'assets/images/img8.png',
      title: 'Resources',
      subtitle: 'Learn about health',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CardResources()),
        );
      },
    );
  }
}

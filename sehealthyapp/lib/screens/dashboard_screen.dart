import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'health_history/schedule_screen.dart';
import 'profile_user/profile_screen.dart';
import 'tbs_screening/page_tbc_screening.dart';
import 'health_checkup/page_health_checkup.dart';
import 'resources/page_resources.dart';

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

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  String fullname = 'Loading...';
  Map<String, dynamic>? upcomingCheckup;
  String? photoUrl; // Tambahkan ini

  @override
  void initState() {
    super.initState();
    fetchUserFullname();
    fetchUpcomingCheckup();
    fetchPhotoUrl(); // Tambahkan ini
  }

  Future<void> fetchUserFullname() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        setState(() {
          fullname = doc.data()?['fullName'] ?? 'User';
        });
      }
    } catch (e) {
      setState(() {
        fullname = 'User';
      });
      print('Error fetching fullName: $e');
    }
  }

  Future<void> fetchPhotoUrl() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('biodata')
                .doc(user.uid)
                .get();
        setState(() {
          photoUrl = doc.data()?['photoUrl'];
        });
      }
    } catch (e) {
      print('Error fetching photoUrl: $e');
      setState(() {
        photoUrl = null;
      });
    }
  }

  Future<void> fetchUpcomingCheckup() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
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
        } else {
          setState(() {
            upcomingCheckup = null;
          });
        }
      }
    } catch (e) {
      print('Error fetching checkup: $e');
      setState(() {
        upcomingCheckup = null;
      });
    }
  }

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
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blueAccent,
                    backgroundImage:
                        (photoUrl != null && photoUrl!.isNotEmpty)
                            ? NetworkImage(photoUrl!)
                            : null,
                    child:
                        (photoUrl == null || photoUrl!.isEmpty)
                            ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $fullname!',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5FAFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/img5.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            upcomingCheckup?['checkupType'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            upcomingCheckup?['date'] != null
                                ? DateFormat('MMMM d, y').format(
                                  (upcomingCheckup!['date'] as Timestamp)
                                      .toDate(),
                                )
                                : '-',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1E9FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Soon',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1A73E8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
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

class CardHealthCheckup extends StatelessWidget {
  const CardHealthCheckup({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFADD2FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PageHealthCheckup()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon dalam lingkaran
              Container(
                width: 48,
                height: 41,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F0FB), // abu muda
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
              const SizedBox(height: 20),
              const Text(
                'Health Checkup',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Schedule your next visit',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardTBCScreening extends StatelessWidget {
  const CardTBCScreening({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFC8E6C9), // Hijau muda
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PageTBCScreening()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 41,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9), // hijau lebih muda
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/img6.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'TBC Screening',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Book screening test',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardHealthHistory extends StatelessWidget {
  const CardHealthHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE1BEE7), // Ungu muda
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScheduleScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 41,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E5F5), // ungu lebih muda
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/img7.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Health History',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'View your records',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardResources extends StatelessWidget {
  const CardResources({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF9C4), // Kuning muda
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PageResources()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 41,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDE7), // kuning lebih pucat
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/img8.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Resources',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Learn about health',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'first_screen.dart';
import 'profile_screen_edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    final biodataDoc =
        await FirebaseFirestore.instance.collection('biodata').doc(uid).get();
    if (!biodataDoc.exists) {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = userDoc.data() ?? {};

      final fullName = user.displayName ?? 'User';
      final nik = userData['nik'] ?? '-';
      final bloodType = userData['bloodType'] ?? '-';
      final photoUrl = userData['photoUrl'] ?? '';

      await FirebaseFirestore.instance.collection('biodata').doc(uid).set({
        'nik': nik,
        'bloodType': bloodType,
        'fullName': fullName,
        'photoUrl': photoUrl,
      });

      setState(() {
        _photoUrl = photoUrl;
      });
    } else {
      final data = biodataDoc.data();
      setState(() {
        _photoUrl = data?['photoUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuth.instance.currentUser?.displayName ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6F0FF),
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('biodata')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final nik = data['nik'] ?? '-';
          final bloodType = data['bloodType'] ?? '';

          // Pakai _photoUrl yang sudah di-set di state
          final photoUrl = _photoUrl ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage:
                      photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child:
                      photoUrl.isEmpty
                          ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          )
                          : null,
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Patient ID: #12345',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                infoRow('NIK', nik),
                infoRow('Blood Type', bloodType),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                settingTile(Icons.notifications, 'Notification Preferences'),
                settingTile(Icons.language, 'Language'),
                settingTile(Icons.lock, 'Privacy Settings'),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FirstScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  static Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget settingTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

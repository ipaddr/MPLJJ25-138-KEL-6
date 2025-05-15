import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  @override
  void dispose() {
    _nikController.dispose();
    _bloodTypeController.dispose();
    super.dispose();
  }

  void _onSave() {
    // Logic simpan data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
  }

  void _onCancel() {
    // Logic batal / kembali
    Navigator.pop(context);
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade300),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E7FF), // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            // Profile picture with edit button
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(
                        // Ganti dengan foto profil sebenarnya
                        'https://i.pinimg.com/originals/14/4e/fd/144efdaf52422e3f38e63dd2fc887f07.png',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: () {
                          // Logic edit foto profil
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Name & Patient ID
            const Center(
              child: Text(
                'Abdul Hafiz',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Patient ID: #12345',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Personal Information Header
            const Text(
              'Personal Information',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // NIK Input
            TextField(
              controller: _nikController,
              decoration: InputDecoration(
                hintText: 'Enter your National ID',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black45,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Blood Type Input
            TextField(
              controller: _bloodTypeController,
              decoration: InputDecoration(
                hintText: 'Enter your Blood Type',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black45,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 24),

            // Settings Header
            const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // Settings List
            _buildSettingItem(Icons.notifications, 'Notification Preferences', () {
              // Logic Notification Preferences
            }),
            _buildSettingItem(Icons.language, 'Language', () {
              // Logic Language Settings
            }),
            _buildSettingItem(Icons.shield, 'Privacy Settings', () {
              // Logic Privacy Settings
            }),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Save'),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile tab active
        onTap: (index) {
          // Navigasi tab bottom
          // Contoh:
          // if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          // if (index == 1) Navigator.pushReplacementNamed(context, '/schedule');
          // if (index == 2) {} // Sudah di halaman profile
        },
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

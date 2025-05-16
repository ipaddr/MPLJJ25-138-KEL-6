import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'admin/admin_onboarding.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2FF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: const [
                  Text(
                    'Choose your Role!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please choose the role that suits your needs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            roleCardWithImage(
              imagePath:
                  'assets/images/img2.png', // Gambar untuk masyarakat biasa
              title: 'Masyarakat Biasa',
              subtitle: 'Akses layanan kesehatan untuk umum',
              buttonText: 'Pilih sebagai Masyarakat',
              onPressed: () {
                // Navigasi ke halaman Onboarding
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            roleCardWithImage(
              imagePath:
                  'assets/images/img3.png', // Gambar untuk admin fasilitas kesehatan
              title: 'Admin (Fasilitas Kesehatan)',
              subtitle: 'Kelola layanan kesehatan',
              buttonText: 'Pilih sebagai Admin',
              onPressed: () {
                // Navigasi ke halaman Onboarding
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingAdminScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget roleCardWithImage({
    required String imagePath,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(imagePath, width: 40, height: 40),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2265E9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}

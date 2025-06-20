import 'package:flutter/material.dart';
import '/models/tbc_result_model.dart';
import '/screens/dashboard_screen.dart';
import '/screens/health_checkup/page_health_checkup.dart';

class TBCResultScreen extends StatelessWidget {
  final TBCResultModel tbcResult;

  const TBCResultScreen({super.key, required this.tbcResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F0FE),
        elevation: 0,
        title: const Text(
          'Hasil Skrining TBC',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Card 1: Tingkat Risiko TBC
          _buildRiskLevelCard(),

          // Card 2: Faktor Risiko yang Ditemukan
          _buildRiskFactorsCard(),

          // Card 3: Tindakan yang Disarankan
          _buildRecommendationsCard(),

          const SizedBox(height: 24),

          // Tombol untuk registrasi check-up
          _buildRegisterButton(context),

          const SizedBox(height: 12),

          // Tombol kembali ke homepage
          _buildBackToHomeButton(context),
        ],
      ),
    );
  }

  // Card untuk menampilkan tingkat risiko TBC
  Widget _buildRiskLevelCard() {
    return Card(
      color: tbcResult.getRiskColor(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Row(
              children: [
                Text(
                  tbcResult.getRiskIcon(),
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tingkat Risiko TBC',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Badge tingkat risiko
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getRiskBadgeColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'RISIKO ${tbcResult.riskLevel.toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Deskripsi risiko
            Text(
              tbcResult.riskDescription.isNotEmpty
                  ? tbcResult.riskDescription
                  : 'Berdasarkan jawaban Anda, tingkat risiko TBC Anda adalah ${tbcResult.riskLevel}.',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card untuk menampilkan faktor risiko
  Widget _buildRiskFactorsCard() {
    return Card(
      color: Colors.orange.shade50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Row(
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Faktor Risiko yang Ditemukan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // List faktor risiko
            if (tbcResult.riskFactors.isNotEmpty)
              ...tbcResult.riskFactors
                  .map(
                    (factor) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              factor,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList()
            else
              const Text(
                'Tidak ada faktor risiko khusus yang teridentifikasi berdasarkan jawaban Anda.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Card untuk menampilkan rekomendasi tindakan
  Widget _buildRecommendationsCard() {
    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tindakan yang Disarankan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // List rekomendasi
            if (tbcResult.recommendations.isNotEmpty)
              ...tbcResult.recommendations
                  .map(
                    (recommendation) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '✓ ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              recommendation,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList()
            else
              const Text(
                'Lanjutkan pola hidup sehat dan konsultasikan dengan dokter jika ada keluhan.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Tombol untuk registrasi check-up
  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PageHealthCheckup()),
        );
      },
      icon: const Icon(Icons.medical_services, color: Colors.white),
      label: const Text(
        'Daftar Medical Check-Up',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 73, 170, 77),
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
    );
  }

  // Tombol kembali ke homepage
  Widget _buildBackToHomeButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      },
      icon: const Icon(Icons.home, color: Colors.white),
      label: const Text(
        'Kembali ke Beranda',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 86, 159, 231),
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
    );
  }

  // Method untuk mendapatkan warna badge berdasarkan tingkat risiko
  Color _getRiskBadgeColor() {
    switch (tbcResult.riskLevel.toLowerCase()) {
      case 'rendah':
        return Colors.green;
      case 'sedang':
        return Colors.orange;
      case 'tinggi':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

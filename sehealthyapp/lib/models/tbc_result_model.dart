import 'package:flutter/material.dart';

class TBCResultModel {
  final String riskLevel;
  final String riskDescription;
  final List<String> riskFactors;
  final List<String> recommendations;
  final String rawResponse;

  TBCResultModel({
    required this.riskLevel,
    required this.riskDescription,
    required this.riskFactors,
    required this.recommendations,
    required this.rawResponse,
  });

  // Factory constructor untuk membuat object dari response Gemini
  factory TBCResultModel.fromGeminiResponse(String response) {
    String riskLevel = 'Tidak Diketahui';
    String riskDescription = '';
    List<String> riskFactors = [];
    List<String> recommendations = [];

    // Split response menjadi baris-baris
    List<String> lines = response.split('\n');

    String currentSection = '';

    for (String line in lines) {
      String trimmedLine = line.trim();

      if (trimmedLine.isEmpty) continue;

      // Deteksi bagian Tingkat Risiko
      if (trimmedLine.toLowerCase().contains('tingkat risiko') ||
          trimmedLine.toLowerCase().contains('level risiko') ||
          trimmedLine.toLowerCase().contains('risiko tbc')) {
        currentSection = 'risk';
        continue;
      }

      // Deteksi bagian Faktor Risiko
      if (trimmedLine.toLowerCase().contains('faktor risiko') ||
          trimmedLine.toLowerCase().contains('faktor-faktor risiko')) {
        currentSection = 'factors';
        continue;
      }

      // Deteksi bagian Saran/Rekomendasi
      if (trimmedLine.toLowerCase().contains('saran') ||
          trimmedLine.toLowerCase().contains('rekomendasi') ||
          trimmedLine.toLowerCase().contains('tindakan') ||
          trimmedLine.toLowerCase().contains('langkah')) {
        currentSection = 'recommendations';
        continue;
      }

      // Proses berdasarkan section yang sedang aktif
      switch (currentSection) {
        case 'risk':
          // Ekstrak tingkat risiko
          if (trimmedLine.toLowerCase().contains('rendah') ||
              trimmedLine.toLowerCase().contains('low')) {
            riskLevel = 'Rendah';
          } else if (trimmedLine.toLowerCase().contains('sedang') ||
              trimmedLine.toLowerCase().contains('menengah') ||
              trimmedLine.toLowerCase().contains('medium')) {
            riskLevel = 'Sedang';
          } else if (trimmedLine.toLowerCase().contains('tinggi') ||
              trimmedLine.toLowerCase().contains('high')) {
            riskLevel = 'Tinggi';
          }

          // Tambahkan ke deskripsi risiko
          if (!trimmedLine.toLowerCase().contains('tingkat risiko') &&
              !trimmedLine.toLowerCase().contains('level risiko')) {
            riskDescription += trimmedLine + ' ';
          }
          break;

        case 'factors':
          // Tambahkan faktor risiko (skip header)
          if (!trimmedLine.toLowerCase().contains('faktor risiko') &&
              !trimmedLine.toLowerCase().contains('faktor-faktor')) {
            // Bersihkan bullet points dan numbering
            String cleanLine = trimmedLine
                .replaceAll(RegExp(r'^[-*•]\s*'), '')
                .replaceAll(RegExp(r'^\d+\.\s*'), '');
            if (cleanLine.isNotEmpty) {
              riskFactors.add(cleanLine);
            }
          }
          break;

        case 'recommendations':
          // Tambahkan rekomendasi (skip header)
          if (!trimmedLine.toLowerCase().contains('saran') &&
              !trimmedLine.toLowerCase().contains('rekomendasi') &&
              !trimmedLine.toLowerCase().contains('tindakan') &&
              !trimmedLine.toLowerCase().contains('langkah')) {
            // Bersihkan bullet points dan numbering
            String cleanLine = trimmedLine
                .replaceAll(RegExp(r'^[-*•]\s*'), '')
                .replaceAll(RegExp(r'^\d+\.\s*'), '');
            if (cleanLine.isNotEmpty) {
              recommendations.add(cleanLine);
            }
          }
          break;
      }
    }

    // Jika tidak ada faktor risiko atau rekomendasi yang terdeteksi,
    // coba parsing alternatif
    if (riskFactors.isEmpty || recommendations.isEmpty) {
      _parseAlternative(response, riskFactors, recommendations);
    }

    return TBCResultModel(
      riskLevel: riskLevel,
      riskDescription: riskDescription.trim(),
      riskFactors: riskFactors,
      recommendations: recommendations,
      rawResponse: response,
    );
  }

  // Method parsing alternatif jika parsing utama gagal
  static void _parseAlternative(
    String response,
    List<String> riskFactors,
    List<String> recommendations,
  ) {
    List<String> lines = response.split('\n');
    bool inFactorsSection = false;
    bool inRecommendationsSection = false;

    for (String line in lines) {
      String trimmedLine = line.trim();

      // Reset flags jika menemukan section baru
      if (trimmedLine.toLowerCase().contains('faktor')) {
        inFactorsSection = true;
        inRecommendationsSection = false;
        continue;
      }

      if (trimmedLine.toLowerCase().contains('saran') ||
          trimmedLine.toLowerCase().contains('rekomendasi') ||
          trimmedLine.toLowerCase().contains('tindakan')) {
        inFactorsSection = false;
        inRecommendationsSection = true;
        continue;
      }

      // Tambahkan ke list yang sesuai
      if (inFactorsSection && trimmedLine.isNotEmpty) {
        String cleanLine = trimmedLine
            .replaceAll(RegExp(r'^[-*•]\s*'), '')
            .replaceAll(RegExp(r'^\d+\.\s*'), '');
        if (cleanLine.isNotEmpty && riskFactors.length < 5) {
          riskFactors.add(cleanLine);
        }
      }

      if (inRecommendationsSection && trimmedLine.isNotEmpty) {
        String cleanLine = trimmedLine
            .replaceAll(RegExp(r'^[-*•]\s*'), '')
            .replaceAll(RegExp(r'^\d+\.\s*'), '');
        if (cleanLine.isNotEmpty && recommendations.length < 5) {
          recommendations.add(cleanLine);
        }
      }
    }
  }

  // Method untuk mendapatkan warna berdasarkan tingkat risiko
  Color getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'rendah':
        return const Color(0xFFE8F5E8); // Hijau muda
      case 'sedang':
        return const Color(0xFFFFF3CD); // Kuning muda
      case 'tinggi':
        return const Color(0xFFF8D7DA); // Merah muda
      default:
        return const Color(0xFFE3F2FD); // Biru muda
    }
  }

  // Method untuk mendapatkan icon berdasarkan tingkat risiko
  String getRiskIcon() {
    switch (riskLevel.toLowerCase()) {
      case 'rendah':
        return '✅';
      case 'sedang':
        return '⚠️';
      case 'tinggi':
        return '🚨';
      default:
        return 'ℹ️';
    }
  }
}

import '/models/tbc_result_model.dart';

class TBCRiskClassifier {
  // Data training berdasarkan pola gejala TBC
  static const Map<String, Map<String, double>> _trainingData = {
    'rendah': {
      'q0': 0.1, // Batuk >2 minggu
      'q1': 0.2, // Keringat malam
      'q2': 0.1, // Penurunan berat badan
      'q3': 0.0, // Batuk berdarah
      'q4': 0.2, // Demam/menggigil
      'q5': 0.1, // Nyeri dada
      'q6': 0.0, // Kontak dengan penderita TBC
      'q7': 0.2, // Kehilangan nafsu makan
      'q8': 0.1, // Pembengkakan kelenjar
      'q9': 0.1, // Riwayat perjalanan
    },
    'sedang': {
      'q0': 0.4, // Batuk >2 minggu
      'q1': 0.5, // Keringat malam
      'q2': 0.4, // Penurunan berat badan
      'q3': 0.1, // Batuk berdarah
      'q4': 0.4, // Demam/menggigil
      'q5': 0.3, // Nyeri dada
      'q6': 0.2, // Kontak dengan penderita TBC
      'q7': 0.4, // Kehilangan nafsu makan
      'q8': 0.3, // Pembengkakan kelenjar
      'q9': 0.3, // Riwayat perjalanan
    },
    'tinggi': {
      'q0': 0.8, // Batuk >2 minggu
      'q1': 0.7, // Keringat malam
      'q2': 0.6, // Penurunan berat badan
      'q3': 0.9, // Batuk berdarah
      'q4': 0.6, // Demam/menggigil
      'q5': 0.5, // Nyeri dada
      'q6': 0.8, // Kontak dengan penderita TBC
      'q7': 0.5, // Kehilangan nafsu makan
      'q8': 0.4, // Pembengkakan kelenjar
      'q9': 0.4, // Riwayat perjalanan
    },
  };

  // Prior probabilities (probabilitas awal)
  static const Map<String, double> _priorProbabilities = {
    'rendah': 0.6,
    'sedang': 0.3,
    'tinggi': 0.1,
  };

  // Fungsi utama untuk analisis
  static TBCResultModel analyzeTBCAnswers(
    Map<String, String> answers,
    List<Map<String, dynamic>> questions,
  ) {
    // Konversi jawaban ke format binary (0 atau 1)
    Map<String, int> binaryAnswers = {};
    answers.forEach((key, value) {
      binaryAnswers[key] = value == 'Yes' ? 1 : 0;
    });

    // Hitung probabilitas untuk setiap kelas risiko menggunakan Naive Bayes
    Map<String, double> classProbabilities = {};

    _trainingData.forEach((riskLevel, features) {
      double probability = _priorProbabilities[riskLevel]!;

      binaryAnswers.forEach((questionKey, answer) {
        if (features.containsKey(questionKey)) {
          if (answer == 1) {
            probability *= features[questionKey]!;
          } else {
            probability *= (1 - features[questionKey]!);
          }
        }
      });

      classProbabilities[riskLevel] = probability;
    });

    // Normalisasi probabilitas
    double totalProbability = classProbabilities.values.reduce((a, b) => a + b);
    classProbabilities.forEach((key, value) {
      classProbabilities[key] = value / totalProbability;
    });

    // Tentukan kelas dengan probabilitas tertinggi
    String predictedRisk =
        classProbabilities.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

    // Generate hasil
    return _generateTBCResult(
      predictedRisk,
      binaryAnswers,
      questions,
      classProbabilities,
    );
  }

  // Generate hasil TBC berdasarkan prediksi
  static TBCResultModel _generateTBCResult(
    String riskLevel,
    Map<String, int> answers,
    List<Map<String, dynamic>> questions,
    Map<String, double> probabilities,
  ) {
    List<String> riskFactors = [];
    List<String> recommendations = [];

    // Identifikasi faktor risiko berdasarkan jawaban positif
    answers.forEach((key, value) {
      if (value == 1) {
        int questionIndex = int.parse(key.substring(1));
        String factor = _getRiskFactorDescription(questionIndex);
        if (factor.isNotEmpty) {
          riskFactors.add(factor);
        }
      }
    });

    // Generate rekomendasi berdasarkan tingkat risiko
    recommendations = _getRecommendations(riskLevel, riskFactors.length);

    // Generate deskripsi risiko
    String riskDescription = _getRiskDescription(
      riskLevel,
      probabilities[riskLevel]!,
    );

    return TBCResultModel(
      riskLevel: riskLevel,
      riskDescription: riskDescription,
      riskFactors: riskFactors,
      recommendations: recommendations,
      confidence: probabilities[riskLevel]!,
    );
  }

  // Deskripsi faktor risiko untuk setiap pertanyaan
  static String _getRiskFactorDescription(int questionIndex) {
    const Map<int, String> factorDescriptions = {
      0: 'Batuk berkepanjangan lebih dari 2 minggu',
      1: 'Mengalami keringat malam yang berlebihan',
      2: 'Penurunan berat badan tanpa sebab yang jelas',
      3: 'Batuk berdarah (hemoptisis)',
      4: 'Demam atau menggigil yang sering terjadi',
      5: 'Nyeri dada saat bernapas atau batuk',
      6: 'Riwayat kontak dengan penderita TBC',
      7: 'Kehilangan nafsu makan',
      8: 'Pembengkakan kelenjar getah bening',
      9: 'Riwayat perjalanan ke daerah endemik TBC',
    };

    return factorDescriptions[questionIndex] ?? '';
  }

  // Rekomendasi berdasarkan tingkat risiko
  static List<String> _getRecommendations(String riskLevel, int factorCount) {
    List<String> recommendations = [];

    switch (riskLevel) {
      case 'rendah':
        recommendations = [
          'Pertahankan pola hidup sehat dengan nutrisi yang baik',
          'Lakukan olahraga teratur untuk meningkatkan daya tahan tubuh',
          'Hindari paparan asap rokok dan polusi udara',
          'Konsultasi dengan dokter jika gejala bertambah parah',
          'Lakukan pemeriksaan kesehatan rutin',
        ];
        break;
      case 'sedang':
        recommendations = [
          'Segera konsultasi dengan dokter untuk pemeriksaan lebih lanjut',
          'Lakukan tes diagnostik seperti foto rontgen dada',
          'Pertimbangkan untuk melakukan tes dahak atau tes tuberculin',
          'Jaga kebersihan dan hindari kontak dekat dengan orang lain',
          'Konsumsi makanan bergizi dan istirahat yang cukup',
          'Monitor gejala dan catat perkembangannya',
        ];
        break;
      case 'tinggi':
        recommendations = [
          'SEGERA konsultasi dengan dokter spesialis paru',
          'Lakukan pemeriksaan diagnostik lengkap (rontgen, tes dahak, CT scan)',
          'Pertimbangkan untuk isolasi sementara',
          'Informasikan kepada keluarga dan kontak dekat untuk pemeriksaan',
          'Siapkan untuk kemungkinan pengobatan anti-TBC',
          'Jangan menunda pengobatan jika didiagnosis positif TBC',
        ];
        break;
    }

    return recommendations;
  }

  // Deskripsi risiko dengan confidence level
  static String _getRiskDescription(String riskLevel, double confidence) {
    String baseDescription;
    int confidencePercent = (confidence * 100).round();

    switch (riskLevel) {
      case 'rendah':
        baseDescription =
            'Berdasarkan analisis gejala, Anda memiliki risiko rendah terkena TBC. Namun tetap penting untuk menjaga kesehatan dan melakukan pemeriksaan rutin.';
        break;
      case 'sedang':
        baseDescription =
            'Analisis menunjukkan Anda memiliki risiko sedang terkena TBC. Beberapa gejala yang Anda alami perlu mendapat perhatian medis lebih lanjut.';
        break;
      case 'tinggi':
        baseDescription =
            'Hasil analisis menunjukkan risiko tinggi TBC. Gejala-gejala yang Anda alami sangat perlu mendapat perhatian medis segera.';
        break;
      default:
        baseDescription =
            'Analisis risiko TBC telah diselesaikan berdasarkan gejala yang Anda laporkan.';
    }

    return '$baseDescription\n\nTingkat keyakinan: $confidencePercent%';
  }
}

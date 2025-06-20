import '/models/tbc_result_model.dart';
import '/services/tbc_risk_classifier.dart'; // IMPORT CLASSIFIER YANG BARU DIBUAT

class GeminiService {
  // Ganti implementasi Gemini dengan classifier lokal
  static Future<TBCResultModel?> analyzeTBCAnswers(
    Map<String, String> answers,
    List<Map<String, dynamic>> questions,
  ) async {
    try {
      // Simulasi delay untuk memberikan kesan processing AI
      await Future.delayed(const Duration(seconds: 2));

      // Gunakan classifier lokal sebagai pengganti Gemini API
      TBCResultModel result = TBCRiskClassifier.analyzeTBCAnswers(
        answers,
        questions,
      );

      return result;
    } catch (e) {
      print('Error in TBC analysis: $e');
      return null;
    }
  }
}

// services/gemini_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // untuk debugPrint
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/tbc_result_model.dart';
import 'gemini_model_options.dart';

class GeminiService {
  // ✅ Pilih model dari GeminiModelOptions
  static const String _modelName = GeminiModelOptions.pro;

  // ✅ Endpoint base URL (v1beta)
  static final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent';

  /// Fungsi utama untuk menganalisis jawaban TBC
  static Future<TBCResultModel?> analyzeTBCAnswers(
    Map<String, String> answers,
    List<Map<String, dynamic>> questions,
  ) async {
    try {
      String prompt = _buildTBCPrompt(answers, questions);
      final response = await _sendToGemini(prompt);

      if (response != null) {
        return TBCResultModel.fromGeminiResponse(response);
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error analyzeTBCAnswers: $e');
      return null;
    }
  }

  /// Membangun prompt berdasarkan jawaban dan pertanyaan
  static String _buildTBCPrompt(
    Map<String, String> answers,
    List<Map<String, dynamic>> questions,
  ) {
    StringBuffer prompt = StringBuffer();

    prompt.writeln(
      'Saya adalah asisten kesehatan yang akan menganalisis jawaban skrining TBC.',
    );
    prompt.writeln(
      'Berikut adalah jawaban pasien untuk pertanyaan skrining TBC:\n',
    );

    for (int i = 0; i < questions.length; i++) {
      String question = questions[i]['question'];
      String answer = answers['q$i'] ?? 'Tidak dijawab';
      prompt.writeln('${i + 1}. $question');
      prompt.writeln('   Jawaban: $answer\n');
    }

    prompt.writeln(
      'Berdasarkan jawaban tersebut, mohon berikan analisis dengan format berikut:\n',
    );
    prompt.writeln(
      'TINGKAT RISIKO TBC:\n(Jelaskan apakah risiko RENDAH, SEDANG, atau TINGGI beserta alasannya)\n',
    );
    prompt.writeln(
      'FAKTOR RISIKO YANG DITEMUKAN:\n- (Sebutkan faktor-faktor risiko yang teridentifikasi dari jawaban)\n- (Maksimal 5 poin)\n',
    );
    prompt.writeln(
      'SARAN DAN TINDAKAN YANG DIREKOMENDASIKAN:\n- (Berikan saran konkret yang dapat dilakukan pasien)\n- (Maksimal 5 poin)\n',
    );
    prompt.writeln(
      'Pastikan jawaban menggunakan bahasa Indonesia yang mudah dipahami.\nBerikan penjelasan yang praktis dan dapat ditindaklanjuti.',
    );

    return prompt.toString();
  }

  /// Mengirim prompt ke Gemini dan mengembalikan hasilnya
  static Future<String?> _sendToGemini(String prompt) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY tidak ditemukan di file .env');
      }

      final url = Uri.parse('$_baseUrl?key=$apiKey');

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        },
      };

      debugPrint('🚀 Mengirim request ke Gemini...');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('📩 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (content != null) {
          debugPrint('✅ Response Gemini berhasil diterima');
          return content;
        } else {
          throw Exception('Format response tidak sesuai');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Gagal menghubungi Gemini API: ${response.statusCode} - ${errorData['error']['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error dalam _sendToGemini: $e');
      return null;
    }
  }

  /// Untuk mengetes koneksi ke Gemini (misal dari UI)
  static Future<bool> testConnection() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY tidak ditemukan');
      }

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_modelName:generateContent?key=$apiKey',
      );

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': 'Hello, test connection'},
            ],
          },
        ],
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('🧪 Test connection status: ${response.statusCode}');
      debugPrint('🧪 Test response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('🚨 Test connection error: $e');
      return false;
    }
  }
}

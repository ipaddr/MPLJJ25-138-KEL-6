import 'package:flutter/material.dart';
import '/services/gemini_service.dart';
import '/models/tbc_result_model.dart';
import 'tbc_result_screen.dart';

class PageTBCScreening extends StatefulWidget {
  const PageTBCScreening({Key? key}) : super(key: key);

  @override
  State<PageTBCScreening> createState() => _PageTbcScreeningState();
}

class _PageTbcScreeningState extends State<PageTBCScreening> {
  final Map<String, String> _answers = {};
  bool _isLoading = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'icon': 'assets/images/img9.png',
      'question': 'Have you had a cough for more than 2 weeks?',
    },
    {
      'icon': 'assets/images/img10.png',
      'question': 'Do you experience night sweats?',
    },
    {
      'icon': 'assets/images/img11.png',
      'question': 'Have you lost weight recently?',
    },
    {
      'icon': 'assets/images/img12.png',
      'question': 'Have you been coughing up blood?',
    },
    {
      'icon': 'assets/images/img10.png',
      'question': 'Do you experience fever or chills frequently?',
    },
    {
      'icon': 'assets/images/img11.png',
      'question': 'Do you feel chest pain when breathing or coughing?',
    },
    {
      'icon': 'assets/images/img12.png',
      'question': 'Have you been in contact with someone diagnosed with TBC?',
    },
    {
      'icon': 'assets/images/img10.png',
      'question': 'Do you experience loss of appetite?',
    },
    {
      'icon': 'assets/images/img11.png',
      'question': 'Have you noticed swelling in your neck or lymph nodes?',
    },
    {
      'icon': 'assets/images/img12.png',
      'question':
          'Have you traveled to areas with high TBC prevalence recently?',
    },
  ];

  Future<void> _submitAnswers() async {
    if (_answers.length < _questions.length) {
      _showSnackBar('Please answer all questions before proceeding.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await GeminiService.analyzeTBCAnswers(
        _answers,
        _questions,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TBCResultScreen(tbcResult: result),
          ),
        );
      } else {
        _showErrorDialog('Failed to retrieve analysis. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Error Occurred',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildQuestionItem(int index, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  data['icon'],
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.health_and_safety,
                      size: 30,
                      color: Colors.blue,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data['question'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children:
                ['Yes', 'No'].map((answer) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        answer,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: answer,
                      groupValue: _answers['q$index'],
                      activeColor: Colors.blue.shade700,
                      onChanged: (value) {
                        setState(() {
                          _answers['q$index'] = value!;
                        });
                      },
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    int answeredQuestions = _answers.length;
    double progress = answeredQuestions / _questions.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Progress: $answeredQuestions/${_questions.length} questions answered',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE),
      appBar: AppBar(
        title: const Text(
          'TBC Screening',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE8F0FE),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionItem(index, _questions[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitAnswers,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isLoading ? Colors.grey.shade400 : Colors.blue.shade700,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _isLoading ? 0 : 2,
              ),
              child:
                  _isLoading
                      ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Analyzing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                      : const Text(
                        'Analyze Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

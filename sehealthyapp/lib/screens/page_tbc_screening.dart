import 'package:flutter/material.dart';

class PageTBCScreening extends StatefulWidget {
  const PageTBCScreening({Key? key}) : super(key: key);

  @override
  State<PageTBCScreening> createState() => _PageTbcScreeningState();
}

class _PageTbcScreeningState extends State<PageTBCScreening> {
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
  ];

  final Map<int, String> _answers = {};

  void _handleAnswer(int index, String answer) {
    setState(() {
      _answers[index] = answer;
    });
  }

  void _handleSubmit() {
    if (_answers.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text(
              'Screening Completed',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: const Text(
              'Thank you for completing the screening.',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontFamily: 'Poppins'),
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
                child: Image.asset(data['icon'], width: 30, height: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data['question'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _answerOption(index, 'Yes', Colors.blue.shade700),
              const SizedBox(width: 16),
              _answerOption(index, 'No', Colors.red.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _answerOption(int index, String label, Color color) {
    bool isSelected = _answers[index] == label;

    Color selectedColor;
    if (label == 'Yes') {
      selectedColor = const Color(0xFF90CAF9); // Biru muda
    } else {
      selectedColor = const Color(0xFFEF9A9A); // Merah muda
    }

    return ElevatedButton(
      onPressed: () => _handleAnswer(index, label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? selectedColor : Colors.grey.shade300,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      child: Text(label),
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionItem(index, _questions[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

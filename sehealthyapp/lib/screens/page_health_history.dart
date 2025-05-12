import 'package:flutter/material.dart';

class PageHealthHistory extends StatelessWidget {
  const PageHealthHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health History')),
      body: const Center(
        child: Text(
          'Ini adalah halaman Health History',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

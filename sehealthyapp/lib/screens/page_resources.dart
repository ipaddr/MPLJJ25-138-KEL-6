import 'package:flutter/material.dart';

class PageResources extends StatelessWidget {
  const PageResources({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: const Center(
        child: Text(
          'Ini adalah halaman Resources',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

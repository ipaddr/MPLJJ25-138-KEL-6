import 'package:flutter/material.dart';

class TBCResultModel {
  final String riskLevel;
  final String riskDescription;
  final List<String> riskFactors;
  final List<String> recommendations;
  final double confidence; // Property baru yang ditambahkan

  TBCResultModel({
    required this.riskLevel,
    required this.riskDescription,
    required this.riskFactors,
    required this.recommendations,
    this.confidence = 0.0, // Default value untuk confidence
  });

  Color getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'rendah':
        return Colors.green.shade100;
      case 'sedang':
        return Colors.orange.shade100;
      case 'tinggi':
        return Colors.red.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  String getRiskIcon() {
    switch (riskLevel.toLowerCase()) {
      case 'rendah':
        return '✅';
      case 'sedang':
        return '⚠️';
      case 'tinggi':
        return '🚨';
      default:
        return '📊';
    }
  }
}

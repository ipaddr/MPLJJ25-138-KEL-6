import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini

class AddHealthHistoryScreen extends StatefulWidget {
  const AddHealthHistoryScreen({super.key});

  @override
  State<AddHealthHistoryScreen> createState() => _AddHealthHistoryScreenState();
}

class _AddHealthHistoryScreenState extends State<AddHealthHistoryScreen> {
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController oxygenController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> healthCheckupTypes = [
    'Blood Pressure',
    'Blood Sugar',
    'Cholesterol',
    'Heart Rate',
  ];
  String? selectedCheckupType;

  @override
  void dispose() {
    heartRateController.dispose();
    bloodPressureController.dispose();
    temperatureController.dispose();
    oxygenController.dispose();
    glucoseController.dispose();
    doctorNameController.dispose();
    hospitalNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const inputTextStyle = TextStyle(fontSize: 14);
    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Add Health History")),
      backgroundColor: const Color(0xFFE9F3FF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildInputCard(
                    "Heart Rate",
                    Icons.favorite,
                    Colors.red,
                    heartRateController,
                    inputTextStyle,
                    inputBorder,
                  ),
                  _buildInputCard(
                    "Blood Pressure",
                    Icons.water_drop,
                    Colors.blue,
                    bloodPressureController,
                    inputTextStyle,
                    inputBorder,
                  ),
                  _buildInputCard(
                    "Temperature",
                    Icons.thermostat,
                    Colors.orange,
                    temperatureController,
                    inputTextStyle,
                    inputBorder,
                  ),
                  _buildInputCard(
                    "Oxygen",
                    Icons.bubble_chart,
                    Colors.purple,
                    oxygenController,
                    inputTextStyle,
                    inputBorder,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Checkup Type', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCheckupType,
                      items:
                          healthCheckupTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCheckupType = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.blue.shade400,
                            width: 2,
                          ),
                        ),
                        hintText: 'Select Checkup Type',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 16),
                    const Text('Glucose', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: glucoseController,
                            decoration: const InputDecoration(
                              hintText: 'Input Here',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            style: inputTextStyle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'mg/dL',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: doctorNameController,
                            decoration: const InputDecoration(
                              hintText: 'Input Doctor Name',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            style: inputTextStyle,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: hospitalNameController,
                            decoration: const InputDecoration(
                              hintText: 'Input Hospital Name',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            style: inputTextStyle,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: descriptionController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Input Description Here',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            style: inputTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('health_history')
                              .add({
                                'heartRate': heartRateController.text,
                                'bloodPressure': bloodPressureController.text,
                                'temperature': temperatureController.text,
                                'oxygen': oxygenController.text,
                                'checkupType': selectedCheckupType,
                                'glucose': glucoseController.text,
                                'doctorName': doctorNameController.text,
                                'hospitalName': hospitalNameController.text,
                                'description': descriptionController.text,
                                'createdAt': Timestamp.now(),
                              });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Health history saved successfully',
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(
    String title,
    IconData icon,
    Color color,
    TextEditingController controller,
    TextStyle inputTextStyle,
    InputBorder inputBorder,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Input Here',
              border: inputBorder,
              isDense: true,
            ),
            style: inputTextStyle,
          ),
        ],
      ),
    );
  }
}

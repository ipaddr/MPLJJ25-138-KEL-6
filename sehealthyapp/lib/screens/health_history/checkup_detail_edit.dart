import 'package:flutter/material.dart';

class EditCheckupDetailScreen extends StatefulWidget {
  final String documentId; // ID dokumen yang diedit
  final Map<String, dynamic>? initialData; // Data awal yang akan ditampilkan

  const EditCheckupDetailScreen({
    Key? key,
    required this.documentId,
    this.initialData,
  }) : super(key: key);

  @override
  State<EditCheckupDetailScreen> createState() =>
      _EditCheckupDetailScreenState();
}

class _EditCheckupDetailScreenState extends State<EditCheckupDetailScreen> {
  late TextEditingController heartRateController;
  late TextEditingController bloodPressureController;
  late TextEditingController temperatureController;
  late TextEditingController oxygenController;
  late TextEditingController glucoseController;
  late TextEditingController doctorNameController;
  late TextEditingController hospitalNameController;
  late TextEditingController descriptionController;

  final List<String> healthCheckupTypes = [
    'Blood Pressure',
    'Blood Sugar',
    'Cholesterol',
    'Heart Rate',
  ];
  String? selectedCheckupType;

  @override
  void initState() {
    super.initState();
    heartRateController = TextEditingController(
      text: widget.initialData?['heartRate'] ?? '',
    );
    bloodPressureController = TextEditingController(
      text: widget.initialData?['bloodPressure'] ?? '',
    );
    temperatureController = TextEditingController(
      text: widget.initialData?['temperature'] ?? '',
    );
    oxygenController = TextEditingController(
      text: widget.initialData?['oxygen'] ?? '',
    );
    glucoseController = TextEditingController(
      text: widget.initialData?['glucose'] ?? '',
    );
    doctorNameController = TextEditingController(
      text: widget.initialData?['doctorName'] ?? '',
    );
    hospitalNameController = TextEditingController(
      text: widget.initialData?['hospitalName'] ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.initialData?['description'] ?? '',
    );
    selectedCheckupType = widget.initialData?['checkupType'];
  }

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

  void _saveData() {
    if (selectedCheckupType == null || selectedCheckupType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a checkup type')),
      );
      return;
    }

    final Map<String, dynamic> resultData = {
      'documentId': widget.documentId,
      'checkupType': selectedCheckupType,
      'heartRate': heartRateController.text,
      'bloodPressure': bloodPressureController.text,
      'temperature': temperatureController.text,
      'oxygen': oxygenController.text,
      'glucose': glucoseController.text,
      'doctorName': doctorNameController.text,
      'hospitalName': hospitalNameController.text,
      'description': descriptionController.text,
    };

    Navigator.pop(context, resultData);
  }

  @override
  Widget build(BuildContext context) {
    const inputTextStyle = TextStyle(fontSize: 14);
    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Checkup Details")),
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
                    keyboardType: TextInputType.number,
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
                    keyboardType: TextInputType.number,
                  ),
                  _buildInputCard(
                    "Oxygen",
                    Icons.bubble_chart,
                    Colors.purple,
                    oxygenController,
                    inputTextStyle,
                    inputBorder,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dropdown dan Glukosa
              _buildDropdownAndGlucose(),

              const SizedBox(height: 16),
              _buildDoctorSection(),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveData,
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
    String label,
    IconData icon,
    Color iconColor,
    TextEditingController controller,
    TextStyle textStyle,
    OutlineInputBorder border, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: textStyle,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Input here',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownAndGlucose() {
    return Container(
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
                    child: Text(type, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
            onChanged: (value) => setState(() => selectedCheckupType = value),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue.shade400),
              ),
              hintText: 'Select Checkup Type',
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(height: 16),

          const Text('Glucose', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: glucoseController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Input here',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'mg/dL',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSection() {
    return Container(
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
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Input Doctor Name',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: hospitalNameController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Input Hospital Name',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Input Description Here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

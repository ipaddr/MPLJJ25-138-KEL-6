import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'checkup_confirmation.dart';
import 'package:intl/intl.dart';

class PageHealthCheckup extends StatefulWidget {
  const PageHealthCheckup({super.key});

  @override
  State<PageHealthCheckup> createState() => _PageHealthCheckupState();
}

class _PageHealthCheckupState extends State<PageHealthCheckup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _preferredDateController =
      TextEditingController();

  String? _selectedCheckupType;
  String? _selectedFacility;
  DateTime? _selectedDate;

  final List<String> checkupTypes = [
    'Blood Pressure',
    'Sugar Test',
    'TBC Screening',
  ];

  final List<String> facilities = ['Health Center A', 'Clinic B', 'Hospital C'];

  Future<void> _selectDate(
    TextEditingController controller, {
    bool isPreferred = false,
  }) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(picked);
      if (isPreferred) {
        _selectedDate = picked;
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedCheckupType != null &&
        _selectedFacility != null &&
        _selectedDate != null) {
      await FirebaseFirestore.instance.collection('checkups').add({
        'fullName': _fullNameController.text,
        'id': _idController.text,
        'dob': _dobController.text,
        'checkupType': _selectedCheckupType,
        'facility': _selectedFacility,
        'date': Timestamp.fromDate(_selectedDate!),
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CheckupConfirmationPage(
                fullName: _fullNameController.text,
                id: _idController.text,
                dob: _dobController.text,
                checkupType: _selectedCheckupType!,
                facility: _selectedFacility!,
                date: _selectedDate!,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: const Color(0xFFEFF6FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Full Name', _fullNameController, Icons.person),
              buildTextField('National ID', _idController, Icons.credit_card),
              buildDateField(
                'Date of Birth',
                _dobController,
                Icons.cake,
                false,
              ),
              buildDropdownField(
                'Checkup Type',
                checkupTypes,
                _selectedCheckupType,
                Icons.medical_services,
                (val) => setState(() => _selectedCheckupType = val),
              ),
              buildDropdownField(
                'Health Facility',
                facilities,
                _selectedFacility,
                Icons.local_hospital,
                (val) => setState(() => _selectedFacility = val),
              ),
              buildDateField(
                'Preferred Checkup Date',
                _preferredDateController,
                Icons.event,
                true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Complete Registration',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'By registering, you agree to our Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            prefixIcon: Icon(icon, size: 18),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildDateField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isPreferred,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(controller, isPreferred: isPreferred),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            prefixIcon: Icon(icon, size: 18),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildDropdownField(
    String label,
    List<String> items,
    String? selected,
    IconData icon,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selected,
          onChanged: onChanged,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          validator: (val) => val == null ? 'Please select $label' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

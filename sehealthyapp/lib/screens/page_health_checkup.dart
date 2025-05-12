import 'package:flutter/material.dart';

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

  final List<String> checkupTypes = [
    'Blood Pressure',
    'Sugar Test',
    'TBC Screening',
  ];
  final List<String> facilities = ['Health Center A', 'Clinic B', 'Hospital C'];

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = "${picked.month}/${picked.day}/${picked.year}";
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
              const Text(
                'Full Name',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _fullNameController,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.person, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'National ID',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _idController,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Enter your ID',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.credit_card, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Date of Birth',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _dobController,
                readOnly: true,
                onTap: () => _selectDate(_dobController),
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'mm/dd/yyyy',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.calendar_today, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Checkup Type',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCheckupType,
                items:
                    checkupTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => _selectedCheckupType = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.local_hospital, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(height: 12),

              const Text(
                'Health Facility',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedFacility,
                items:
                    facilities
                        .map(
                          (facility) => DropdownMenuItem(
                            value: facility,
                            child: Text(facility),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _selectedFacility = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(height: 12),

              const Text(
                'Preferred Checkup Date',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _preferredDateController,
                readOnly: true,
                onTap: () => _selectDate(_preferredDateController),
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'mm/dd/yyyy',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.event, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // handle registration
                    }
                  },
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
}

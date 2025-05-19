import 'package:flutter/material.dart';

class EducationEditPage extends StatefulWidget {
  final bool isEdit;
  final Map<String, String>? initialData;

  const EducationEditPage({Key? key, this.isEdit = false, this.initialData})
    : super(key: key);

  @override
  State<EducationEditPage> createState() => _EducationEditPageState();
}

class _EducationEditPageState extends State<EducationEditPage> {
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  String? _selectedType;
  final List<String> _typeOptions = ['Video', 'Article'];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.initialData != null) {
      _selectedType = widget.initialData!['type'];
      _synopsisController.text = widget.initialData!['synopsis'] ?? '';
      _linkController.text = widget.initialData!['link'] ?? '';
    }
  }

  @override
  void dispose() {
    _synopsisController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _onSave() {
    // TODO: Validasi dan simpan data ke database atau backend
    final type = _selectedType;
    final synopsis = _synopsisController.text.trim();
    final link = _linkController.text.trim();

    if (type == null || synopsis.isEmpty || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulasi penyimpanan sukses
    Navigator.pop(context, {'type': type, 'synopsis': synopsis, 'link': link});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 2,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/hospital_icon.png'),
              radius: 18,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Welcome, \nRumah Sakit Terpadu!',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: Logout action
              },
              icon: Icon(Icons.logout, color: Colors.red.shade600),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                '[insert here]',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedType,
              hint: const Text('Select type of New'),
              items:
                  _typeOptions
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _synopsisController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter Synopsis',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _linkController,
              decoration: InputDecoration(
                hintText: 'Insert Link (Video or Article)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

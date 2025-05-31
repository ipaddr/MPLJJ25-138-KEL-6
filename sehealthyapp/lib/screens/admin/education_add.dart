import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EducationAddPage extends StatefulWidget {
  const EducationAddPage({super.key});

  @override
  State<EducationAddPage> createState() => _EducationAddPageState();
}

class _EducationAddPageState extends State<EducationAddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final List<String> _types = ['Video', 'Artikel', 'Lainnya'];
  String? _selectedType;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  void _saveContent() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar harus dipilih!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newContent = {
        'title': _titleController.text,
        'type': _selectedType,
        'synopsis': _synopsisController.text,
        'link': _linkController.text,
        'imagePath': _selectedImage!.path,
      };

      Navigator.pop(context, newContent);
    }
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
              backgroundImage: const AssetImage(
                'assets/images/hospital_icon.png',
              ),
              radius: 18,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Welcome, \nAdmin Rumah Sakit!',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child:
                      _selectedImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                          : const Text(
                            '[Insert Here]',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Judul tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedType,
                hint: const Text('Select Type of New'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items:
                    _types
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Jenis konten harus dipilih'
                            : null,
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Sinopsis tidak boleh kosong'
                            : null,
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Link tidak boleh kosong'
                            : null,
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
                      onPressed: _saveContent,
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
      ),
    );
  }
}

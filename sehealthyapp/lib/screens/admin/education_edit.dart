import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class EducationEditPage extends StatefulWidget {
  final DocumentSnapshot document;

  const EducationEditPage({Key? key, required this.document}) : super(key: key);

  @override
  State<EducationEditPage> createState() => _EducationEditPageState();
}

class _EducationEditPageState extends State<EducationEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _synopsisController;
  late TextEditingController _linkController;

  final List<String> _types = ['Video', 'Artikel', 'Lainnya'];
  String? _selectedType;

  String? _imageUrl;
  String? _thumbnailUrl;
  File? _selectedImageFile;

  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    final data = widget.document.data() as Map<String, dynamic>;

    _titleController = TextEditingController(text: data['title'] ?? '');
    _synopsisController = TextEditingController(text: data['synopsis'] ?? '');
    _linkController = TextEditingController(text: data['link'] ?? '');
    _selectedType = data['type'];
    _imageUrl = data['imageUrl'];
    _thumbnailUrl = data['thumbnailUrl'];

    if (_selectedType == 'Video' && _linkController.text.isNotEmpty) {
      _initializeVideo(_linkController.text);
    }
  }

  void _initializeVideo(String url) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
        _videoController?.setLooping(true);
      });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadToCloudinary(File file) async {
    const cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/dnyyh9ayk/video/upload";
    const uploadPreset = "sehealthy";

    final request =
        http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
          ..fields['upload_preset'] = uploadPreset
          ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      return data['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrlToSave = _imageUrl;
        if (_selectedImageFile != null) {
          final uploadedUrl = await _uploadToCloudinary(_selectedImageFile!);
          if (uploadedUrl == null) {
            throw Exception("Upload file gagal");
          }
          imageUrlToSave = uploadedUrl;
          _linkController.text = uploadedUrl; // update juga ke link
        }

        final updatedData = {
          'title': _titleController.text,
          'type': _selectedType,
          'synopsis': _synopsisController.text,
          'link': _linkController.text,
          'imageUrl': imageUrlToSave,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('educational_contents')
            .doc(widget.document.id)
            .update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Konten berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan perubahan: \$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildMediaPreview() {
    if (_selectedType == 'Video' && _linkController.text.isNotEmpty) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        return AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_videoController!),
              IconButton(
                icon: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.white,
                  size: 48,
                ),
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
              ),
            ],
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    } else if (_selectedImageFile != null) {
      return Image.file(_selectedImageFile!, height: 180, fit: BoxFit.cover);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return Image.network(_imageUrl!, height: 180, fit: BoxFit.cover);
    } else if (_thumbnailUrl != null && _thumbnailUrl!.isNotEmpty) {
      return Image.network(_thumbnailUrl!, height: 180, fit: BoxFit.cover);
    } else {
      return const Text(
        '[Klik untuk pilih gambar/video]',
        style: TextStyle(fontSize: 16),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    _linkController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Konten Edukasi',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
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
                  child: _buildMediaPreview(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Judul'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Judul tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                hint: const Text('Pilih Jenis Konten'),
                decoration: _inputDecoration(''),
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
                    if (value == 'Video' && _linkController.text.isNotEmpty) {
                      _initializeVideo(_linkController.text);
                    }
                  });
                },
                validator:
                    (value) =>
                        value == null ? 'Jenis konten harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _synopsisController,
                maxLines: 4,
                decoration: _inputDecoration('Sinopsis'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Sinopsis tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: _inputDecoration('Link (video atau artikel)'),
                onChanged: (val) {
                  if (_selectedType == 'Video') {
                    _initializeVideo(val);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Link tidak boleh kosong';
                  }
                  final urlPattern = r'(http|https):\/\/([\w.]+\/?)\S*';
                  if (!RegExp(urlPattern).hasMatch(value)) {
                    return 'Masukkan link yang valid';
                  }
                  return null;
                },
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
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Simpan'),
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

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

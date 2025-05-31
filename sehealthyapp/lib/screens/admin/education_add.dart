import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';

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
  File? _selectedMedia;
  VideoPlayerController? _videoController;

  File? _thumbnailFile; // Tambahan: File thumbnail
  String? _thumbnailUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jenis konten terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final pickedFile =
        (_selectedType == 'Video')
            ? await _picker.pickVideo(source: ImageSource.gallery)
            : await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedMedia = File(pickedFile.path);
        if (_selectedType == 'Video') {
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(_selectedMedia!)
            ..initialize().then((_) {
              setState(() {});
            });
        }
      });
    }
  }

  // Tambahan: pilih thumbnail
  Future<void> _pickThumbnail() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnailFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadToCloudinary(
    File mediaFile, {
    bool isVideo = false,
  }) async {
    final cloudinaryUrl =
        isVideo
            ? "https://api.cloudinary.com/v1_1/dnyyh9ayk/video/upload"
            : "https://api.cloudinary.com/v1_1/dnyyh9ayk/image/upload";
    const uploadPreset = "sehealthy";

    final request =
        http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', mediaFile.path),
          );

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      return data['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> _saveContent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedMedia == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Media harus dipilih!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final mediaUrl = await _uploadToCloudinary(
          _selectedMedia!,
          isVideo: _selectedType == 'Video',
        );

        if (mediaUrl == null) {
          throw Exception("Upload media gagal");
        }

        String? thumbnailUrl;
        if (_selectedType == 'Video' && _thumbnailFile != null) {
          thumbnailUrl = await _uploadToCloudinary(_thumbnailFile!);
        }

        final newContent = {
          'title': _titleController.text,
          'type': _selectedType,
          'synopsis': _synopsisController.text,
          'link': _linkController.text,
          'mediaUrl': mediaUrl,
          'thumbnailUrl': thumbnailUrl,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('educational_contents')
            .add(newContent);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Konten berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan konten: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
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
                onTap: _pickMedia,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child:
                      _selectedMedia != null
                          ? (_selectedType == 'Video'
                              ? (_videoController != null &&
                                      _videoController!.value.isInitialized
                                  ? AspectRatio(
                                    aspectRatio:
                                        _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  )
                                  : const Text('Memuat video...'))
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _selectedMedia!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          : const Text(
                            '[Insert here]',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
              const SizedBox(height: 16),

              // Tambahan: Thumbnail picker jika Video
              if (_selectedType == 'Video') ...[
                const SizedBox(height: 8),
                const Text(
                  "Thumbnail (opsional)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickThumbnail,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child:
                        _thumbnailFile != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _thumbnailFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                            : const Center(child: Text('Upload Thumbnail')),
                  ),
                ),
              ],

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
                    _selectedMedia = null;
                    _thumbnailFile = null;
                    _videoController?.dispose();
                    _videoController = null;
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
                  hintText: 'Insert Link (video or article)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
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

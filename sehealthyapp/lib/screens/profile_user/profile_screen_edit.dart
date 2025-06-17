import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  String fullName = 'Loading...';
  String patientId = '';
  String? _photoUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('biodata')
              .doc(user.uid)
              .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _nikController.text = data['nik'] ?? '';
          _bloodTypeController.text = data['bloodType'] ?? '';
          fullName = data['fullName'] ?? user.displayName ?? 'User';
          patientId = user.uid.substring(0, 5);
          _photoUrl = data['photoUrl'] ?? '';
        });
      }
    }
  }

  Future<void> _pickImageAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
      });

      final cloudinaryUrl = await _uploadToCloudinary(file);
      if (cloudinaryUrl != null) {
        setState(() {
          _photoUrl = cloudinaryUrl;
        });

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('biodata')
              .doc(user.uid)
              .set({'photoUrl': _photoUrl}, SetOptions(merge: true));
        }
      }
    }
  }

  Future<String?> _uploadToCloudinary(File imageFile) async {
    const cloudName = 'dnyyh9ayk'; // Ganti dengan cloud name kamu
    const uploadPreset =
        'foto_profil_preset'; // Ganti dengan upload preset kamu
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url'];
    } else {
      print('Upload gagal: ${response.reasonPhrase}');
      return null;
    }
  }

  void _onSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final newNIK = _nikController.text.trim();
      final newBloodType = _bloodTypeController.text.trim();

      await FirebaseFirestore.instance.collection('biodata').doc(uid).set({
        'nik': newNIK,
        'bloodType': newBloodType,
        'fullName': fullName,
        'photoUrl': _photoUrl ?? '',
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
      Navigator.pop(context);
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade300),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
    );
  }

  @override
  void dispose() {
    _nikController.dispose();
    _bloodTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          _photoUrl != null && _photoUrl!.isNotEmpty
                              ? NetworkImage(_photoUrl!)
                              : const NetworkImage(
                                'https://i.pinimg.com/originals/14/4e/fd/144efdaf52422e3f38e63dd2fc887f07.png',
                              ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _pickImageAndUpload,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                fullName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Patient ID: #$patientId',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Personal Information',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nikController,
              decoration: InputDecoration(
                hintText: 'Enter your National ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bloodTypeController,
              decoration: InputDecoration(
                hintText: 'Enter your Blood Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingItem(
              Icons.notifications,
              'Notification Preferences',
              () {},
            ),
            _buildSettingItem(Icons.language, 'Language', () {}),
            _buildSettingItem(Icons.shield, 'Privacy Settings', () {}),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: _onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

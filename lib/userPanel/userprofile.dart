import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this package to your pubspec.yaml

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  XFile? _image; // Holds the profile image
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  void _saveProfile() {
    // Implement your logic to save the user profile data
    // This could involve updating a database or local storage
    Navigator.pop(context); // Close the screen after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _image != null ? FileImage(File(_image!.path)) : null,
                  child: _image == null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

import 'auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Edit Profile'),
          onTap: () {
            // Navigate to the edit profile screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()));
          },
        ),
        ListTile(
          title: Text('Log Out'),
          onTap: () async {
            await _auth.signOut();
          },
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _updateProfilePicture() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${FirebaseAuth.instance.currentUser!.uid}');
      final UploadTask uploadTask =
          storageReference.putFile(File(imageFile.path));
      await uploadTask.whenComplete(() => null);
      final String downloadUrl = await storageReference.getDownloadURL();
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(downloadUrl);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _updateDisplayName() async {
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(_displayNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _imageFile != null
                ? Image.file(File(_imageFile!.path))
                : Text('No image selected'),
            ElevatedButton(
              onPressed: _updateProfilePicture,
              child: Text('Update Profile Picture'),
            ),
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
              ),
            ),
            ElevatedButton(
              onPressed: _updateDisplayName,
              child: Text('Update Display Name'),
            ),
          ],
        ),
      ),
    );
  }
}

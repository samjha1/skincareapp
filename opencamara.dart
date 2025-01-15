import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraExample extends StatefulWidget {
  const CameraExample({super.key});

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  File? _capturedImage;

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _capturedImage = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Photo captured successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture photo: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Example"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: _capturedImage != null
            ? Image.file(
                _capturedImage!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            : Text("No photo captured."),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

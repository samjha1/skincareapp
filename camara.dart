import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class YourWidget extends StatefulWidget {
  const YourWidget({super.key});

  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isUploading = false;

  Future<void> _uploadImage(XFile imageFile) async {
    setState(() => _isUploading = true);
    try {
      // Check if running on the web
      if (kIsWeb) {
        // For web: use http.Request with FormData
        var multipartFile =
            await http.MultipartFile.fromPath('image', imageFile.path);

        var requestMultipart = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost/api/wereads/upload.php'),
        )..files.add(multipartFile);

        var response = await requestMultipart.send();
        var responseData = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseData);

        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(jsonResponse['message'] ?? "Upload successful")));
        } else {
          throw Exception(jsonResponse['message'] ?? "Upload failed");
        }
      } else {
        // For mobile: continue with MultipartRequest
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.indataai.in/wereads/upload.php'),
        );
        request.headers.addAll({'Accept': 'application/json'});

        var file = await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: imageFile.name.split('/').last,
        );
        request.files.add(file);

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(responseData['message'] ?? "Upload successful")),
          );
        } else {
          throw Exception(responseData['message'] ?? "Upload failed");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${e.toString()}")));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Compress image quality
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });

        await _uploadImage(pickedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to import photo: $e")));
    }
  }

  Widget _buildSelectedImage() {
    if (_selectedImage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: kIsWeb
          ? Image.network(_selectedImage!.path, height: 200, fit: BoxFit.cover)
          : Image.file(File(_selectedImage!.path),
              height: 200, fit: BoxFit.cover),
    );
  }

  void _showOptionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.pink),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraSetup(
                        onImageCaptured: (XFile file) async {
                          setState(() {
                            _selectedImage = file;
                          });
                          await _uploadImage(file);
                        },
                        selectedIndex:
                            _selectedIndex, // Pass selectedIndex here
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.pink),
                title: const Text("Import from Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Options"),
        backgroundColor: Colors.pink,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image Section
              Container(
                padding: const EdgeInsets.all(
                    16.0), // Display selected or placeholder image
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildSelectedImage(),
              ),
              const SizedBox(height: 16),
              // Text below image
              Text(
                'Select Image or Take Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Icon Button for Action
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: _selectedIndex == 1 ? Colors.pink : Colors.grey,
                  size: 40,
                ),
                onPressed: () {
                  setState(() => _selectedIndex = 1);
                  _showOptionDialog();
                },
              ),
              const SizedBox(height: 24),
              // Upload Button
              ElevatedButton(
                onPressed: _selectedImage != null
                    ? () async {
                        await _uploadImage(_selectedImage!);
                      }
                    : null,
                child: Text(
                  'Upload Image',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  disabledBackgroundColor:
                      Colors.grey.withOpacity(0.12), // Disable color
                ),
              ),
            ],
          ),
          if (_isUploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// The CameraSetup class remains the same
class CameraSetup extends StatefulWidget {
  final Function(XFile) onImageCaptured;
  final int selectedIndex; // Accept selectedIndex here

  const CameraSetup({
    super.key,
    required this.onImageCaptured,
    required this.selectedIndex, // Add this to the constructor
  });

  @override
  State<CameraSetup> createState() => _CameraSetupState();
}

class _CameraSetupState extends State<CameraSetup> {
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  Future<void> _setupCameraController() async {
    try {
      cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        setState(() {
          cameraController = CameraController(
            cameras.first,
            ResolutionPreset.high,
            enableAudio: true,
          );
        });

        await cameraController?.initialize();
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: Text('No camera available')),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(cameraController!),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () async {
                    try {
                      final XFile? image =
                          await cameraController?.takePicture();
                      if (image != null) {
                        widget.onImageCaptured(image);
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      debugPrint('Error taking picture: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error taking picture: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

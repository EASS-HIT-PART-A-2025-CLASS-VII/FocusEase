import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MediaScreen extends StatefulWidget {
  final String token;

  const MediaScreen({super.key, required this.token});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  File? imageFile;
  bool isLoading = false;
  String resultMessage = '';

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        resultMessage = '';
      });
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) return;

    setState(() => isLoading = true);

    final uri = Uri.parse('http://localhost:8100/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${widget.token}'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody);
        final taskTitle = json['title'];
        final duration = json['duration'];

        setState(() {
          resultMessage = "✅ Task Created: $taskTitle ($duration mins)";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Task '$taskTitle' created from image!"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // ✅ Navigate back to tasks screen after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pushReplacementNamed(
              context,
              '/tasks',
              arguments: widget.token,
            );
          }
        });
      } else {
        setState(() {
          resultMessage = '❌ Upload failed: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = '❌ Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Screenshot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            if (imageFile != null)
              Column(
                children: [
                  Image.file(imageFile!, height: 200),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: uploadImage,
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Upload Image'),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (resultMessage.isNotEmpty)
              Text(
                resultMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

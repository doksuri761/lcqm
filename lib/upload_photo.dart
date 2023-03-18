import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


mixin MyApp implements StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CameraController _controller;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) => cameras = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Upload',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera Upload'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('Take Picture and Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final imageFile = await _takePicture();
    if (imageFile == null) {
      return;
    }
    final dio = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'upload.jpg',
      ),
    });
    try {
      final response = await dio.post(
        'https://example.com/upload',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      debugPrint('Upload successful! ${response.statusCode}');
    } catch (error) {
      debugPrint('Upload failed: $error');
    }
  }

  Future<File> _takePicture() async {
    final camera = cameras.first;
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );
    await _controller.initialize();
    final imageFile = await _controller.takePicture();
    await _controller.dispose();
    return File(imageFile.path);
  }
}
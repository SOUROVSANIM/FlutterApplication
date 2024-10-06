import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({Key? key}) : super(key: key);

  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  bool _loading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        print("Model loaded successfully");
      });
    }).catchError((error) {
      print("Error loading model: $error");
    });
  }

  classifyImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      setState(() {
        _output = output;
        _loading = false;
      });

      if (_output != null) {
        print("Classification successful: $_output");
      } else {
        print("Model failed to classify the image");
      }
    } catch (e) {
      print("Error classifying image: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  loadModel() async {
    try {
      String? result = await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt',
        numThreads: 1,
      );
      print("Model load result: $result");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  pickImage() async {
    try {
      var image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        setState(() {
          _loading = false;
        });
        return;
      }

      setState(() {
        _image = File(image.path);
        _loading = true;
      });

      classifyImage(_image!);
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  pickGalleryImage() async {
    try {
      var image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        setState(() {
          _loading = false;
        });
        return;
      }

      setState(() {
        _image = File(image.path);
        _loading = true;
      });

      classifyImage(_image!);
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Detect Butterfly',
                style: TextStyle(
                  color: Color(0xFFE99600),
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: <Widget>[
                  if (_image != null)
                    Container(
                      height: 250,
                      child: Image.file(_image!),
                    ),
                  SizedBox(height: 20),
                  if (_output != null)
                    Column(
                      children: _output!.map((result) {
                        return Text(
                          "${result['label']}: ${(result['confidence'] * 100).toStringAsFixed(2)}%",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 10),
                  if (_loading)
                    CircularProgressIndicator(), // Display a loading indicator while model is processing
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'With Camera',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickGalleryImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'With Gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:tflite/tflite.dart';
import 'package:path/path.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  /*List<dynamic>? _outputs;
  File? _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  Future<void> classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _loading = true;
      _image = File(pickedFile.path);
    });

    classifyImage(_image!);
  }

  */

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
                  //color: Colors.purple,
                  color: Color(0xFFE99600),
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
            ),

            /*
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
                    Text(
                        _outputs![0]["label"],
                        style: TextStyle(
                        color: Colors.black, fontSize: 20),

                    )
                  else
                    Container(),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            */
            SizedBox(height: 20),
            //using SASS
            Center(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    //onTap: pickImage,

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
                    //onTap: pickGalleryImage,

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
                        'With Photo',
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

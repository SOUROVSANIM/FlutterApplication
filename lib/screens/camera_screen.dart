//*********************************************************************************************************************************
//Learn about camera from : https://medium.com/@fernnandoptr/how-to-use-camera-in-flutter-flutter-camera-package-44defe81d2da     *
//                                                                                                                                *
//*********************************************************************************************************************************
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class DetectionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  //* HomeScreen theke ashci
  const DetectionScreen({super.key, required this.cameras});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  CameraImage? cameraImage;
  late CameraController cameraController;
  late int _isFrontCamera = 0;
  bool _isDataLoading = true;
  late List<dynamic> output;

  @override
  initState() {
    loadCamera();
    loadModel();
    super.initState();
  }

  @override
  dispose() {
    cameraController.dispose();
    super.dispose();
  }

  loadCamera() async {
    cameraController =
        CameraController(widget.cameras[_isFrontCamera], ResolutionPreset.max);
    try {
      await cameraController.initialize().then(
        (value) {
          if (!mounted) {
            return;
          } else {
            setState(
              () {
                cameraController.startImageStream(
                  (imageStream) {
                    cameraImage = imageStream;
                    runModel();
                  },
                );
              },
            );
          }
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Loading Camera: ${e.toString()}"),
        ),
      );
    }
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 3,
        threshold: 0.0,
        asynch: true,
      );
      print(
          "******************************************************************************************************${predictions![0].toString()}\n${predictions[1].toString()}\n${predictions[2].toString()}\n}");
      print(
          "******************************************************************************************************${predictions[0]["confidence"].toString()} ${predictions[0]["label"]}\n${predictions[1]["7confidence"].toString()} ${predictions[1]["label"].toString()}\n${predictions[2]["confidence"].toString()} ${predictions[2]["label"].toString()}\n");

      predictions!.sort((a, b) => a['index'].compareTo(b['index']));
      // print(
      //     "******************************************************************************************************${predictions![0].toString()}\n${predictions[1].toString()}\n${predictions[2].toString()}\n${predictions![3].toString()}\n${predictions[4].toString()}");

      setState(
        () {
          output = predictions;
          _isDataLoading = false;
          // output = element['label'].split(RegExp(r"[0-9]")).last.toString();
        },
      );
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detect Butterfly"),
        centerTitle: true,
      ),
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
                        width: MediaQuery.of(context).size.width,
                        child: !cameraController.value.isInitialized
                            ? Container()
                            : AspectRatio(
                                aspectRatio: cameraController.value.aspectRatio,
                                child: CameraPreview(cameraController),
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(
                          () {
                            _isFrontCamera = 1 - _isFrontCamera;
                            loadCamera();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.cameraswitch_rounded,
                        color: const Color.fromARGB(255, 12, 173, 226),
                        size: MediaQuery.of(context).size.height * 0.06,
                      ),
                    )
                  ],
                ),
                _isDataLoading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: ListView.separated(
                          primary: true,
                          itemCount: 3,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                Text(
                                  " ${output[index]["label"].split(RegExp(r"[0-9]")).last} ${double.parse(output[index]["confidence"].toStringAsFixed(5))}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                LinearProgressIndicator(
                                  value: double.parse(output[index]
                                          ["confidence"]
                                      .toStringAsFixed(5)),
                                )
                              ],
                            );
                          },
                        ),
                      )
              ],
            )
          : Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: !cameraController.value.isInitialized
                            ? Container()
                            : AspectRatio(
                                aspectRatio: cameraController.value.aspectRatio,
                                child: CameraPreview(cameraController),
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(
                          () {
                            _isFrontCamera = 1 - _isFrontCamera;
                            loadCamera();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.cameraswitch_rounded,
                        color: const Color.fromARGB(255, 12, 173, 226),
                        size: MediaQuery.of(context).size.height * 0.1,
                      ),
                    )
                  ],
                ),
                _isDataLoading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: ListView.separated(
                          primary: true,
                          itemCount: 3,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                Text(
                                  " ${output[index]["label"].split(RegExp(r"[0-9]")).last} ${double.parse(output[index]["confidence"].toStringAsFixed(5))}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                LinearProgressIndicator(
                                  value: double.parse(output[index]
                                          ["confidence"]
                                      .toStringAsFixed(5)),
                                )
                              ],
                            );
                          },
                        ),
                      )
              ],
            ),
    );
  }
}

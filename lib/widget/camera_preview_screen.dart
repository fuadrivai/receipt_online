import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:receipt_online_shop/main.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key, this.animationController});
  final AnimationController? animationController;

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen>
    with WidgetsBindingObserver {
  CameraController? cameraController;
  final textRecognation = TextRecognizer();

  @override
  void initState() {
    if (listCamera.isNotEmpty) {
      WidgetsBinding.instance.addObserver(this);
      cameraController = CameraController(
        listCamera[0],
        ResolutionPreset.max,
        enableAudio: false,
      );

      cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      _startCamera();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController != null) {
      return Stack(
        children: [
          cameraPermission
              ? Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: CameraPreview(
                    cameraController!,
                  ),
                )
              : const Text("Camera Tidak Tersedia"),
          Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              isExtended: true,
              onPressed: _takePicture,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          )
        ],
      );
    } else {
      return Container();
    }
  }

  _startCamera() async {
    if (listCamera.isNotEmpty) {
      if (cameraController != null) {
        cameraController = CameraController(
          listCamera[0],
          ResolutionPreset.max,
          enableAudio: false,
        );
        await cameraController?.initialize();
        if (!mounted) {
          return;
        }
        setState(() {});
      }
    }
  }

  _stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }

  _takePicture() async {
    if (cameraController == null) return;
    final navigator = Navigator.of(context);
    try {
      final filePicture = await cameraController!.takePicture();
      final file = File(filePicture.path);
      final inputImage = InputImage.fromFile(file);
      final recognizeText = textRecognation.processImage(inputImage);
      navigator.pop(recognizeText);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Kamera Error")));
    }
  }
}

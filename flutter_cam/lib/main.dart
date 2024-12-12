import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock device orientations to allow portrait and landscape but prevent unwanted orientations
  // For this example, let's allow portraitUp and landscapeLeft/Right:
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Example',
      home: CameraPage(cameras: cameras),
    );
  }
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      _initCameraController(widget.cameras[_selectedCameraIndex]);
    }
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _controller = cameraController;

    // If the controller is updated then update the UI.
    _initializeControllerFuture = cameraController.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        print('CameraException: ${e.code} ${e.description}');
      } else {
        print('Error initializing camera: $e');
      }
    });
  }

  void _switchCamera() {
    if (widget.cameras.length < 2) {
      // No need to switch if we have only one camera
      return;
    }

    _selectedCameraIndex =
        (_selectedCameraIndex + 1) % widget.cameras.length;
    _initCameraController(widget.cameras[_selectedCameraIndex]);
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print("Controller is not initialized");
      return;
    }

    // Wait for the controller to finish initializing
    if (_initializeControllerFuture != null) {
      await _initializeControllerFuture;
    }

    if (!_controller!.value.isTakingPicture) {
      try {
        final tempDir = await getTemporaryDirectory();
        final path = join(
          tempDir.path,
          '${DateTime.now().millisecondsSinceEpoch}.png',
        );

        XFile picture = await _controller!.takePicture();
        File savedImage = await File(picture.path).copy(path);
        print("Picture saved at: ${savedImage.path}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Picture saved at ${savedImage.path}')),
        );
      } catch (e) {
        print("Error taking picture: $e");
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _cameraPreviewWidget() {
  if (_controller == null || !_controller!.value.isInitialized) {
    return const Center(child: CircularProgressIndicator());
  }

  bool isFrontCamera = widget.cameras[_selectedCameraIndex].lensDirection == CameraLensDirection.front;

  return RotatedBox(
    quarterTurns: isFrontCamera ? 1 : 3, // Adjust according to your need
    child: AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    ),
  );
}

//  Widget _cameraPreviewWidget() {
//   if (_controller == null || !_controller!.value.isInitialized) {
//     return const Center(child: CircularProgressIndicator());
//   }

//   // Determine if it's the front or back camera
//   bool isFrontCamera = widget.cameras[_selectedCameraIndex].lensDirection == 
//       CameraLensDirection.front;

//   return Transform.rotate(
// angle: isFrontCamera ? (pi / 2) : (-pi / 2),
//     child: CameraPreview(_controller!)
//   );
// }
  @override
  Widget build(BuildContext context) {
    final cameraPreview = _cameraPreviewWidget();

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Example'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              Center(child: cameraPreview),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      heroTag: "switchCamera",
                      child: Icon(Icons.switch_camera),
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      heroTag: "takePicture",
                      child: Icon(Icons.camera),
                      onPressed: _takePicture,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

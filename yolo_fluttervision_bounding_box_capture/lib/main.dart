import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

late List<CameraDescription> cameras;
final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  logger.i("Available cameras initialized: ${cameras.length} cameras found.");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("Building App widget.");
    return MaterialApp(
      title: 'YOLO Flutter App with Bounding Box Capture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const YoloVideo(),
    );
  }
}

class YoloVideo extends StatefulWidget {
  const YoloVideo({super.key});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  late FlutterVision vision;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    logger.i("FlutterVision initialized.");
    init();
  }

  Future<void> init() async {
    logger.i("Initializing camera controller.");
    controller =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    await controller.initialize();
    logger.i("Camera controller initialized.");
    await loadYoloModel();
    setState(() {
      isLoaded = true;
      isDetecting = false;
      yoloResults = [];
    });
    logger.i("Initialization complete. Model loaded: $isLoaded.");
  }

  @override
  void dispose() {
    logger.i("Disposing resources.");
    vision.closeYoloModel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    logger.i("Building UI with size: $size.");

    if (!isLoaded) {
      logger.w("Model not loaded. Displaying loading screen.");
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/ROSCODE BOT LOGO.png',
              fit: BoxFit.fill,
            ),
            const Center(
              child: Text(
                "Model not loaded. Waiting for it.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 5, color: Colors.white, style: BorderStyle.solid),
                ),
                child: isDetecting
                    ? IconButton(
                        onPressed: () async {
                          await stopDetection();
                        },
                        icon: const Icon(Icons.stop, color: Colors.red),
                        iconSize: 50,
                      )
                    : IconButton(
                        onPressed: () async {
                          await startDetection();
                        },
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        iconSize: 50,
                      ),
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 5, color: Colors.white, style: BorderStyle.solid),
                ),
                child: IconButton(
                  onPressed: () async {
                    await captureImage();
                  },
                  icon: const Icon(Icons.camera, color: Colors.white),
                  iconSize: 50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    logger.i("Loading YOLO model.");
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/yolov5n.tflite',
      modelVersion: "yolov5",
      numThreads: 8,
      useGpu: true,
    );
    setState(() {
      isLoaded = true;
    });
    logger.i("YOLO model loaded successfully.");
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    logger.d("Running YOLO on frame.");
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.2,
      confThreshold: 0.2,
      classThreshold: 0.2,
    );
    if (result.isNotEmpty) {
      logger.d("YOLO detection results found: ${result.length} objects.");
      setState(() {
        yoloResults = result;
      });
    } else {
      logger.d("No objects detected in the current frame.");
    }
  }

  Future<void> startDetection() async {
    logger.i("Starting detection.");
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      logger.w("Camera is already streaming images.");
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        await yoloOnFrame(image);
      }
    });
    logger.i("Image stream started.");
  }

  Future<void> stopDetection() async {
    logger.i("Stopping detection.");
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
    await controller.stopImageStream();
    logger.i("Image stream stopped.");
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    logger.d("Displaying boxes around recognized objects.");

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = Colors.green,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> captureImage() async {
    logger.i("Capturing image.");
    if (cameraImage == null || yoloResults.isEmpty) {
      logger.w("No image or detection results available.");
      return;
    }

    // Request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      logger.i("Storage permission requested.");
    }

    // Get the Pictures directory
    final Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      logger.e("Unable to access external storage.");
      return;
    }

    // Get the path to the Pictures directory
    final String appImagePath =
        '${directory.parent.parent.parent.parent.path}/Pictures/YOLO_Detections';
    await Directory(appImagePath).create(recursive: true);

    // Convert YUV420 to RGB
    img.Image image = convertYUV420ToImage(cameraImage!);
    logger.d("Image converted from YUV420 to RGB.");

    for (var result in yoloResults) {
      // Calculate the bounding box dimensions
      int x = (result["box"][0] as double).round();
      int y = (result["box"][1] as double).round();
      int w =
          ((result["box"][2] as double) - (result["box"][0] as double)).round();
      int h =
          ((result["box"][3] as double) - (result["box"][1] as double)).round();

      // Ensure the crop area is within the image bounds
      x = x.clamp(0, image.width - 1);
      y = y.clamp(0, image.height - 1);
      w = w.clamp(1, image.width - x);
      h = h.clamp(1, image.height - y);

      // Crop the image
      img.Image croppedImage =
          img.copyCrop(image, x: x, y: y, width: w, height: h);

      // Format the confidence as a percentage
      double confidence = (result['box'][4] as double) * 100;
      String confidenceString = confidence.toStringAsFixed(2);

      // Save the cropped image with confidence score in the filename
      final String fileName =
          '${result['tag']}_${confidenceString}pct_${DateTime.now().millisecondsSinceEpoch}.png';
      final String filePath = '$appImagePath/$fileName';
      File(filePath).writeAsBytesSync(img.encodePng(croppedImage));
      logger.i('Saved image: $filePath');
    }
  }

  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    logger.d("Converting YUV420 image to RGB.");
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    var image = img.Image(width: width, height: height);

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = cameraImage.planes[0].bytes[index];
        final up = cameraImage.planes[1].bytes[uvIndex];
        final vp = cameraImage.planes[2].bytes[uvIndex];

        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        image.setPixelRgb(x, y, r, g, b);
      }
    }
    logger.d("YUV420 to RGB conversion completed.");
    return image;
  }
}

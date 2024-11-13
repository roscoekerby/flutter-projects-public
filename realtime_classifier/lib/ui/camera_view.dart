import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

import 'camera_view_singleton.dart';

/// [CameraView] sends each frame for inference
class CameraView extends StatefulWidget {
  /// Callback to pass results after inference to [HomeView]
  // final Function(
  //         List<ResultObjectDetection> recognitions, Duration inferenceTime)
  //     resultsCallback;
  final Function(
          String classification, Duration inferenceTime, double confidence)
      resultsCallbackClassification;

  /// Constructor
  const CameraView(this.resultsCallbackClassification, {super.key});
  @override
  CameraViewState createState() => CameraViewState();
}

// Create a logger instance
final logger = Logger();

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  /// List of available cameras
  late List<CameraDescription> cameras;

  /// Controller
  CameraController? cameraController;

  /// true when inference is ongoing
  bool predicting = false;

  /// true when inference is ongoing
  bool predictingObjectDetection = false;

  // ModelObjectDetection? _objectModel;
  ClassificationModel? _imageModel;

  bool classification = false;
  int _camFrameRotation = 0;
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  //load your model
  Future loadModel() async {
    String pathImageModel = "assets/models/background_cat_dog_mobile_resnet18.pt";

    try {
      _imageModel = await PytorchLite.loadClassificationModel(
          pathImageModel, 224, 224, 3,
          labelPath: "assets/labels/background_cat_dog_labels.txt");
    } catch (e) {
      if (e is PlatformException) {
        logger.e("only supported for android, Error is $e");
      } else {
        logger.e("Error is $e");
      }
    }
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);
    await loadModel();

    // Camera initialization
    try {
      initializeCamera();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          errorMessage = ('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          errorMessage = ('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          errorMessage = ('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          errorMessage = ('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          errorMessage = ('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          errorMessage = ('Audio access is restricted.');
          break;
        default:
          errorMessage = (e.toString());
          break;
      }
      setState(() {});
    }
    // Initially predicting = false
    setState(() {
      predicting = false;
    });
  }

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    cameras = await availableCameras();

    var idx =
        cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    if (idx < 0) {
      log("No Back camera found - weird");
      return;
    }

    var desc = cameras[idx];
    _camFrameRotation = Platform.isAndroid ? desc.sensorOrientation : 0;
    // cameras[0] for rear-camera
    cameraController = CameraController(desc, ResolutionPreset.medium,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
        enableAudio: false);

    cameraController?.initialize().then((_) async {
      // Stream of image passed to [onLatestImageAvailable] callback
      await cameraController?.startImageStream(onLatestImageAvailable);

      // Ensure the widget is still mounted before accessing context
      if (!mounted) return;

      /// previewSize is size of each image frame captured by controller
      ///
      /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
      Size? previewSize = cameraController?.value.previewSize;

      /// previewSize is size of raw input image to the model
      CameraViewSingleton.inputImageSize = previewSize!;

      // the display width of image on screen is
      // same as screenWidth while maintaining the aspectRatio
      Size screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = cameraController!.value.aspectRatio;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container while the camera is not initialized
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    return CameraPreview(cameraController!);
    //return cameraController!.buildPreview();

    // return AspectRatio(
    //     // aspectRatio: cameraController.value.aspectRatio,
    //     child: CameraPreview(cameraController));
  }

  runClassification(CameraImage cameraImage) async {
    if (predicting) {
      logger.d("Prediction is already ongoing, skipping this frame.");
      return;
    }
    if (!mounted) {
      logger.w("Widget is not mounted, skipping classification.");
      return;
    }

    logger.i("Starting classification on a new frame.");
    setState(() {
      predicting = true;
    });

    if (_imageModel != null) {
      logger.i("Model is loaded, proceeding with inference.");

      // Start the stopwatch
      Stopwatch stopwatch = Stopwatch()..start();
      logger.d("Stopwatch started for inference timing.");

      try {
        // Retrieve prediction probabilities
        List<double> predictionProbabilities = await _imageModel!
            .getCameraImagePredictionProbabilities(cameraImage,
                rotation: _camFrameRotation);

        logger.d("Received prediction probabilities: $predictionProbabilities");

        // Check if any probabilities were returned
        if (predictionProbabilities.isEmpty) {
          logger.w("Prediction probabilities are empty. Skipping this frame.");
          setState(() {
            predicting = false;
          });
          return;
        }

        // Find the maximum probability and corresponding label
        double maxConfidence =
            predictionProbabilities.reduce((a, b) => a > b ? a : b);
        int maxConfidenceIndex = predictionProbabilities.indexOf(maxConfidence);
        String imageClassification = _imageModel!.labels[maxConfidenceIndex];

        logger.i(
            "Highest confidence score: $maxConfidence for label: $imageClassification");

        // Stop the stopwatch
        stopwatch.stop();
        logger.d(
            "Stopwatch stopped. Inference time: ${stopwatch.elapsedMilliseconds} ms");

        // Send results to the callback
        widget.resultsCallbackClassification(
            imageClassification, stopwatch.elapsed, maxConfidence);

        logger.i(
            "Results callback called with classification: $imageClassification, "
            "time: ${stopwatch.elapsedMilliseconds} ms, confidence: $maxConfidence");
      } catch (e) {
        logger.e("Error during classification: $e");
      }
    } else {
      logger.e("Model is not loaded. Cannot perform classification.");
    }

    if (!mounted) {
      logger.w(
          "Widget is not mounted after classification. Skipping state update.");
      return;
    }

    setState(() {
      predicting = false;
    });

    logger.i("Classification completed. Ready for next frame.");
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onLatestImageAvailable(CameraImage cameraImage) async {
    // Make sure we are still mounted, the background thread can return a response after we navigate away from this
    // screen but before bg thread is killed
    if (!mounted) {
      return;
    }

    // log("will start prediction");
    // log("Converted camera image");

    runClassification(cameraImage);

    // log("done prediction camera image");
    // Make sure we are still mounted, the background thread can return a response after we navigate away from this
    // screen but before bg thread is killed
    if (!mounted) {
      return;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!mounted) {
      return;
    }
    switch (state) {
      case AppLifecycleState.paused:
        cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          await cameraController?.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }
}

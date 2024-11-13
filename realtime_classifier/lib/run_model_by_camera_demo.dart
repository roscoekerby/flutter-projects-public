import 'package:flutter/material.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:logger/logger.dart';

import 'ui/camera_view.dart';

class RunModelWithCamera extends StatefulWidget {
  const RunModelWithCamera({super.key});

  @override
  RunModelWithCameraState createState() => RunModelWithCameraState();
}

final logger = Logger();

class RunModelWithCameraState extends State<RunModelWithCamera> {
  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;

  String? classification;
  Duration? classificationInferenceTime;
  double? confidence;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Run model with Camera'),
      ),
      body: Stack(
        children: <Widget>[
          CameraView(resultsCallbackClassification),
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.1,
              maxChildSize: 0.5,
              builder: (_, ScrollController scrollController) => Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0))),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.keyboard_arrow_up,
                            size: 48, color: Colors.orange),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              // Debug information to help troubleshoot
                              if (classification != null)
                                StatsRow('Classification:', classification!),
                              if (confidence != null)
                                StatsRow('Confidence:',
                                    '${(confidence! * 100).toStringAsFixed(2)}%'),
                              if (classificationInferenceTime != null)
                                StatsRow('Classification Inference time:',
                                    '${classificationInferenceTime?.inMilliseconds} ms'),
                              if (objectDetectionInferenceTime != null)
                                StatsRow('Object Detection Inference time:',
                                    '${objectDetectionInferenceTime?.inMilliseconds} ms'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void resultsCallbackClassification(
      String classification, Duration inferenceTime, double confidence) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.classification = classification;
      classificationInferenceTime = inferenceTime;
      this.confidence = confidence;
    });
  }
}

class StatsRow extends StatelessWidget {
  final String title;
  final String value;

  const StatsRow(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

# Real-Time YOLO Object Detection and Classification

The **Real-Time YOLO Object Detection and Classification** app is a Flutter application designed for real-time object detection and classification using a YOLO model. The app utilizes the device's camera to provide instant feedback on detected objects, displaying bounding boxes, confidence scores, and inference times.

## Features

- **Real-Time Object Detection**: Detects multiple objects in real-time using YOLO with bounding boxes and confidence levels.
- **Object Classification**: Classifies detected objects and provides the highest confidence scores.
- **Bounding Box Display**: Overlays bounding boxes around detected objects on the camera feed.
- **Inference Time Display**: Shows real-time inference times for each detection and classification.
- **User-Friendly Interface**: Clean, responsive interface with options to toggle detection on and off.

## Getting Started

### Prerequisites

Before running the project, ensure you have:

- Flutter SDK (latest stable version) installed on your machine. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- A physical device or emulator for testing.

### Installation

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd realtime_yolo_pytorch_lite
   ```

2. **Install Dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the Application**:

   ```bash
   flutter run
   ```

## Usage

1. Launch the app on your device or emulator.
2. Tap **Run Model with Camera** to start real-time object detection and classification.
3. View detected objects with bounding boxes, confidence levels, and inference times at the bottom of the screen.

## Project Structure

Key components include:

- **ChooseDemo**: The main application widget that displays the home screen.
- **RunModelWithCamera**: The screen for real-time detection and classification, with detailed UI components for viewing results.
- **CameraView**: Handles the camera feed and streams frames for model inference.
- **boundingBoxes2**: Displays bounding boxes for detected objects.
- **StatsRow**: A helper widget for displaying detailed classification and inference information.

## Packages Used

This project relies on the following Flutter packages:

- **camera**: For accessing the device camera and streaming image frames.
- **pytorch_lite**: For loading and running the pre-trained YOLO model.
- **logger**: For logging debug information during detection and classification.

## Configuration

Ensure that your assets are properly referenced in `pubspec.yaml` for the model and labels:

```yaml
assets:
  - assets/models/yolov8s.torchscript
  - assets/labels/labels_objectDetection_Coco.txt
```

## Customization

- **Model Configuration**: Modify the model or label paths in `loadModel()` to use a different model or set of labels.
- **UI Components**: Adjust the layout and style of the detection boxes in `boundingBoxes2` to customize their appearance.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source. Ensure you have the right to use and distribute any included assets.

## Acknowledgments

- Flutter for its cross-platform framework.
- Contributors to the `pytorch_lite` package for enabling on-device object detection.

## Contact

**Roscoe Kerby - ROSCODE**  
- [GitHub](https://github.com/roscoekerby)
- [LinkedIn](https://www.linkedin.com/in/roscoekerby/)

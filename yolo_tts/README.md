# YOLO TTS

YOLO TTS is a Flutter application that combines real-time object detection using YOLO (You Only Look Once) with Text-to-Speech (TTS) functionality. This project demonstrates how to use Flutter to create an application that detects objects in a video feed and provides audio feedback using TTS.

## Features

- **Real-time Object Detection:** Utilizes YOLOv5 for detecting objects in real-time via the device's camera.
- **Text-to-Speech Integration:** Provides spoken feedback for the detected objects using Flutter's TTS capabilities.
- **Live Camera Feed:** Displays a live camera feed with bounding boxes around detected objects.
- **Detection Controls:** Allows users to start and stop object detection with a simple button interface.

## Getting Started

### Prerequisites

Before running the project, ensure you have the following:

- Flutter SDK (latest stable version) installed on your machine. Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install) if you haven't set it up yet.
- A physical device or emulator with a camera for testing.

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/roscoekerby/yolo_tts.git
   cd yolo_tts
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Application:**
   ```bash
   flutter run
   ```

## Usage

1. Launch the app on your device or emulator.
2. Grant camera permissions when prompted.
3. Press the play button at the bottom of the screen to start object detection.
4. Point your device's camera at objects around you.
5. The app will detect objects in real-time, display bounding boxes, and announce them using TTS.
6. Press the stop button to halt detection.

## Project Structure

The entire application is contained within a single `main.dart` file. Key components include:

- `App`: The main application widget.
- `YoloVideo`: The primary widget handling camera feed and object detection.
- `_YoloVideoState`: The state management for the YoloVideo widget, including initialization of YOLO and TTS.

## Packages Used

This project relies on the following Flutter packages:

- `camera`: For accessing and controlling the device camera.
- `flutter_tts`: For Text-to-Speech functionality.
- `flutter_vision`: For implementing YOLO object detection.

## Configuration

The YOLO model and labels are loaded from the assets folder:

- YOLO model: `assets/yolov5n.tflite`
- Labels file: `assets/labels.txt`

Ensure these files are present in your assets folder and properly referenced in your `pubspec.yaml` file.

## Customization

You can customize various aspects of the application by modifying the `main.dart` file:

- Adjust YOLO parameters in the `yoloOnFrame` method (e.g., `iouThreshold`, `confThreshold`, `classThreshold`).
- Modify TTS settings in the `initTTS` method.
- Change the camera resolution in the `CameraController` initialization.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source. Please ensure you have the right to use and distribute any included models or assets.

## Acknowledgments

- YOLOv5 for providing the object detection model.
- Flutter team for their excellent cross-platform framework.
- All contributors who have helped to improve this project.

## Contact

Roscoe Kerby - [ROSCODE Website](https://runtime.withroscoe.com)

Project Link: [https://github.com/roscoekerby/yolo_tts](https://github.com/roscoekerby/yolo_tts)
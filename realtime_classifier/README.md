# Real-Time ResNet Classifier

The **Real-Time ResNet Classifier** is a Flutter application designed for real-time image classification using a pre-trained ResNet model, running on a device camera feed. This application leverages the `pytorch_lite` package to classify objects in real-time, such as cats and dogs, with live feedback on confidence levels and inference times.

## Features

- **Real-Time Classification**: Uses the device camera to classify objects in real-time with a ResNet model.
- **Confidence Level Display**: Provides real-time confidence scores for each classification.
- **Inference Time Display**: Shows the time taken for each classification, aiding performance evaluation.
- **Camera Control**: Easily toggle the camera feed to start or stop classification.
- **Intuitive UI**: A clean interface with options to view classification results and details.

## Getting Started

### Prerequisites

Before running the project, ensure you have:

- Flutter SDK (latest stable version) installed on your machine. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- A physical device or emulator for testing.

### Installation

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd realtime_classifier
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
2. Tap **Run Model with Camera** to start real-time classification using the camera feed.
3. View real-time classification results, confidence levels, and inference time at the bottom of the screen.

## Project Structure

Key components include:

- **ChooseDemo**: The main application widget that displays the home screen.
- **RunModelWithCamera**: The screen for real-time classification, with detailed UI components for viewing classification results.
- **CameraView**: Handles the camera feed and streaming of frames for model inference.
- **StatsRow**: A helper widget for displaying classification details, such as confidence levels and inference time.

## Packages Used

This project relies on the following Flutter packages:

- **camera**: To access the device camera and stream image frames.
- **pytorch_lite**: For loading and running the pre-trained ResNet model.
- **logger**: For logging debug information during classification.

## Configuration

Ensure that your assets are properly referenced in `pubspec.yaml` for the model and labels:

```yaml
assets:
  - assets/models/background_cat_dog_mobile_resnet18.pt
  - assets/labels/background_cat_dog_labels.txt
```

## Customization

- **Model Configuration**: Modify the model or label path in `loadModel()` if using a different model.
- **UI Components**: Adjust the design in `RunModelWithCamera` to customize the interface for displaying results.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source. Ensure you have the right to use and distribute any included assets.

## Acknowledgments

- Flutter for its cross-platform framework.
- Contributors to the `pytorch_lite` package for making on-device ML feasible.
- https://www.kaggle.com/datasets/abhinavnayak/catsvdogs-transformed?select=train_transformed
- https://www.kaggle.com/datasets/pankajkumar2002/random-image-sample-dataset

## Contact

**Roscoe Kerby - ROSCODE**  
- [GitHub](https://github.com/roscoekerby)
- [LinkedIn](https://www.linkedin.com/in/roscoekerby/)

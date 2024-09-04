# Color Converter

**Color Converter** is a Flutter application designed to help users easily convert and pick colors in different formats such as Hex, RGB, and Alpha. The app features a dynamic color picker and displays real-time color updates with customizable values.

## Features

- **Color Picker:** Allows users to pick any color and view its Hex, RGB, and Alpha values.
- **Hex and RGB Input Fields:** Users can manually enter Hex, Red, Green, Blue, and Alpha values to update the selected color.
- **Real-Time Updates:** The app provides real-time updates to the color based on the inputs from the picker or manual entries.
- **Dynamic AppBar:** The app’s AppBar color updates dynamically based on the selected color, and the text color adjusts to ensure readability.

## Getting Started

### Prerequisites

Before running the project, ensure you have the following:
- Flutter SDK (latest stable version) installed on your machine. Follow the official Flutter installation guide if you haven't set it up yet.
- A physical device or emulator for testing.

### Installation

1. **Clone the Repository:**

   ```bash
   git clone <repository-url>
   cd colorconverter
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
2. Pick a color using the color picker, or manually enter the Hex, RGB, or Alpha values.
3. The color picker and input fields will sync, updating the displayed color in real time.
4. The app dynamically updates the AppBar background and text color for readability based on the selected color.

## Project Structure

The main functionality is contained within the `main.dart` file. Key components include:

- **`MyApp:`** The main application widget.
- **`ColorConverterPage:`** The primary widget handling the color conversion and display logic.
- **`ColorConverterPageState:`** State management for the `ColorConverterPage` widget, including handling color selection and input fields.
- **`DynamicAppBar:`** A customizable AppBar that dynamically changes color and text based on the selected color.

## Packages Used

This project relies on the following Flutter packages:
- **`flutter_colorpicker:`** For color picking functionality.
- **`flutter/services.dart:`** For handling text input and formatting.

## Configuration

No special configuration is required. Ensure your assets are properly referenced in your `pubspec.yaml` file if you include any custom resources.

## Customization

You can customize various aspects of the application by modifying the `main.dart` file:

- **Color Logic:** Adjust the color conversion logic in the `updateColorFromHex` and `updateColorFromRGB` methods.
- **AppBar Design:** Customize the dynamic AppBar by modifying the `DynamicAppBar` widget.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source. Ensure you have the right to use and distribute any included assets.

## Acknowledgments

- **Flutter** for providing an excellent cross-platform framework.
- All contributors who have helped improve this project.

## Contact

Roscoe Kerby - [ROSCODE Website](https://runtime.withroscoe.com)

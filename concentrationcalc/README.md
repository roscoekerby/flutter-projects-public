# Concentration Calculator

Concentration Calculator is a Flutter application designed to help users calculate the concentration of a substance after dilution, along with the corresponding marker readings. This app is particularly useful for scenarios where precise concentration measurements are needed.

## Features

- **Substance and Concentration Units:** Allows switching between milligrams (mg) and micrograms (mcg) for both substance quantity and desired concentration.
- **Automatic Calculation:** Provides real-time calculations for concentration, volume, and marker readings.
- **Quantity Splitting:** Enables users to split the total volume into smaller portions, with updated marker readings for each split.
- **Customizable Unit Gauge Size:** Users can choose between different unit gauge sizes (25, 30, 50, 100 units) to match their requirements.
- **Visual Representation:** Displays a custom gauge with marker readings to help users visualize the required dosage.

## Getting Started

### Prerequisites

Before running the project, ensure you have the following:

- **Flutter SDK** (latest stable version) installed on your machine. Follow the official Flutter installation guide if you haven't set it up yet.
- A physical device or emulator for testing.

### Installation

1. **Clone the Repository:**

   ```bash
   git clone 
   cd concentration-calculator
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
2. Enter the amount of substance, volume of diluent, and desired concentration.
3. Optionally, adjust the quantity split and unit gauge size.
4. Press the "Calculate" button to generate the concentration and marker readings.
5. View the visual representation of the dosage on the custom gauge.

## Project Structure

The main functionality is contained within the `main.dart` file. Key components include:

- **MyApp:** The main application widget.
- **ConcentrationCalculator:** The primary widget handling the user interface and calculation logic.
- **ConcentrationCalculatorState:** State management for the ConcentrationCalculator widget, including calculation logic and UI updates.
- **MarkerPainter:** Custom painter class to draw the unit gauge with marker readings.

## Packages Used

This project relies on the following Flutter packages:

- **url_launcher:** For launching external URLs (e.g., linking to a website).
- **flutter/services.dart:** For handling text input and formatting.

## Configuration

No special configuration is required. However, ensure that your assets are properly referenced in your `pubspec.yaml` file, particularly if you plan to include custom images or other resources.

## Customization

You can customize various aspects of the application by modifying the `main.dart` file:

- **Calculation Logic:** Adjust the concentration and volume calculations in the `calculate` method.
- **Unit Gauge Visualization:** Modify the appearance of the custom gauge by editing the `MarkerPainter` class.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source. Please ensure you have the right to use and distribute any included assets.

## Acknowledgments

- **Flutter** for providing an excellent cross-platform framework.
- **All contributors** who have helped to improve this project.

## Contact

Roscoe Kerby - [ROSCODE Website](https://runtime.withroscoe.com)


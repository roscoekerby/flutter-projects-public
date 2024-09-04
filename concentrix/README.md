# Concentrix

**Concentrix** is a Flutter application designed to help users calculate the concentration of a substance after dilution. This app allows users to quickly and accurately calculate the required volume and units for a given concentration, making it ideal for scenarios where precise concentration measurements are needed.

## Features

- **Real-Time Calculations**: Automatically calculates concentration and volume as users input data.
- **Concentration Units**: Supports milligrams (mg) for substance quantity and micrograms (mcg) for desired concentration.
- **Customizable Volume Calculation**: Allows users to calculate the volume required for the desired concentration.
- **User-Friendly Interface**: Simple input fields for substance quantity, liquid added, and desired concentration.

## Getting Started

### Prerequisites

Before running the project, ensure you have the following:

- **Flutter SDK** (latest stable version) installed on your machine. Follow the official Flutter installation guide if you haven't set it up yet.
- A physical device or emulator for testing.

### Installation

1. Clone the Repository:

   ```bash
   git clone
   cd concentrix
   ```

2. Install Dependencies:

   ```bash
   flutter pub get
   ```

3. Run the Application:

   ```bash
   flutter run
   ```

## Usage

1. Launch the app on your device or emulator.
2. Enter the substance quantity (in mg), the amount of liquid added (in ml), and the desired concentration (in mcg).
3. Press the "Calculate" button to generate the required volume and unit marker.
4. The app will display the volume needed for the desired concentration in milliliters and rounded unit markers.

## Project Structure

- **`main.dart`**: The core file containing the primary application logic and UI components.
- **`MyApp`**: The main application widget that initializes the app.
- **`VolumeConcentrationCalculator`**: The main widget that handles the user interface and calculation logic.
- **`VolumeConcentrationCalculatorState`**: The state management class responsible for managing user input and performing the concentration and volume calculations.

## Packages Used

This project uses the following Flutter package:

- **logger**: For logging errors and debug information during the calculations.

## Configuration

No special configuration is needed. However, ensure that any assets (e.g., images like `tic.png`) are properly referenced in your `pubspec.yaml` file.

## Customization

You can customize the following parts of the application by modifying the `main.dart` file:

- **Calculation Logic**: Adjust the concentration and volume calculations in the `calculate()` method inside the `VolumeConcentrationCalculatorState` class.
- **UI Adjustments**: Modify the appearance of input fields, buttons, and text to match your preferred design.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source. Make sure that you have the rights to use and distribute any included assets.

## Acknowledgments

- **Flutter** for providing a solid framework for cross-platform mobile development.
- All contributors who have helped improve this project.

## Contact

Roscoe Kerby - [Roscode Website](https://runtime.withroscoe.com)


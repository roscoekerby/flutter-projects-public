# Flutter FFMI Calculator

This is a Flutter application that calculates the Fat-Free Mass Index (FFMI), a measure of muscularity that attempts to normalize lean body mass to height. It provides a user-friendly interface for inputting body measurements and displays the calculated FFMI along with a description of the result.

## Features

- Calculate FFMI and Normalized FFMI
- Switch between male and female calculations
- Input fields for weight, height, and body fat percentage
- Descriptive interpretation of FFMI results
- Simple and intuitive user interface
- Responsive design for various screen sizes

## Getting Started

### Prerequisites

Before running the project, ensure you have the following:

- Flutter SDK (latest stable version) installed on your machine. Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install) if you haven't set it up yet.
- An IDE with Flutter support (e.g., Android Studio, VS Code with Flutter extension)
- A physical device or emulator for testing

### Installation

1. **Clone the Repository:**
   ```bash
   git clone ...
   cd flutter-ffmi-calculator
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
2. Use the switch to select male or female calculation.
3. Enter your weight in kilograms.
4. Enter your height in meters.
5. Enter your body fat percentage.
6. Tap the "Calculate FFMI" button.
7. View your FFMI, Normalized FFMI, and the corresponding description.

## Project Structure

The entire application is contained within a single `main.dart` file. Key components include:

- `MyApp`: The main application widget.
- `FFMICalculator`: The stateful widget representing the calculator.
- `_FFMICalculatorState`: The state management for the calculator, including input handling, calculation logic, and UI.

## Customization

You can customize various aspects of the app by modifying the `main.dart` file:

- Adjust the UI elements, such as colors, fonts, or layout.
- Modify the FFMI interpretation ranges in the `getMaleDescription` and `getFemaleDescription` functions.
- Add additional features like unit conversion or history tracking.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source and available under the MIT License.

## Acknowledgments

- The Flutter team for their excellent cross-platform framework.
- All contributors who help improve this project.

## Contact

Roscoe Kerby - [runtime.withroscoe.com](https://runtime.withroscoe.com)

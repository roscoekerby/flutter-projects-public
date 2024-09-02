# Tic Tac Toe Game

This is a simple Tic Tac Toe game built with Flutter. It provides a classic two-player experience on a 3x3 grid, with a clean and intuitive user interface.

## Features

- Two-player gameplay (X and O)
- Interactive 3x3 game board
- Automatic win detection
- Draw (tie) detection
- Game reset functionality
- Responsive layout

## Getting Started

### Prerequisites

Before running the project, ensure you have the following:

- Flutter SDK (latest stable version) installed on your machine. Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install) if you haven't set it up yet.
- An IDE with Flutter support (e.g., Android Studio, VS Code with Flutter extension)
- A physical device or emulator for testing

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/flutter-tic-tac-toe.git
   cd flutter-tic-tac-toe
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
2. The game starts with player 'X'.
3. Players take turns tapping on empty cells to place their mark (X or O).
4. The game automatically detects wins or draws.
5. When the game ends, a dialog appears announcing the result.
6. Click 'Play Again' in the dialog or the 'Reset Game' button to start a new game.

## Project Structure

The entire application is contained within a single `main.dart` file. Key components include:

- `TicTacToeApp`: The main application widget.
- `TicTacToeGame`: The stateful widget representing the game.
- `TicTacToeGameState`: The state management for the game, including game logic and UI.

## Customization

You can customize various aspects of the game by modifying the `main.dart` file:

- Change the grid size by modifying the `board` initialization and `winningCombos`.
- Adjust the UI elements, such as colors, fonts, or layout.
- Add additional features like score tracking or AI opponents.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source and available under the MIT License.

## Acknowledgments

- The Flutter team for their excellent cross-platform framework.
- All contributors who help improve this project.

## Contact

Your Name - [Website](https://runtime.withroscoe.com)

Project Link: [https://github.com/roscoekerby/flutter-projects-public/tree/main/tictactoe](https://github.com/roscoekerby/flutter-projects-public/tree/main/tictactoe)

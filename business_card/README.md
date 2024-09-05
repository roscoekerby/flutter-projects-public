# Business Card App

The **Business Card App** is a Flutter application designed to help users create, manage, and display multiple digital business cards. Users can customize their cards, edit existing ones, and generate QR codes for easy sharing. Each card can be saved locally, and users can toggle between the edit and view displays seamlessly.

## Features

- **Multiple Business Cards**: Users can create and store multiple digital business cards.
- **QR Code Generation**: Automatically generates QR codes for easy sharing of contact details.
- **Card Editing**: Provides a user-friendly interface for editing card details like name, phone number, email, and company.
- **Card View Mode**: Display the business card in a view mode with a sleek, readable design.
- **Local Storage**: Saves business cards locally, allowing for offline access and editing.
- **Real-Time Updates**: Displays instant updates on the view mode when card details are edited.

## Getting Started

### Prerequisites

Before running the project, ensure you have the following:

- Flutter SDK (latest stable version) installed on your machine. Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) if you haven't set it up yet.
- A physical device or emulator for testing.

### Installation

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd businesscardapp
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
2. Create a new business card by filling in the required details such as name, email, and phone number.
3. View and edit existing cards using the `CardsScreen` and `EditCardScreen`.
4. Generate and display a QR code for each card to share contact information quickly.
5. All changes are saved locally, allowing users to access their business cards offline.

## Project Structure

The main functionality is contained within the `main.dart` file. Key components include:

- **MyApp**: The main application widget.
- **CardsScreen**: The screen for displaying all created business cards.
- **EditCardScreen**: The screen for editing a single business card.
- **ViewCardScreen**: The screen for viewing a single business card.
- **QR Code Generator**: A widget that generates QR codes for easy sharing of card information.

## Packages Used

This project relies on the following Flutter packages:

- **flutter_svg**: For rendering SVG assets.
- **qr_flutter**: For generating QR codes.
- **provider**: For state management across screens.
- **path_provider**: For handling local storage of business cards.

## Configuration

No special configuration is required. Ensure your assets are properly referenced in your `pubspec.yaml` file if you include any custom resources like logos or icons.

## Customization

You can customize various aspects of the application by modifying the `main.dart` file:

- **Card Design**: Adjust the layout and style of the business cards by modifying the `ViewCardScreen` widget.
- **QR Code Generator**: Customize the QR code generation settings in the `qr_flutter` widget.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source. Ensure you have the right to use and distribute any included assets.

## Acknowledgments

- Flutter for providing an excellent cross-platform framework.
- All contributors who have helped improve this project.

## Contact

**Roscoe Kerby - ROSCODE**  
- [GitHub](https://github.com/roscoekerby)
- [LinkedIn](https://www.linkedin.com/in/roscoekerby/)  

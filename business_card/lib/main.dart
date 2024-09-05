import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/cards_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Business Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const PermissionHandlerScreen(), // Start with the permission handler screen.
    );
  }
}

class PermissionHandlerScreen extends StatefulWidget {
  const PermissionHandlerScreen({super.key});

  @override
  _PermissionHandlerScreenState createState() =>
      _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request permissions once the widget is fully initialized.
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isDenied) {
      // If permission is denied, request it.
      status = await Permission.photos.request();
    }

    if (status.isPermanentlyDenied) {
      // If permanently denied, show dialog to inform user.
      await _showPermissionDeniedDialog();
    }

    // If permission is granted, navigate to the main business card screen.
    if (status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BusinessCardListScreen()),
      );
    }
  }

  Future<void> _showPermissionDeniedDialog() async {
    // Use the context from the widget, which is now available.
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
              'This app requires access to photos to proceed. Please enable it in your device settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                openAppSettings(); // Opens device settings where user can manually enable the permission.
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while waiting for permission handling.
      ),
    );
  }
}

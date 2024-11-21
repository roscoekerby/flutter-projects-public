import 'dart:io';
import 'package:business_card/models/business_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class BusinessCardScreen extends StatefulWidget {
  final BusinessCard? existingCard;
  final Function(BusinessCard) onSave;

  const BusinessCardScreen({
    super.key,
    this.existingCard,
    required this.onSave,
  });

  @override
  BusinessCardScreenState createState() => BusinessCardScreenState();
}

class BusinessCardScreenState extends State<BusinessCardScreen> {
  File? _logoImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _qrCodeWebsiteController =
      TextEditingController();

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.existingCard != null) {
      _nameController.text = widget.existingCard!.name;
      _businessNameController.text = widget.existingCard!.businessName;
      _positionController.text = widget.existingCard!.position;
      _phoneController.text = widget.existingCard!.phone;
      _emailController.text = widget.existingCard!.email;
      _websiteController.text = widget.existingCard!.website;
      if (widget.existingCard!.logoImagePath != null) {
        _checkAndSetLogoImage(widget.existingCard!.logoImagePath!);
      }
    }
  }

  void _checkAndSetLogoImage(String path) {
    File file = File(path);
    file.exists().then((exists) {
      if (exists) {
        setState(() {
          _logoImage = file;
        });
      } else {
        _showErrorDialog('Logo image not found. Please select a new one.');
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _positionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickLogoImage() async {
    final status = await _requestPhotosPermission();
    if (status.isGranted) {
      try {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _logoImage = File(pickedFile.path);
          });
        }
      } catch (e) {
        _showErrorDialog('Error picking image: $e');
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog();
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<PermissionStatus> _requestPhotosPermission() async {
    PermissionStatus status = await Permission.photos.status;
    if (status.isDenied) {
      status = await Permission.photos.request();
    }
    return status;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'This app needs access to your photos to select a logo. Please grant permission in your device settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Permanently Denied'),
          content: const Text(
              'You have permanently denied photo access permissions. Please go to your device settings to enable it manually.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _saveImageLocally(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      File newImage = await imageFile.copy(path);
      return newImage.path;
    } catch (e) {
      _showErrorDialog('Error saving image: $e');
      return '';
    }
  }

  void _saveCard() async {
    try {
      String? logoPath;
      if (_logoImage != null) {
        if (await _logoImage!.exists()) {
          logoPath = await _saveImageLocally(_logoImage!);
        } else {
          _showErrorDialog(
              'Selected logo image no longer exists. Please choose a new one.');
          return;
        }
      }

      BusinessCard newCard = BusinessCard(
        name: _nameController.text,
        businessName: _businessNameController.text,
        position: _positionController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        website: _websiteController.text,
        qrCodeWebsite: _qrCodeWebsiteController.text,
        logoImagePath: logoPath,
      );

      widget.onSave(newCard);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorDialog('Error saving card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Business Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCard,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickLogoImage,
                child: _buildLogoWidget(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _businessNameController,
                decoration: const InputDecoration(labelText: 'Business Name'),
              ),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Position'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
              TextField(
                controller: _qrCodeWebsiteController,
                decoration: const InputDecoration(labelText: 'QR Code Website'),
              ),
              const SizedBox(height: 20),
              if (_qrCodeWebsiteController.text.isNotEmpty)
                QrImageView(
                  data: _qrCodeWebsiteController.text,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoWidget() {
    if (_logoImage != null) {
      return FutureBuilder<bool>(
        future: _logoImage!.exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return Image.file(
                _logoImage!,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderLogo();
                },
              );
            } else {
              return _buildPlaceholderLogo();
            }
          }
          return const CircularProgressIndicator();
        },
      );
    } else {
      return _buildPlaceholderLogo();
    }
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      height: 100,
      width: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.add_a_photo),
    );
  }
}

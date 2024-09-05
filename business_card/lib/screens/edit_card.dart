import 'dart:io';
import 'package:business_card/models/business_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BusinessCardScreen extends StatefulWidget {
  final BusinessCard? existingCard;
  final Function(BusinessCard) onSave;

  const BusinessCardScreen(
      {super.key, this.existingCard, required this.onSave});

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

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.existingCard != null) {
      _nameController.text = widget.existingCard!.name;
      _businessNameController.text =
          widget.existingCard!.businessName; // Load business name if available
      _positionController.text = widget.existingCard!.position;
      _phoneController.text = widget.existingCard!.phone;
      _emailController.text = widget.existingCard!.email;
      _websiteController.text = widget.existingCard!.website;
      if (widget.existingCard!.logoImagePath != null) {
        _logoImage = File(widget.existingCard!.logoImagePath!);
      }
    }
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    String path =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    File newImage = await imageFile.copy(path);
    return newImage.path;
  }

  void _saveCard() async {
    String? logoPath;
    if (_logoImage != null) {
      logoPath = await _saveImageLocally(_logoImage!);
    }

    BusinessCard newCard = BusinessCard(
      name: _nameController.text,
      businessName: _businessNameController.text, // Save business name
      position: _positionController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      website: _websiteController.text,
      logoImagePath: logoPath,
    );

    widget.onSave(newCard);
    Navigator.pop(context);
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
                child: _logoImage != null
                    ? Image.file(
                        _logoImage!,
                        height: 100,
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo),
                      ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _businessNameController,
                decoration: const InputDecoration(
                    labelText: 'Business Name'), // New field for business name
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
              const SizedBox(height: 20),
              if (_websiteController.text.isNotEmpty)
                QrImageView(
                  data: _websiteController.text,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

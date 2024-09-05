import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Business Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BusinessCardListScreen(),
    );
  }
}

class BusinessCard {
  String name;
  String position;
  String phone;
  String email;
  String website;
  String? logoImagePath;

  BusinessCard({
    required this.name,
    required this.position,
    required this.phone,
    required this.email,
    required this.website,
    this.logoImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'phone': phone,
      'email': email,
      'website': website,
      'logoImagePath': logoImagePath,
    };
  }

  factory BusinessCard.fromMap(Map<String, dynamic> map) {
    return BusinessCard(
      name: map['name'],
      position: map['position'],
      phone: map['phone'],
      email: map['email'],
      website: map['website'],
      logoImagePath: map['logoImagePath'],
    );
  }
}

class BusinessCardListScreen extends StatefulWidget {
  const BusinessCardListScreen({super.key});

  @override
  BusinessCardListScreenState createState() => BusinessCardListScreenState();
}

class BusinessCardListScreenState extends State<BusinessCardListScreen> {
  List<BusinessCard> _businessCards = [];

  @override
  void initState() {
    super.initState();
    _loadBusinessCards();
  }

  Future<void> _loadBusinessCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedCards = prefs.getStringList('businessCards');
    if (storedCards != null) {
      setState(() {
        _businessCards = storedCards
            .map((cardData) => BusinessCard.fromMap(json.decode(cardData)))
            .toList();
      });
    }
  }

  Future<void> _saveBusinessCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cardsToStore =
        _businessCards.map((card) => json.encode(card.toMap())).toList();
    await prefs.setStringList('businessCards', cardsToStore);
  }

  void _addNewCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessCardScreen(
          onSave: (newCard) {
            setState(() {
              _businessCards.add(newCard);
            });
            _saveBusinessCards();
          },
        ),
      ),
    );
  }

  void _editCard(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessCardScreen(
          existingCard: _businessCards[index],
          onSave: (editedCard) {
            setState(() {
              _businessCards[index] = editedCard;
            });
            _saveBusinessCards();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Business Cards'),
      ),
      body: ListView.builder(
        itemCount: _businessCards.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_businessCards[index].name),
            subtitle: Text(_businessCards[index].position),
            onTap: () => _editCard(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        child: const Icon(Icons.add),
      ),
    );
  }
}

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

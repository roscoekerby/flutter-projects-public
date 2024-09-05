import 'dart:convert';
import 'package:business_card/models/business_card.dart';
import 'package:business_card/screens/view_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_card.dart';

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
            title: Text(_businessCards[index].businessName),
            subtitle: Text(_businessCards[index].position),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewCardScreen(
                    card: _businessCards[index],
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _editCard(index);
              },
            ),
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

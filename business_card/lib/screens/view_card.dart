import 'dart:io';
import 'package:business_card/models/business_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewCardScreen extends StatelessWidget {
  final BusinessCard card;

  const ViewCardScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 350,
            height: 200,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (card.logoImagePath != null)
                        Image.file(
                          File(card.logoImagePath!),
                          height: 40,
                        ),
                      const SizedBox(height: 8),
                      Text(
                        card.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        card.position,
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Spacer(),
                      Text(card.businessName,
                          style: const TextStyle(fontSize: 14)),
                      Text(card.phone, style: const TextStyle(fontSize: 12)),
                      Text(card.email, style: const TextStyle(fontSize: 12)),
                      Text(card.website, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                if (card.website.isNotEmpty)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: QrImageView(
                        data: card.website,
                        version: QrVersions.auto,
                        size: 80,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

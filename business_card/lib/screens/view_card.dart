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
        title: Text(card.businessName),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = constraints.maxWidth * 0.9;
            double cardHeight = constraints.maxHeight * 0.4;

            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: cardWidth,
                height: cardHeight,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (card.logoImagePath != null)
                            Flexible(
                              flex: 2,
                              child: _buildLogoImage(
                                  card.logoImagePath!, cardHeight),
                            ),
                          const SizedBox(height: 8),
                          Flexible(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  card.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  card.position,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  card.businessName,
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  card.phone,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  card.email,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  card.website,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
                            size: cardHeight * 0.4,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoImage(String imagePath, double cardHeight) {
    return FutureBuilder<bool>(
      future: File(imagePath).exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Image.file(
              File(imagePath),
              fit: BoxFit.contain,
              height: cardHeight * 0.3,
            );
          } else {
            return const Icon(Icons.image_not_supported, size: 50);
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

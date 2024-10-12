import 'dart:io';
import 'package:business_card/models/business_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewCardScreen extends StatefulWidget {
  final BusinessCard card;

  const ViewCardScreen({super.key, required this.card});

  @override
  ViewCardScreenState createState() => ViewCardScreenState();
}

class ViewCardScreenState extends State<ViewCardScreen> {
  bool _showFront = true; // Track if the front or back is being shown
  bool _isQrCodeExpanded = false; // Track if QR code is expanded

  @override
  Widget build(BuildContext context) {
    // Card aspect ratio for a real credit card (85.6mm x 53.98mm)
    const double cardAspectRatio = 1.586;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.businessName),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = constraints.maxWidth * 0.9;
            double cardHeight = cardWidth / cardAspectRatio;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _showFront = !_showFront; // Flip the card on tap
                });
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final rotate = Tween(begin: 1.0, end: 0.0).animate(animation);
                  return RotationYTransition(turns: rotate, child: child);
                },
                child: _isQrCodeExpanded
                    ? _buildExpandedQRCode() // Show expanded QR code if clicked
                    : _showFront
                        ? _buildFrontSide(cardWidth, cardHeight)
                        : _buildBackSide(cardWidth, cardHeight),
              ),
            );
          },
        ),
      ),
    );
  }

  // Front side of the card with name, logo, company, and position
  Widget _buildFrontSide(double cardWidth, double cardHeight) {
    return Card(
      key: const ValueKey(true), // Unique key for the front side
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
            if (widget.card.logoImagePath != null)
              _buildLogoImage(widget.card.logoImagePath!,
                  cardHeight * 0.8), // Adjusted size
            const SizedBox(width: 16), // Spacing between logo and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.card.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.card.position,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.card.businessName,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Back side of the card with QR code and details
  Widget _buildBackSide(double cardWidth, double cardHeight) {
    return Card(
      key: const ValueKey(false), // Unique key for the back side
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoLine("Phone:", widget.card.phone),
                  _buildInfoLine("Email:", widget.card.email),
                  _buildInfoLine("Website:", widget.card.website),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isQrCodeExpanded = true; // Expand QR code on tap
                });
              },
              child: Center(
                child: QrImageView(
                  data: widget.card.website,
                  version: QrVersions.auto,
                  size: cardHeight * 0.5, // Ensure QR code fits perfectly
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for displaying info lines with titles (e.g., Phone:, Email:)
  Widget _buildInfoLine(String title, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: '$title ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }

  // Display a larger version of the QR code
  Widget _buildExpandedQRCode() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isQrCodeExpanded = false; // Return to normal view on tap
        });
      },
      child: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: QrImageView(
              data: widget.card.website,
              version: QrVersions.auto,
              size: 300, // Large size for expanded QR code
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoImage(String imagePath, double size) {
    return FutureBuilder<bool>(
      future: File(imagePath).exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return SizedBox(
              width: size,
              height: size,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
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

class RotationYTransition extends AnimatedWidget {
  final Widget child;
  const RotationYTransition(
      {super.key, required Animation<double> turns, required this.child})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final angle = animation.value * 3.14159; // Rotate in radians for flip

    return Transform(
      transform: Matrix4.rotationY(angle),
      alignment: Alignment.center,
      child: angle.abs() < 1.57
          ? child
          : Container(), // Show nothing while flipping for better effect
    );
  }
}

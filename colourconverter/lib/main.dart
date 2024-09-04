import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const ColorConverterApp());
}

class ColorConverterApp extends StatelessWidget {
  const ColorConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ColorConverterPage(),
    );
  }
}

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String title;

  const DynamicAppBar(
      {super.key, required this.backgroundColor, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: backgroundColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}

class ColorConverterPage extends StatefulWidget {
  const ColorConverterPage({super.key});

  @override
  ColorConverterPageState createState() => ColorConverterPageState();
}

class ColorConverterPageState extends State<ColorConverterPage> {
  Color selectedColor = Colors.blue;
  String appBarTitle = 'Color Converter and Picker';

  late TextEditingController hexController;
  late TextEditingController redController;
  late TextEditingController greenController;
  late TextEditingController blueController;
  late TextEditingController alphaController;

  @override
  void initState() {
    super.initState();

    hexController = TextEditingController();
    redController = TextEditingController();
    greenController = TextEditingController();
    blueController = TextEditingController();
    alphaController = TextEditingController();

    // Initialize controllers with initial values
    updateTextControllers(selectedColor);
  }

  void updateColor(Color color) {
    setState(() {
      selectedColor = color;
      updateTextControllers(color);
    });
  }

  void updateTextControllers(Color color) {
    hexController.text = color.value.toRadixString(16).substring(2);
    redController.text = color.red.toString();
    greenController.text = color.green.toString();
    blueController.text = color.blue.toString();
    alphaController.text = color.alpha.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(backgroundColor: selectedColor, title: appBarTitle),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: updateColor,
                enableAlpha: true,
                pickerAreaHeightPercent: 0.8,
              ),
              const SizedBox(height: 20),
              Text(
                'Selected Color: ${selectedColor.toString()}',
                style: TextStyle(
                  color: selectedColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Hex: '),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: hexController,
                            onChanged: (value) {
                              if (value.length == 6 || value.length == 7) {
                                updateColorFromHex(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Text('R: '),
                              Expanded(
                                child: TextField(
                                  controller: redController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('G: '),
                              Expanded(
                                child: TextField(
                                  controller: greenController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('B: '),
                              Expanded(
                                child: TextField(
                                  controller: blueController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('A: '),
                              Expanded(
                                child: TextField(
                                  controller: alphaController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateColorFromRGB();
                },
                child: const Text("Update Color from RGB"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateColorFromHex(String hexValue) {
    // Ensure the hex value starts with a #
    if (!hexValue.startsWith('#')) {
      hexValue = '#$hexValue';
    }

    Color color = hexToColor(hexValue);
    updateColor(color);
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Add an alpha channel if not provided
    }
    int intValue = int.parse(hexColor, radix: 16);
    return Color(intValue);
  }

  void updateColorFromRGB() {
    int red = int.tryParse(redController.text) ?? 0;
    int green = int.tryParse(greenController.text) ?? 0;
    int blue = int.tryParse(blueController.text) ?? 0;
    int alpha = int.tryParse(alphaController.text) ?? 255;

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);
    alpha = alpha.clamp(0, 255);

    Color color = Color.fromARGB(alpha, red, green, blue);
    updateColor(color);
  }
}

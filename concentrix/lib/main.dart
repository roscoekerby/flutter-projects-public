import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Concentrix', // Updated App Name
      home: VolumeConcentrationCalculator(), // Updated Widget Name
    );
  }
}

class VolumeConcentrationCalculator extends StatefulWidget {
  const VolumeConcentrationCalculator({super.key});

  @override
  VolumeConcentrationCalculatorState createState() =>
      VolumeConcentrationCalculatorState();
}

class VolumeConcentrationCalculatorState
    extends State<VolumeConcentrationCalculator> {
  final TextEditingController substanceQuantityController =
      TextEditingController();
  final TextEditingController liquidAddedController = TextEditingController();
  final TextEditingController desiredConcentrationController =
      TextEditingController();

  double totalVolume = 1.0;
  double substanceQuantity = 0.0;
  double liquidAdded = 0.0;
  double desiredConcentration = 0.0;

  double concentration = 0.0;
  double volume = 0.0;
  double unitMarker = 0.0;

  int unitMarkerInt = 0;

  bool areFieldsFilled = false;
  bool isButtonPressed = false;

  bool resultUpToDate = false;

  final Logger logger = Logger(); // Initialize Logger

  @override
  void initState() {
    super.initState();
    substanceQuantityController.addListener(checkFieldsFilled);
    liquidAddedController.addListener(checkFieldsFilled);
    desiredConcentrationController.addListener(checkFieldsFilled);
  }

  @override
  void dispose() {
    substanceQuantityController.dispose();
    liquidAddedController.dispose();
    desiredConcentrationController.dispose();
    super.dispose();
  }

  void calculate() {
    setState(() {
      try {
        substanceQuantity = double.parse(substanceQuantityController.text);
        liquidAdded = double.parse(liquidAddedController.text);
        desiredConcentration =
            double.parse(desiredConcentrationController.text);

        // Calculate concentration
        concentration = substanceQuantity / liquidAdded;
        logger.i('Concentration calculated: $concentration');

        // Calculate volume needed for desired concentration
        volume = desiredConcentration / (concentration * totalVolume);
        logger.i('Calculated volume before conversion: $volume');

        unitMarker = volume / 10;
        logger.i('Unit marker calculated: $unitMarker');

        if (unitMarker != 0.0 && unitMarker.isFinite) {
          unitMarkerInt = unitMarker.ceil().toInt();
        } else {
          unitMarkerInt = 0;
        }

        volume = volume / 1000; // Convert volume to ml
        logger.i('Final volume (ml): $volume');

        if (!volume.isFinite) {
          volume = 0;
        }

        isButtonPressed = true;
        resultUpToDate = true;
      } catch (e) {
        logger.e("Error during calculation $e");
      }
    });
  }

  void changeUpToDateState() {
    resultUpToDate = false;
  }

  void checkFieldsFilled() {
    if (substanceQuantityController.text.isNotEmpty &&
        liquidAddedController.text.isNotEmpty &&
        desiredConcentrationController.text.isNotEmpty) {
      setState(() {
        areFieldsFilled = true;
      });
    } else {
      setState(() {
        areFieldsFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Volumix",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Volume/Concentration Calculator'),
          backgroundColor: const Color.fromRGBO(60, 180, 100, 1),
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(),
          child: SingleChildScrollView(
            // Prevent overflow
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/tic.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: substanceQuantityController,
                    onChanged: (value) => changeUpToDateState(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Substance quantity (mg)',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(60, 180, 100, 1)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(60, 180, 100, 1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: liquidAddedController,
                    onChanged: (value) => changeUpToDateState(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount of liquid added (ml)',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(60, 180, 100, 1)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(60, 180, 100, 1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: desiredConcentrationController,
                    onChanged: (value) => changeUpToDateState(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Desired concentration per dose (mcg)',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(60, 180, 100, 1)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(60, 180, 100, 1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        !resultUpToDate && areFieldsFilled ? calculate : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: resultUpToDate
                          ? Colors.grey
                          : const Color.fromRGBO(60, 180, 100, 1),
                    ),
                    child: !resultUpToDate && areFieldsFilled
                        ? const Text('Calculate')
                        : resultUpToDate && areFieldsFilled
                            ? const Text('Already Calculated :)')
                            : const Text('Please fill in all values'),
                  ),
                  const SizedBox(height: 20),
                  resultUpToDate
                      ? Text(
                          'Volume needed: ${volume.toStringAsFixed(4)} ml (millilitres) [Not Rounded]')
                      : const Text('Volume needed: ?'),
                  const SizedBox(height: 20),
                  resultUpToDate
                      ? Text(
                          'Measurement unit: $unitMarkerInt U (Units) [Rounded Up]')
                      : const Text('Measurement unit: ?'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

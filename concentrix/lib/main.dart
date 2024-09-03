import 'package:flutter/material.dart';

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

class VolumeConcentrationCalculator extends StatefulWidget { // Updated Class Name
  const VolumeConcentrationCalculator({super.key});

  @override
  VolumeConcentrationCalculatorState createState() => VolumeConcentrationCalculatorState();
}

class VolumeConcentrationCalculatorState extends State<VolumeConcentrationCalculator> { // Updated State Class Name
  final TextEditingController substanceQuantityController = TextEditingController(); // Updated variable name
  final TextEditingController liquidAddedController = TextEditingController();
  final TextEditingController desiredConcentrationController = TextEditingController(); // Updated variable name

  double totalVolume = 1.0; // Total volume of the container = 1ml
  double substanceQuantity = 0.0; // Updated variable name
  double liquidAdded = 0.0;
  double desiredConcentration = 0.0; // Updated variable name

  double concentration = 0.0;
  double volume = 0.0;
  double unitMarker = 0.0; // Updated variable name

  int unitMarkerInt = 0; // Updated variable name

  bool areFieldsFilled = false; // Flag to track input completion
  bool isButtonPressed = false; // Flag to track if the button is pressed

  bool resultUpToDate = false;

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
      substanceQuantity = double.parse(substanceQuantityController.text);
      liquidAdded = double.parse(liquidAddedController.text);
      desiredConcentration = double.parse(desiredConcentrationController.text);

      // Calculate concentration
      concentration = substanceQuantity / liquidAdded;

      // Calculate volume needed for desired concentration
      volume = desiredConcentration / (concentration * totalVolume);

      unitMarker = volume / 10; // Updated calculation name

      if (unitMarker != 0.0 &&
          unitMarker != double.infinity &&
          unitMarker.isFinite) {
        unitMarkerInt = unitMarker.ceil().toInt(); // Updated calculation name
      } else {
        unitMarkerInt = 0;
      }

      // Convert volume to ml
      volume = volume / 1000;

      if (!volume.isFinite) {
        volume = 0;
      }

      // Set the button pressed flag to true
      isButtonPressed = true;

      resultUpToDate = true;
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
        areFieldsFilled = true; // Set flag to true if all fields have values
      });
    } else {
      setState(() {
        areFieldsFilled = false; // Reset flag if any field is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Volumix", // Updated App Name
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Volume/Concentration Calculator'), // Updated Title
          backgroundColor: const Color.fromRGBO(60, 180, 100, 1),
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/restore.png'),
                  ),
                ),
              ),
              TextField(
                controller: substanceQuantityController,
                onChanged: (value) => changeUpToDateState(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Substance quantity (mg)', // Updated Label
                  labelStyle: TextStyle(color: Color.fromRGBO(60, 180, 100, 1)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(60, 180, 100, 1)),
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
                  labelText: 'Amount of liquid added (ml)', // Updated Label
                  labelStyle: TextStyle(color: Color.fromRGBO(60, 180, 100, 1)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(60, 180, 100, 1)),
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
                  labelText: 'Desired concentration per dose (mcg)', // Updated Label
                  labelStyle: TextStyle(color: Color.fromRGBO(60, 180, 100, 1)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(60, 180, 100, 1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: !resultUpToDate && areFieldsFilled ? calculate : null,
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
                      'Measurement unit: $unitMarkerInt U (Units) [Rounded Up]') // Updated Display Text
                  : const Text('Measurement unit: ?'),
            ],
          ),
        ),
      ),
    );
  }
}
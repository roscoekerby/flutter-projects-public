import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FFMI Calculator'),
        ),
        body: const FFMICalculator(),
      ),
    );
  }
}

class FFMICalculator extends StatefulWidget {
  const FFMICalculator({super.key});

  @override
  _FFMICalculatorState createState() => _FFMICalculatorState();
}

class _FFMICalculatorState extends State<FFMICalculator> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController bodyFatController = TextEditingController();
  String result = '';
  bool isMale = true; // Default to male

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Male'),
                Switch(
                  value: isMale,
                  onChanged: (value) {
                    setState(() {
                      isMale = value;
                    });
                  },
                ),
                const Text('Female'),
              ],
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (m)'),
            ),
            TextField(
              controller: bodyFatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Body Fat (%)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateFFMI();
              },
              child: const Text('Calculate FFMI'),
            ),
            const SizedBox(height: 20),
            Text('Result: $result'),
          ],
        ),
      ),
    );
  }

  void calculateFFMI() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    double bodyFatPercentage = double.parse(bodyFatController.text);

    // double bodyFat = weight * (bodyFatPercentage / 100);
    double fatFreeMass = weight * (1 - (bodyFatPercentage / 100));
    double ffmi = fatFreeMass / (height * height);
    double normalizedFFMI = ffmi + 6.1 * (1.8 - height);

    String description =
        isMale ? getFemaleDescription(ffmi) : getMaleDescription(ffmi);

    setState(() {
      result =
          'FFMI: ${ffmi.toStringAsFixed(2)}\nNormalized FFMI: ${normalizedFFMI.toStringAsFixed(2)}\nDescription: $description';
    });
  }

  String getMaleDescription(double ffmi) {
    if (ffmi < 18) {
      return 'Below average';
    } else if (ffmi >= 18 && ffmi < 20) {
      return 'Average';
    } else if (ffmi >= 20 && ffmi < 22) {
      return 'Above average';
    } else if (ffmi >= 22 && ffmi < 23) {
      return 'Excellent';
    } else if (ffmi >= 23 && ffmi < 26) {
      return 'Superior';
    } else if (ffmi >= 26 && ffmi < 28) {
      return 'Suspicion of steroid use';
    } else {
      return 'Steroid usage likely';
    }
  }

  String getFemaleDescription(double ffmi) {
    if (ffmi < 15) {
      return 'Below average';
    } else if (ffmi >= 15 && ffmi < 17) {
      return 'Average';
    } else if (ffmi >= 17 && ffmi < 18) {
      return 'Above average';
    } else if (ffmi >= 18 && ffmi < 19) {
      return 'Excellent';
    } else if (ffmi >= 19 && ffmi < 21.5) {
      return 'Superior';
    } else if (ffmi >= 21.5 && ffmi < 25) {
      return 'Suspicion of steroid use';
    } else {
      return 'Steroid usage likely';
    }
  }
}

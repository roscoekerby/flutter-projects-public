import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concentration Calculator',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(60, 180, 100, 1),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(60, 180, 100, 1)),
        useMaterial3: true,
      ),
      home: const ConcentrationCalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConcentrationCalculator extends StatefulWidget {
  const ConcentrationCalculator({super.key});

  @override
  ConcentrationCalculatorState createState() => ConcentrationCalculatorState();
}

class ConcentrationCalculatorState extends State<ConcentrationCalculator> {
  final TextEditingController substanceQuantityController =
      TextEditingController();
  final TextEditingController diluentVolumeController = TextEditingController();
  final TextEditingController desiredConcentrationController =
      TextEditingController();
  final TextEditingController dosageSplitController = TextEditingController();

  double substanceQuantity = 0.0;
  double diluentVolume = 0.0;
  double desiredConcentration = 0.0;

  double concentration = 0.0;
  double volume = 0.0;
  double needleReading = 0.0;

  int needleReadingInt = 0;
  int syringeSize = 100; // Default to 100 unit syringe

  bool areFieldsFilled = false;
  bool isButtonPressed = false;
  bool resultUpToDate = false;

  bool isSubstanceInMg = true;
  bool isConcentrationInMg = false;

  int dosageSplit = 1;
  double splitVolume = 0.0;
  int splitNeedleReadingInt = 0;

  @override
  void initState() {
    super.initState();
    substanceQuantityController.addListener(checkFieldsFilled);
    diluentVolumeController.addListener(checkFieldsFilled);
    desiredConcentrationController.addListener(checkFieldsFilled);
    dosageSplitController.addListener(checkFieldsFilled);
    dosageSplitController.text = '1'; // Default value
  }

  @override
  void dispose() {
    substanceQuantityController.dispose();
    diluentVolumeController.dispose();
    desiredConcentrationController.dispose();
    dosageSplitController.dispose();
    super.dispose();
  }

  void calculate() {
    setState(() {
      substanceQuantity =
          double.tryParse(substanceQuantityController.text) ?? 0.0;
      diluentVolume = double.tryParse(diluentVolumeController.text) ?? 0.0;
      desiredConcentration =
          double.tryParse(desiredConcentrationController.text) ?? 0.0;
      dosageSplit = int.tryParse(dosageSplitController.text) ?? 1;
      if (dosageSplit < 1) dosageSplit = 1;

      double substanceInMg =
          isSubstanceInMg ? substanceQuantity : substanceQuantity / 1000;

      double concentrationInMcg = isConcentrationInMg
          ? desiredConcentration * 1000
          : desiredConcentration;

      concentration = diluentVolume != 0 ? substanceInMg / diluentVolume : 0.0;
      volume = concentration != 0
          ? (concentrationInMcg / (concentration * 1000))
          : 0.0;

      needleReading = (volume * 100);
      needleReadingInt = needleReading.ceil();

      splitVolume = volume / dosageSplit;
      splitNeedleReadingInt = (needleReading / dosageSplit).ceil();

      isButtonPressed = true;
      resultUpToDate = true;
    });
  }

  void changeUpToDateState() {
    setState(() {
      resultUpToDate = false;
    });
  }

  void checkFieldsFilled() {
    setState(() {
      areFieldsFilled = substanceQuantityController.text.isNotEmpty &&
          diluentVolumeController.text.isNotEmpty &&
          desiredConcentrationController.text.isNotEmpty &&
          dosageSplitController.text.isNotEmpty;
    });
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://theinjuryconsultant.com/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concentration Calculator'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _launchURL,
              child: Image.asset(
                'assets/tic.png',
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: buildInputField(
                    controller: substanceQuantityController,
                    labelText: 'Amount of substance',
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isSubstanceInMg = !isSubstanceInMg;
                      resultUpToDate = false;
                    });
                  },
                  child: Text(isSubstanceInMg ? 'mg' : 'mcg'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            buildInputField(
              controller: diluentVolumeController,
              labelText: 'Volume of diluent added (ml)',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: buildInputField(
                    controller: desiredConcentrationController,
                    labelText: 'Desired concentration',
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isConcentrationInMg = !isConcentrationInMg;
                      resultUpToDate = false;
                    });
                  },
                  child: Text(isConcentrationInMg ? 'mg' : 'mcg'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            buildInputField(
              controller: dosageSplitController,
              labelText: 'Dosage Split (1 for no split)',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Syringe Size: '),
                Expanded(
                  child: DropdownButton<int>(
                    value: syringeSize,
                    items: const [
                      DropdownMenuItem<int>(
                        value: 25,
                        child: Text('1/4 mL (25 units)'),
                      ),
                      DropdownMenuItem<int>(
                        value: 30,
                        child: Text('1/3 mL (30 units)'),
                      ),
                      DropdownMenuItem<int>(
                        value: 50,
                        child: Text('1/2 mL (50 units)'),
                      ),
                      DropdownMenuItem<int>(
                        value: 100,
                        child: Text('1 mL (100 units)'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        syringeSize = value ?? 100;
                        resultUpToDate = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: !resultUpToDate && areFieldsFilled ? calculate : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: resultUpToDate
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ),
              child: Text(
                !resultUpToDate && areFieldsFilled
                    ? 'Calculate'
                    : resultUpToDate && areFieldsFilled
                        ? 'Already Calculated :)'
                        : 'Please fill in all values',
              ),
            ),
            const SizedBox(height: 10),
            if (resultUpToDate) ...[
              CustomPaint(
                size: const Size(double.infinity, 150),
                painter: NeedlePainter(
                    splitNeedleReadingInt.toDouble(), syringeSize),
              ),
              const SizedBox(height: 10),
              Text(
                'Total volume needed per week: ${volume.toStringAsFixed(4)} ml (millilitres) [Not Rounded]',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Split Volume (1/$dosageSplit): ${splitVolume.toStringAsFixed(4)} ml [Rounded Up]',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Total needle reading: $needleReadingInt U (Units) [Rounded Up]',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Split needle reading (1/$dosageSplit): $splitNeedleReadingInt U [Rounded Up]',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Disclaimer: Please always double check the readings yourself. Results and accuracies are NOT guaranteed. Responsibility is in YOUR hands. The app creator takes no responsibility or liability for your actions, use at your OWN RISK',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      onChanged: (value) => changeUpToDateState(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        FilteringTextInputFormatter.deny(RegExp(r'^0\d')),
        FilteringTextInputFormatter.deny(RegExp(r'-')),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class NeedlePainter extends CustomPainter {
  final double needleReading;
  final int syringeSize;

  NeedlePainter(this.needleReading, this.syringeSize);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final double syringeWidth = size.width * 0.8;
    final double syringeHeight = size.height * 0.2;
    final Offset syringeStart = Offset(size.width * 0.1, size.height * 0.4);
    final Rect syringeRect = Rect.fromLTWH(
        syringeStart.dx, syringeStart.dy, syringeWidth, syringeHeight);
    canvas.drawRect(syringeRect, paint);

    final Paint unitMarkPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.0;

    final double markSpacing = syringeWidth / syringeSize;
    final double regularMarkHeight = syringeHeight / 4;
    for (int i = 0; i <= syringeSize; i++) {
      final double markX = syringeStart.dx + (markSpacing * i);
      double markHeight = regularMarkHeight;

      if (i % 10 == 0) {
        markHeight = regularMarkHeight * 2;
      } else if (i % 5 == 0) {
        markHeight = regularMarkHeight * 1.5;
      }

      final Offset startMark = Offset(markX, syringeStart.dy + syringeHeight);
      final Offset endMark =
          Offset(markX, syringeStart.dy + syringeHeight - markHeight);
      canvas.drawLine(startMark, endMark, unitMarkPaint);

      if (i % 10 == 0 && i != 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: i.toString(),
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(markX - textPainter.width / 2,
                syringeStart.dy + syringeHeight + 5));
      }
    }

    final Paint fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final double fillWidth = syringeWidth * (needleReading / syringeSize);
    final Rect fillRect = Rect.fromLTWH(
        syringeStart.dx, syringeStart.dy, fillWidth, syringeHeight);
    canvas.drawRect(fillRect, fillPaint);

    final Paint needlePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    final double needleX = syringeStart.dx + fillWidth;
    final Offset needleMarkStart = Offset(needleX, syringeStart.dy);
    final Offset needleMarkEnd =
        Offset(needleX, syringeStart.dy + syringeHeight);
    canvas.drawLine(needleMarkStart, needleMarkEnd, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

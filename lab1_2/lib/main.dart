import 'package:flutter/material.dart';

void main() {
  runApp(const FuelOilCalculatorApp());
}

class FuelOilCalculatorApp extends StatelessWidget {
  const FuelOilCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Oil Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FuelOilCalculatorScreen(),
    );
  }
}

class FuelOilCalculatorScreen extends StatefulWidget {
  const FuelOilCalculatorScreen({super.key});

  @override
  State<FuelOilCalculatorScreen> createState() => _FuelOilCalculatorScreenState();
}

class _FuelOilCalculatorScreenState extends State<FuelOilCalculatorScreen> {
  final _hydrogenController = TextEditingController();
  final _carbonController = TextEditingController();
  final _sulfurController = TextEditingController();
  final _oxygenController = TextEditingController();
  final _moistureController = TextEditingController();
  final _ashController = TextEditingController();
  final _vanadiumController = TextEditingController();
  final _lowerHeatingValueController = TextEditingController();

  String _result = "";

  void _calculate() {
    double toDouble(String text) => double.tryParse(text) ?? 0.0;

    final hydrogen = toDouble(_hydrogenController.text);
    final carbon = toDouble(_carbonController.text);
    final sulfur = toDouble(_sulfurController.text);
    final oxygen = toDouble(_oxygenController.text);
    final moisture = toDouble(_moistureController.text);
    final ash = toDouble(_ashController.text);
    final vanadium = toDouble(_vanadiumController.text);
    final lhv = toDouble(_lowerHeatingValueController.text);

    final result = calculateFuelOil(
      hydrogen,
      carbon,
      sulfur,
      oxygen,
      moisture,
      ash,
      vanadium,
      lhv,
    );

    setState(() {
      _result = result;
    });
  }

  String calculateFuelOil(
      double hydrogen,
      double carbon,
      double sulfur,
      double oxygen,
      double moisture,
      double ash,
      double vanadium,
      double lhv,
      ) {
    final multiplier = (100 - moisture - ash) / 100;
    final hydrogenRaw = hydrogen * multiplier;
    final carbonRaw = carbon * multiplier;
    final sulfurRaw = sulfur * multiplier;
    final oxygenRaw = oxygen * multiplier;

    return '''
Calculations:
Hydrogen (raw): ${hydrogenRaw.toStringAsFixed(2)}%
Carbon (raw): ${carbonRaw.toStringAsFixed(2)}%
Sulfur (raw): ${sulfurRaw.toStringAsFixed(2)}%
Oxygen (raw): ${oxygenRaw.toStringAsFixed(2)}%
Vanadium: ${vanadium.toStringAsFixed(2)} mg/kg
Lower Heating Value: ${lhv.toStringAsFixed(2)} MJ/kg
''';
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Oil Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("H% (Hydrogen)", _hydrogenController),
            const SizedBox(height: 12),
            _buildTextField("C% (Carbon)", _carbonController),
            const SizedBox(height: 12),
            _buildTextField("S% (Sulfur)", _sulfurController),
            const SizedBox(height: 12),
            _buildTextField("O% (Oxygen)", _oxygenController),
            const SizedBox(height: 12),
            _buildTextField("W% (Moisture)", _moistureController),
            const SizedBox(height: 12),
            _buildTextField("A% (Ash)", _ashController),
            const SizedBox(height: 12),
            _buildTextField("V (Vanadium mg/kg)", _vanadiumController),
            const SizedBox(height: 12),
            _buildTextField("Q (Lower Heating Value MJ/kg)", _lowerHeatingValueController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text("Calculate"),
            ),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

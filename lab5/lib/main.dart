import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ReliabilityLossCalculatorApp());
}

class ReliabilityLossCalculatorApp extends StatelessWidget {
  const ReliabilityLossCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор надійності',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _failureRateSingle = TextEditingController();
  final TextEditingController _repairTimeSingle = TextEditingController();
  final TextEditingController _failureRateDouble = TextEditingController();
  final TextEditingController _repairTimeDouble = TextEditingController();
  final TextEditingController _powerLoss = TextEditingController();
  final TextEditingController _outageCost = TextEditingController();

  String _reliabilityResult = '';
  String _lossResult = '';

  void _calculate() {
    double? failureRateSingle = double.tryParse(_failureRateSingle.text);
    double? repairTimeSingle = double.tryParse(_repairTimeSingle.text);
    double? failureRateDouble = double.tryParse(_failureRateDouble.text);
    double? repairTimeDouble = double.tryParse(_repairTimeDouble.text);
    double? powerLoss = double.tryParse(_powerLoss.text);
    double? outageCost = double.tryParse(_outageCost.text);

    if ([failureRateSingle, repairTimeSingle, failureRateDouble, repairTimeDouble, powerLoss, outageCost].contains(null)) {
      setState(() {
        _reliabilityResult = 'Будь ласка, введіть коректні значення.';
        _lossResult = '';
      });
      return;
    }

    // Розрахунок
    double reliabilitySingle = 1 / (failureRateSingle! * repairTimeSingle!);
    double reliabilityDouble = 1 / (failureRateDouble! * repairTimeDouble!);

    double lossSingle = powerLoss! * repairTimeSingle * outageCost!;
    double lossDouble = powerLoss * repairTimeDouble * outageCost;

    setState(() {
      _reliabilityResult =
      'Надійність одноколової системи: ${reliabilitySingle.toStringAsFixed(2)} (безвідмовні години)\n'
          'Надійність двоколової системи: ${reliabilityDouble.toStringAsFixed(2)} (безвідмовні години)';
      _lossResult =
      'Збитки одноколової системи: ${lossSingle.toStringAsFixed(2)} грн\n'
          'Збитки двоколової системи: ${lossDouble.toStringAsFixed(2)} грн';
    });
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  void dispose() {
    _failureRateSingle.dispose();
    _repairTimeSingle.dispose();
    _failureRateDouble.dispose();
    _repairTimeDouble.dispose();
    _powerLoss.dispose();
    _outageCost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор надійності та збитків'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Інтенсивність відмов одноколової системи (λ, 1/год)', _failureRateSingle),
            const SizedBox(height: 12),
            _buildTextField('Середній час відновлення одноколової системи (t, год)', _repairTimeSingle),
            const SizedBox(height: 12),
            _buildTextField('Інтенсивність відмов двоколової системи (λ, 1/год)', _failureRateDouble),
            const SizedBox(height: 12),
            _buildTextField('Середній час відновлення двоколової системи (t, год)', _repairTimeDouble),
            const SizedBox(height: 12),
            _buildTextField('Втрати потужності при перерві (кВт)', _powerLoss),
            const SizedBox(height: 12),
            _buildTextField('Вартість втрат електропостачання (грн/кВт·год)', _outageCost),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Розрахувати'),
            ),
            const SizedBox(height: 20),
            Text(
              _reliabilityResult,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              _lossResult,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

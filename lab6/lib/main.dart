import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electrical Load Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const LoadCalculatorScreen(),
    );
  }
}

class LoadCalculatorScreen extends StatefulWidget {
  const LoadCalculatorScreen({super.key});

  @override
  State<LoadCalculatorScreen> createState() => _LoadCalculatorScreenState();
}

class _LoadCalculatorScreenState extends State<LoadCalculatorScreen> {
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _efficiencyController = TextEditingController();
  final TextEditingController _cosPhiController = TextEditingController();
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _usageFactorController = TextEditingController();
  final TextEditingController _reactivePowerFactorController = TextEditingController();

  String _result = '';

  void _calculateLoad() {
    final power = double.tryParse(_powerController.text) ?? 0.0;
    final efficiency = double.tryParse(_efficiencyController.text) ?? 0.0;
    final cosPhi = double.tryParse(_cosPhiController.text) ?? 0.0;
    final voltage = double.tryParse(_voltageController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final usageFactor = double.tryParse(_usageFactorController.text) ?? 0.0;
    final reactivePowerFactor = double.tryParse(_reactivePowerFactorController.text) ?? 0.0;

    if (power <= 0 || efficiency <= 0 || cosPhi <= 0 || voltage <= 0 || quantity <= 0 || usageFactor <= 0 || reactivePowerFactor <= 0) {
      setState(() {
        _result = 'Будь ласка, введіть коректні значення.';
      });
      return;
    }

    final totalPower = power * quantity;
    final activeLoad = totalPower * usageFactor;
    final calculatedActiveLoad = activeLoad / (efficiency * cosPhi);
    final calculatedCurrent = (calculatedActiveLoad * 1000) / (voltage * sqrt(3));
    final reactiveLoad = activeLoad * reactivePowerFactor;
    final fullPower = sqrt(activeLoad * activeLoad + reactiveLoad * reactiveLoad);

    setState(() {
      _result = '''
Загальна номінальна потужність: ${totalPower.toStringAsFixed(2)} кВт
Розрахункове активне навантаження: ${calculatedActiveLoad.toStringAsFixed(2)} кВт
Розрахунковий струм: ${calculatedCurrent.toStringAsFixed(2)} А
Розрахункове реактивне навантаження: ${reactiveLoad.toStringAsFixed(2)} квар
Повна потужність: ${fullPower.toStringAsFixed(2)} кВА
''';
    });
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
      appBar: AppBar(title: const Text('Electrical Load Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField('Номінальна потужність ЕП (Pн, кВт)', _powerController),
            const SizedBox(height: 12),
            _buildTextField('Коефіцієнт корисної дії (ηн)', _efficiencyController),
            const SizedBox(height: 12),
            _buildTextField('Коефіцієнт потужності (cos φ)', _cosPhiController),
            const SizedBox(height: 12),
            _buildTextField('Напруга навантаження (Uн, кВ)', _voltageController),
            const SizedBox(height: 12),
            _buildTextField('Кількість ЕП (n, шт)', _quantityController),
            const SizedBox(height: 12),
            _buildTextField('Коефіцієнт використання (КВ)', _usageFactorController),
            const SizedBox(height: 12),
            _buildTextField('Коефіцієнт реактивної потужності (tgφ)', _reactivePowerFactorController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateLoad,
              child: const Text('Розрахувати навантаження'),
            ),
            const SizedBox(height: 16),
            Text(_result, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
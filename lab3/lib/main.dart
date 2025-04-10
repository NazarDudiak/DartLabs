import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(SolarProfitCalculatorApp());
}

class SolarProfitCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Profit Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const SolarProfitCalculatorScreen(),
    );
  }
}

class SolarProfitCalculatorScreen extends StatefulWidget {
  const SolarProfitCalculatorScreen({Key? key}) : super(key: key);

  @override
  _SolarProfitCalculatorScreenState createState() => _SolarProfitCalculatorScreenState();
}

class _SolarProfitCalculatorScreenState extends State<SolarProfitCalculatorScreen> {
  final _powerController = TextEditingController();
  final _performanceController = TextEditingController();
  final _sunnyDaysController = TextEditingController();
  final _tariffController = TextEditingController();
  final _efficiencyController = TextEditingController();

  String _result = '';

  void _calculate() {
    final power = double.tryParse(_powerController.text) ?? 0.0;
    final performance = double.tryParse(_performanceController.text) ?? 0.0;
    final sunnyDays = int.tryParse(_sunnyDaysController.text) ?? 0;
    final tariff = double.tryParse(_tariffController.text) ?? 0.0;
    final efficiency = double.tryParse(_efficiencyController.text) ?? 0.0;

    if (power <= 0 || performance <= 0 || sunnyDays <= 0 || tariff <= 0 || efficiency <= 0) {
      setState(() {
        _result = 'Будь ласка, введіть коректні значення.';
      });
      return;
    }

    final effectiveEfficiency = efficiency / 100;
    final annualProduction = power * performance * sunnyDays * effectiveEfficiency;
    final annualProfit = annualProduction * tariff;

    setState(() {
      _result = 'Щорічний прибуток: ${annualProfit.toStringAsFixed(2)} грн';
    });
  }

  @override
  void dispose() {
    _powerController.dispose();
    _performanceController.dispose();
    _sunnyDaysController.dispose();
    _tariffController.dispose();
    _efficiencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сонячна Електростанція'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Розрахунок прибутку від сонячних електростанцій',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            _buildNumberField(_powerController, 'Потужність станції (кВт)'),
            _buildNumberField(_performanceController, 'Середня продуктивність (годин/день)'),
            _buildNumberField(_sunnyDaysController, 'Кількість сонячних днів у році', isInteger: true),
            _buildNumberField(_tariffController, 'Тариф на електроенергію (грн/кВт·год)'),
            _buildNumberField(_efficiencyController, 'Ефективність системи (%)'),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Розрахувати прибуток'),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label, {bool isInteger = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(isInteger ? r'[0-9]' : r'[0-9.]'),
          ),
        ],
      ),
    );
  }
}

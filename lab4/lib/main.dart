import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FaultCurrentCalculatorApp());
}

class FaultCurrentCalculatorApp extends StatelessWidget {
  const FaultCurrentCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fault Current Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const FaultCurrentCalculatorPage(),
    );
  }
}

class FaultCurrentCalculatorPage extends StatefulWidget {
  const FaultCurrentCalculatorPage({super.key});

  @override
  State<FaultCurrentCalculatorPage> createState() => _FaultCurrentCalculatorPageState();
}

class _FaultCurrentCalculatorPageState extends State<FaultCurrentCalculatorPage> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _impedanceController = TextEditingController();

  String _currentType = 'threePhase';
  String _result = '';

  void _calculate() {
    final double? voltage = double.tryParse(_voltageController.text);
    final double? impedance = double.tryParse(_impedanceController.text);

    if (voltage == null || voltage <= 0 || impedance == null || impedance <= 0) {
      setState(() {
        _result = 'Будь ласка, введіть коректні значення.';
      });
      return;
    }

    double faultCurrent;
    if (_currentType == 'threePhase') {
      faultCurrent = (voltage * 1000) / (impedance * sqrt(3));
    } else {
      faultCurrent = (voltage * 1000) / impedance;
    }

    setState(() {
      _result = 'Розрахунковий струм короткого замикання: ${faultCurrent.toStringAsFixed(2)} А';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Розрахунок струмів КЗ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Розрахунок струмів короткого замикання',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _voltageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Напруга (U, кВ)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _impedanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Імпеданс системи (Z, Ом)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Тип струму:'),
                const SizedBox(width: 10),
                Radio<String>(
                  value: 'threePhase',
                  groupValue: _currentType,
                  onChanged: (value) {
                    setState(() {
                      _currentType = value!;
                    });
                  },
                ),
                const Text('Трифазний'),
                const SizedBox(width: 10),
                Radio<String>(
                  value: 'singlePhase',
                  groupValue: _currentType,
                  onChanged: (value) {
                    setState(() {
                      _currentType = value!;
                    });
                  },
                ),
                const Text('Однофазний'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Розрахувати струм КЗ'),
            ),
            const SizedBox(height: 16),
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
}

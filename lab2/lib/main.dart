import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FuelCalculatorApp());
}

class FuelCalculatorApp extends StatelessWidget {
  const FuelCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FuelCalculatorScreen(),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  const FuelCalculatorScreen({super.key});

  @override
  State<FuelCalculatorScreen> createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final TextEditingController coalController = TextEditingController();
  final TextEditingController fuelOilController = TextEditingController();
  final TextEditingController gasController = TextEditingController();

  String coalResult = '';
  String fuelOilResult = '';
  String gasResult = '';

  final double efficiencyCleaningGases = 0.985;

  final double coalLowerWorkingHeat = 20.47;
  final double coalFlyAsh = 0.8;
  final double coalContentAsh = 25.2;
  final double coalCombustibleSubstances = 1.5;

  final double fuelOilLowerWorkingHeat = 39.48;
  final double fuelOilFlyAsh = 1.0;
  final double fuelOilContentAsh = 0.15;
  final double fuelOilCombustibleSubstances = 0.0;

  final double gasLowerWorkingHeat = 33.08;
  final double gasFlyAsh = 0.0;
  final double gasContentAsh = 0.0;
  final double gasCombustibleSubstances = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFuelSection(
                label: "Coal Calculator",
                controller: coalController,
                onCalculate: () {
                  final mass = double.tryParse(coalController.text) ?? 0.0;
                  final result = calculateFuel(
                    mass,
                    coalLowerWorkingHeat,
                    coalFlyAsh,
                    coalContentAsh,
                    coalCombustibleSubstances,
                    efficiencyCleaningGases,
                  );
                  setState(() => coalResult = result);
                },
                result: coalResult,
              ),
              const SizedBox(height: 32),
              buildFuelSection(
                label: "Fuel Oil Calculator",
                controller: fuelOilController,
                onCalculate: () {
                  final mass = double.tryParse(fuelOilController.text) ?? 0.0;
                  final result = calculateFuel(
                    mass,
                    fuelOilLowerWorkingHeat,
                    fuelOilFlyAsh,
                    fuelOilContentAsh,
                    fuelOilCombustibleSubstances,
                    efficiencyCleaningGases,
                  );
                  setState(() => fuelOilResult = result);
                },
                result: fuelOilResult,
              ),
              const SizedBox(height: 32),
              buildFuelSection(
                label: "Gas Calculator",
                controller: gasController,
                onCalculate: () {
                  final mass = double.tryParse(gasController.text) ?? 0.0;
                  final result = calculateFuel(
                    mass,
                    gasLowerWorkingHeat,
                    gasFlyAsh == 0.0 ? 0.01 : gasFlyAsh,
                    gasContentAsh == 0.0 ? 0.01 : gasContentAsh,
                    gasCombustibleSubstances,
                    efficiencyCleaningGases,
                  );
                  setState(() => gasResult = result);
                },
                result: gasResult,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFuelSection({
    required String label,
    required TextEditingController controller,
    required VoidCallback onCalculate,
    required String result,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter mass (kg)',
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onCalculate,
          child: const Text('Calculate'),
        ),
        const SizedBox(height: 8),
        Text(result),
      ],
    );
  }

  String calculateFuel(
      double mass,
      double lowerWorkingHeat,
      double flyAsh,
      double contentAsh,
      double combustibleSubstances,
      double efficiencyCleaningGases,
      ) {
    final emissionIndex = (pow(10, 6) / lowerWorkingHeat) *
        flyAsh *
        (contentAsh / (100 - combustibleSubstances)) *
        (1 - efficiencyCleaningGases);

    final grossSolidParticles =
        pow(10, -6) * emissionIndex * lowerWorkingHeat * mass;

    return '''
Emission Index: ${emissionIndex.toStringAsFixed(3)}
Gross Solid Particles: ${grossSolidParticles.toStringAsFixed(3)}
''';
  }
}



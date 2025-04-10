import 'package:flutter/material.dart';

void main() {
  runApp(FuelCalculatorApp());
}

class FuelCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FuelCalculatorScreen(),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  @override
  _FuelCalculatorScreenState createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final TextEditingController _hr = TextEditingController();
  final TextEditingController _cr = TextEditingController();
  final TextEditingController _sr = TextEditingController();
  final TextEditingController _nr = TextEditingController();
  final TextEditingController _or = TextEditingController();
  final TextEditingController _wr = TextEditingController();
  final TextEditingController _ar = TextEditingController();

  String result = "";

  void calculate() {
    double? hydrogenRaw = double.tryParse(_hr.text);
    double? carbonRaw = double.tryParse(_cr.text);
    double? sulfurRaw = double.tryParse(_sr.text);
    double? nitrogenRaw = double.tryParse(_nr.text);
    double? oxygenRaw = double.tryParse(_or.text);
    double? moistureRaw = double.tryParse(_wr.text);
    double? ashRaw = double.tryParse(_ar.text);

    if ([hydrogenRaw, carbonRaw, sulfurRaw, nitrogenRaw, oxygenRaw, moistureRaw, ashRaw].contains(null)) {
      setState(() {
        result = "Please enter all components.";
      });
      return;
    }

    double coefficientTransitionToDry = 100 / (100 - moistureRaw!);
    double coefficientTransitionToCombustible = 100 / (100 - moistureRaw - ashRaw!);

    double hydrogenDry = hydrogenRaw! * coefficientTransitionToDry;
    double carbonDry = carbonRaw! * coefficientTransitionToDry;
    double sulfurDry = sulfurRaw! * coefficientTransitionToDry;
    double nitrogenDry = nitrogenRaw! * coefficientTransitionToDry;
    double oxygenDry = oxygenRaw! * coefficientTransitionToDry;
    double ashDry = ashRaw * coefficientTransitionToDry;

    double testDry = hydrogenDry + carbonDry + sulfurDry + nitrogenDry + oxygenDry + ashDry;

    double hydrogenCombustible = hydrogenRaw * coefficientTransitionToCombustible;
    double carbonCombustible = carbonRaw * coefficientTransitionToCombustible;
    double sulfurCombustible = sulfurRaw * coefficientTransitionToCombustible;
    double nitrogenCombustible = nitrogenRaw * coefficientTransitionToCombustible;
    double oxygenCombustible = oxygenRaw * coefficientTransitionToCombustible;

    double testCombustible = hydrogenCombustible + carbonCombustible + sulfurCombustible + nitrogenCombustible + oxygenCombustible;

    double lowerHeatingValue = (339 * carbonRaw + 1030 * hydrogenRaw - 108.8 * (oxygenRaw - sulfurRaw) - 25 * moistureRaw) / 1000;
    double lowerHeatingValueDry = (lowerHeatingValue + 0.025 * moistureRaw) * (100 / (100 - moistureRaw));
    double lowerHeatingValueCombustible = (lowerHeatingValue + 0.025 * moistureRaw) * (100 / (100 - moistureRaw - ashRaw));

    if ((testDry - 100).abs() <= 1 && (testCombustible - 100).abs() <= 1) {
      setState(() {
        result = '''
Coefficient of transition to dry mass: ${coefficientTransitionToDry.toStringAsFixed(3)}
Coefficient of transition to combustible mass: ${coefficientTransitionToCombustible.toStringAsFixed(3)}

Dry mass:
Hᴰ=${hydrogenDry.toStringAsFixed(3)}%, Cᴰ=${carbonDry.toStringAsFixed(3)}%, 
Sᴰ=${sulfurDry.toStringAsFixed(3)}%, Nᴰ=${nitrogenDry.toStringAsFixed(3)}%, 
Oᴰ=${oxygenDry.toStringAsFixed(3)}%, Aᴰ=${ashDry.toStringAsFixed(3)}%
TestDry: ${testDry.toStringAsFixed(3)}%

Combustible mass:
Hᶜ=${hydrogenCombustible.toStringAsFixed(3)}%, Cᶜ=${carbonCombustible.toStringAsFixed(3)}%, 
Sᶜ=${sulfurCombustible.toStringAsFixed(3)}%, Nᶜ=${nitrogenCombustible.toStringAsFixed(3)}%, 
Oᶜ=${oxygenCombustible.toStringAsFixed(3)}%
TestCombustible: ${testCombustible.toStringAsFixed(3)}%

Lower heating value: ${lowerHeatingValue.toStringAsFixed(3)} MJ/kg
Dry: ${lowerHeatingValueDry.toStringAsFixed(3)} MJ/kg
Combustible: ${lowerHeatingValueCombustible.toStringAsFixed(3)} MJ/kg
''';
      });
    } else {
      setState(() {
        result = '''
Incorrect or inaccurate components:
TestDry: ${testDry.toStringAsFixed(3)}%
TestCombustible: ${testCombustible.toStringAsFixed(3)}%
Please try again.
''';
      });
    }
  }

  Widget inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fuel Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            inputField("H, %", _hr),
            inputField("C, %", _cr),
            inputField("S, %", _sr),
            inputField("N, %", _nr),
            inputField("O, %", _or),
            inputField("W, % (Moisture)", _wr),
            inputField("A, % (Ash)", _ar),
            SizedBox(height: 12),
            ElevatedButton(onPressed: calculate, child: Text("Calculate")),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

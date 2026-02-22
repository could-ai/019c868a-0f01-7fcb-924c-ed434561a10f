import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class SimplePendulumScreen extends StatefulWidget {
  const SimplePendulumScreen({super.key});

  @override
  State<SimplePendulumScreen> createState() => _SimplePendulumScreenState();
}

class _SimplePendulumScreenState extends State<SimplePendulumScreen> {
  // Data: Length (m), Period (s)
  final List<Map<String, double>> _data = [];
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  void _addData() {
    final l = double.tryParse(_lengthController.text);
    final t = double.tryParse(_periodController.text);
    if (l != null && t != null) {
      setState(() {
        _data.add({'L': l, 'T': t});
        _data.sort((a, b) => a['L']!.compareTo(b['L']!));
      });
      _lengthController.clear();
      _periodController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Péndulo Simple')),
      body: Row(
        children: [
          // Input Section
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Ingreso de Datos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _lengthController,
                    decoration: const InputDecoration(labelText: 'Longitud L (m)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _periodController,
                    decoration: const InputDecoration(labelText: 'Periodo T (s)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _addData, child: const Text('Agregar Dato')),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        final point = _data[index];
                        return ListTile(
                          title: Text('L: ${point['L']} m'),
                          subtitle: Text('T: ${point['T']} s'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => setState(() => _data.removeAt(index)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Graph Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Gráfica T² vs L', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _data.isEmpty
                        ? const Center(child: Text('Agrega datos para ver la gráfica'))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true),
                              titlesData: const FlTitlesData(
                                bottomTitles: AxisTitles(axisNameWidget: Text('Longitud L (m)')),
                                leftTitles: AxisTitles(axisNameWidget: Text('Periodo² (s²)')),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _data.map((p) => FlSpot(p['L']!, pow(p['T']!, 2).toDouble())).toList(),
                                  isCurved: false,
                                  color: Colors.blue,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                  ),
                  if (_data.length > 1) _buildAnalysis(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysis() {
    // Simple Linear Regression for T^2 = (4pi^2/g) * L
    // y = mx
    double sumXY = 0;
    double sumX2 = 0;
    for (var p in _data) {
      double x = p['L']!;
      double y = pow(p['T']!, 2).toDouble();
      sumXY += x * y;
      sumX2 += x * x;
    }
    double m = sumXY / sumX2; // Slope assuming intercept is 0
    double g = (4 * pow(pi, 2)) / m;

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Pendiente (m): ${m.toStringAsFixed(4)} s²/m'),
            Text('Gravedad calculada (g): ${g.toStringAsFixed(4)} m/s²', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

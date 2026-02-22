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
  final TextEditingController _theoreticalGravityController = TextEditingController(text: '9.78'); // Valor típico en laboratorio

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
      appBar: AppBar(title: const Text('Péndulo Simple: Análisis T² vs L')),
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: _lengthController,
                    decoration: const InputDecoration(labelText: 'Longitud L (m)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _periodController,
                    decoration: const InputDecoration(labelText: 'Periodo T (s)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _addData,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Dato'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                  ),
                  const Divider(),
                  TextField(
                    controller: _theoreticalGravityController,
                    decoration: const InputDecoration(labelText: 'Gravedad Teórica (m/s²)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (val) => setState(() {}),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        final point = _data[index];
                        return ListTile(
                          dense: true,
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
                  const Text('Gráfica Linealizada: T² vs L', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _data.isEmpty
                        ? const Center(child: Text('Agrega datos para ver la gráfica y el análisis'))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  axisNameWidget: const Text('Longitud L (m)'),
                                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val, meta) => Text(val.toStringAsFixed(2))),
                                ),
                                leftTitles: AxisTitles(
                                  axisNameWidget: const Text('Periodo² T² (s²)'),
                                  sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (val, meta) => Text(val.toStringAsFixed(1))),
                                ),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                // Puntos experimentales
                                LineChartBarData(
                                  spots: _data.map((p) => FlSpot(p['L']!, pow(p['T']!, 2).toDouble())).toList(),
                                  isCurved: false,
                                  color: Colors.blue,
                                  barWidth: 0,
                                  dotData: const FlDotData(show: true),
                                ),
                                // Línea de tendencia (Regresión)
                                if (_data.length > 1) _getRegressionLine(),
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

  LineChartBarData _getRegressionLine() {
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    int n = _data.length;
    for (var p in _data) {
      double x = p['L']!;
      double y = pow(p['T']!, 2).toDouble();
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    double m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    double b = (sumY - m * sumX) / n;

    double minX = _data.first['L']!;
    double maxX = _data.last['L']!;

    return LineChartBarData(
      spots: [
        FlSpot(minX, m * minX + b),
        FlSpot(maxX, m * maxX + b),
      ],
      isCurved: false,
      color: Colors.red,
      barWidth: 2,
      dotData: const FlDotData(show: false),
    );
  }

  Widget _buildAnalysis() {
    // Linear Regression for T^2 = (4pi^2/g) * L
    // y = mx + b
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    int n = _data.length;
    for (var p in _data) {
      double x = p['L']!;
      double y = pow(p['T']!, 2).toDouble();
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    
    double m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    double b_intercept = (sumY - m * sumX) / n;
    
    // g = 4pi^2 / m
    double g_exp = (4 * pow(pi, 2)) / m;
    double g_theo = double.tryParse(_theoreticalGravityController.text) ?? 9.8;
    double error = ((g_exp - g_theo).abs() / g_theo) * 100;

    // R^2 calculation
    double meanY = sumY / n;
    double ssTot = 0, ssRes = 0;
    for (var p in _data) {
      double x = p['L']!;
      double y = pow(p['T']!, 2).toDouble();
      double yPred = m * x + b_intercept;
      ssTot += pow(y - meanY, 2);
      ssRes += pow(y - yPred, 2);
    }
    double r2 = 1 - (ssRes / ssTot);

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultados del Análisis:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Ecuación de la recta: T² = ${m.toStringAsFixed(4)} L + ${b_intercept.toStringAsFixed(4)}'),
            Text('Coeficiente de determinación (R²): ${r2.toStringAsFixed(4)}'),
            const Divider(),
            Text('Gravedad Experimental (g): ${g_exp.toStringAsFixed(4)} m/s²', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            Text('Gravedad Teórica: $g_theo m/s²'),
            Text('Error Porcentual: ${error.toStringAsFixed(2)} %', style: TextStyle(fontWeight: FontWeight.bold, color: error < 5 ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}

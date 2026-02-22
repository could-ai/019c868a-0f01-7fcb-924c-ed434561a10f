import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class CompoundPendulumScreen extends StatefulWidget {
  const CompoundPendulumScreen({super.key});

  @override
  State<CompoundPendulumScreen> createState() => _CompoundPendulumScreenState();
}

class _CompoundPendulumScreenState extends State<CompoundPendulumScreen> {
  final List<Map<String, double>> _data = [];
  final TextEditingController _distController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _theoreticalGravityController = TextEditingController(text: '9.78');

  void _addData() {
    final d = double.tryParse(_distController.text);
    final t = double.tryParse(_periodController.text);
    if (d != null && t != null) {
      setState(() {
        _data.add({'d': d, 'T': t});
        _data.sort((a, b) => a['d']!.compareTo(b['d']!));
      });
      _distController.clear();
      _periodController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Péndulo Compuesto: Análisis T²d vs d²')),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Ingreso de Datos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _distController,
                    decoration: const InputDecoration(labelText: 'Distancia al CM (d) [m]', border: OutlineInputBorder()),
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
                          title: Text('d: ${point['d']} m'),
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
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Linealización: T²d vs d²', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _data.isEmpty
                        ? const Center(child: Text('Agrega datos para ver la gráfica de linealización'))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  axisNameWidget: const Text('d² (m²)'),
                                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val, meta) => Text(val.toStringAsFixed(2))),
                                ),
                                leftTitles: AxisTitles(
                                  axisNameWidget: const Text('T²d (s²m)'),
                                  sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (val, meta) => Text(val.toStringAsFixed(1))),
                                ),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                // Puntos linealizados (X=d^2, Y=T^2*d)
                                LineChartBarData(
                                  spots: _data.map((p) {
                                    double d = p['d']!;
                                    double t = p['T']!;
                                    return FlSpot(pow(d, 2).toDouble(), pow(t, 2) * d);
                                  }).toList(),
                                  isCurved: false,
                                  color: Colors.orange,
                                  barWidth: 0,
                                  dotData: const FlDotData(show: true),
                                ),
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
    // Linearization: T^2*d = (4pi^2/g)*d^2 + (4pi^2/g)*k^2
    // Y = mX + b
    // Y = T^2*d, X = d^2
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    int n = _data.length;
    
    for (var p in _data) {
      double d = p['d']!;
      double t = p['T']!;
      double x = pow(d, 2).toDouble();
      double y = pow(t, 2) * d;
      
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    
    double m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    double b = (sumY - m * sumX) / n;

    double minX = pow(_data.first['d']!, 2).toDouble();
    double maxX = pow(_data.last['d']!, 2).toDouble();

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
    // Linearization: T^2*d = (4pi^2/g)*d^2 + (4pi^2/g)*k^2
    // Slope (m) = 4pi^2/g  => g = 4pi^2/m
    // Intercept (b) = (4pi^2/g)*k^2 = m*k^2 => k = sqrt(b/m)
    
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    int n = _data.length;
    
    for (var p in _data) {
      double d = p['d']!;
      double t = p['T']!;
      double x = pow(d, 2).toDouble();
      double y = pow(t, 2) * d;
      
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    
    double m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    double b_intercept = (sumY - m * sumX) / n;
    
    double g_exp = (4 * pow(pi, 2)) / m;
    double k_radius = sqrt(b_intercept / m);
    
    double g_theo = double.tryParse(_theoreticalGravityController.text) ?? 9.8;
    double error = ((g_exp - g_theo).abs() / g_theo) * 100;

    // R^2
    double meanY = sumY / n;
    double ssTot = 0, ssRes = 0;
    for (var p in _data) {
      double d = p['d']!;
      double t = p['T']!;
      double x = pow(d, 2).toDouble();
      double y = pow(t, 2) * d;
      double yPred = m * x + b_intercept;
      ssTot += pow(y - meanY, 2);
      ssRes += pow(y - yPred, 2);
    }
    double r2 = 1 - (ssRes / ssTot);

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultados del Análisis (Linealización):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Ecuación: T²d = ${m.toStringAsFixed(4)} d² + ${b_intercept.toStringAsFixed(4)}'),
            Text('Coeficiente de determinación (R²): ${r2.toStringAsFixed(4)}'),
            const Divider(),
            Text('Gravedad Experimental (g): ${g_exp.toStringAsFixed(4)} m/s²', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            Text('Radio de Giro (k): ${k_radius.toStringAsFixed(4)} m', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            Text('Error Porcentual (g): ${error.toStringAsFixed(2)} %', style: TextStyle(fontWeight: FontWeight.bold, color: error < 5 ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}

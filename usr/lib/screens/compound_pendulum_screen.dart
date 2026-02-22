import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompoundPendulumScreen extends StatefulWidget {
  const CompoundPendulumScreen({super.key});

  @override
  State<CompoundPendulumScreen> createState() => _CompoundPendulumScreenState();
}

class _CompoundPendulumScreenState extends State<CompoundPendulumScreen> {
  final List<Map<String, double>> _data = [];
  final TextEditingController _distController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

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
      appBar: AppBar(title: const Text('Péndulo Compuesto')),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Datos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _distController,
                    decoration: const InputDecoration(labelText: 'Distancia al CM (m)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _periodController,
                    decoration: const InputDecoration(labelText: 'Periodo T (s)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _addData, child: const Text('Agregar')),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        final point = _data[index];
                        return ListTile(
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
                  const Text('Gráfica T vs d', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _data.isEmpty
                        ? const Center(child: Text('Agrega datos para ver la gráfica'))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true),
                              titlesData: const FlTitlesData(
                                bottomTitles: AxisTitles(axisNameWidget: Text('Distancia d (m)')),
                                leftTitles: AxisTitles(axisNameWidget: Text('Periodo T (s)')),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _data.map((p) => FlSpot(p['d']!, p['T']!)).toList(),
                                  isCurved: true,
                                  color: Colors.orange,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

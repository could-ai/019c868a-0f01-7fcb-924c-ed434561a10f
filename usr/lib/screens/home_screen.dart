import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de Informe Física 3'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildMenuCard(
              context,
              'Resumen (Abstract)',
              'Redacta y estructura el resumen del informe.',
              Icons.article,
              '/abstract',
              Colors.blue.shade100,
            ),
            _buildMenuCard(
              context,
              'Péndulo Simple',
              'Análisis de datos y gráficas T² vs L.',
              Icons.show_chart,
              '/simple_pendulum',
              Colors.green.shade100,
            ),
            _buildMenuCard(
              context,
              'Péndulo Compuesto',
              'Análisis de momento de inercia y gráficas.',
              Icons.science,
              '/compound_pendulum',
              Colors.orange.shade100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, IconData icon, String route, Color color) {
    return Card(
      color: color,
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.black54),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}

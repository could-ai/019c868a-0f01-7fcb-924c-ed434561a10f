import 'package:flutter/material.dart';

class AbstractScreen extends StatefulWidget {
  const AbstractScreen({super.key});

  @override
  State<AbstractScreen> createState() => _AbstractScreenState();
}

class _AbstractScreenState extends State<AbstractScreen> {
  final TextEditingController _controller = TextEditingController();

  final String _guide = '''
Guía para el Resumen:
1. Objetivo: ¿Qué se buscaba estudiar? (Relación entre periodo y longitud/masa).
2. Metodología: Breve descripción de cómo se midieron los datos (sensores, cronómetro, varillas).
3. Resultados Principales: Valor experimental de la gravedad obtenido, errores porcentuales.
4. Conclusión: ¿Se cumplió la teoría?
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redacción del Resumen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(_guide),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu resumen aquí...',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

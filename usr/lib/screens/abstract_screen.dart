import 'package:flutter/material.dart';

class AbstractScreen extends StatefulWidget {
  const AbstractScreen({super.key});

  @override
  State<AbstractScreen> createState() => _AbstractScreenState();
}

class _AbstractScreenState extends State<AbstractScreen> {
  final TextEditingController _controller = TextEditingController();

  final String _template = '''
RESUMEN

En esta práctica de laboratorio se estudió el comportamiento físico del péndulo simple y el péndulo compuesto, con el objetivo de determinar experimentalmente la aceleración de la gravedad local y el radio de giro de un cuerpo rígido.

Para el péndulo simple, se midió el periodo de oscilación para diferentes longitudes de cuerda. Mediante un análisis gráfico de la relación lineal entre el cuadrado del periodo (T²) y la longitud (L), se obtuvo una pendiente experimental que permitió calcular la gravedad. El valor obtenido fue de g = [INSERTAR VALOR] m/s², lo cual representa un error porcentual del [INSERTAR ERROR]% respecto al valor teórico de 9.78 m/s².

En el caso del péndulo compuesto, se registraron los periodos de oscilación variando la distancia del eje de rotación al centro de masa. Se aplicó el teorema de los ejes paralelos y se realizó una linealización de la ecuación del movimiento (graficando T²d vs d²). A partir de la pendiente y el intercepto de la recta de ajuste, se determinó nuevamente la gravedad experimental y el radio de giro (k) del objeto, obteniendo valores de g = [INSERTAR VALOR] m/s² y k = [INSERTAR VALOR] m.

Los resultados confirman la validez de los modelos teóricos para pequeñas oscilaciones y demuestran la dependencia del periodo con la distribución de masa en el péndulo físico.
''';

  @override
  void initState() {
    super.initState();
    _controller.text = _template;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redacción del Resumen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Plantilla Generada Automáticamente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa los valores entre corchetes [ ] con los datos obtenidos en las secciones de análisis.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Acción para copiar o guardar (simulada)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resumen listo para copiar')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copiar al Portapapeles'),
            ),
          ],
        ),
      ),
    );
  }
}

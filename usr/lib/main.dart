import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/abstract_screen.dart';
import 'screens/simple_pendulum_screen.dart';
import 'screens/compound_pendulum_screen.dart';

void main() {
  runApp(const PhysicsReportApp());
}

class PhysicsReportApp extends StatelessWidget {
  const PhysicsReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Informe Física 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/abstract': (context) => const AbstractScreen(),
        '/simple_pendulum': (context) => const SimplePendulumScreen(),
        '/compound_pendulum': (context) => const CompoundPendulumScreen(),
      },
    );
  }
}

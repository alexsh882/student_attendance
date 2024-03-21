import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomar asistencia'),
      ),
      body: const Center(
        child: Text('Pantalla tomar asistencias.'),
      ),
    );
  }
}

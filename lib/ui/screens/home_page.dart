import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
                width: 300,
                height: 100,                
                child: Text(
                    'Pulsa el botón de acuerdo a la acción que deseas realizar:',textAlign: TextAlign.center,)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'attendance');
              },
              child: const Text('Tomar asistencia'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'students');
              },
              child: const Text('Ver estudiantes'),
            ),
          ],
        ),
      ),
    );
  }
}

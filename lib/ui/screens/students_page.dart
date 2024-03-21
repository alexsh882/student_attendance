import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {

       
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudiantes'),
      ),
      body: const Center(
        child: Text('Pantalla donde se mostrarán los estudiantes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'add-student');
        },
        tooltip: 'Agregar Nuevo Estudiante',
        child: const Icon(Icons.add),
      ),
    );
  }
}

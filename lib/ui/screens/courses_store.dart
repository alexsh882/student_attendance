import 'package:flutter/material.dart';

class CoursesStore extends StatefulWidget {
  const CoursesStore({super.key});

  @override
  State<CoursesStore> createState() => _CoursesStoreState();
}

class _CoursesStoreState extends State<CoursesStore> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Nombre de la cursada',
                    hintText: 'Ej: TSDSMP 2do año.'),
              ),
              const SizedBox(
                height: 40,
                child: Text('Se tomará el año actual como el año de cursado.'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

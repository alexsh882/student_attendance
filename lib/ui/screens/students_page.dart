import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_attendance/main.dart';
import 'package:student_attendance/src/models/models.dart';
import 'package:student_attendance/src/resources/students_dto.dart';

class StudentPage extends StatelessWidget with StudentDTO {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Course course = ModalRoute.of(context)!.settings.arguments as Course;

    return Scaffold(
        appBar: AppBar(
          title: Text(course.name),
        ),
        body: ValueListenableBuilder(
            valueListenable: studentBox.listenable(),
            builder: (context, box, widget) {
              final students = courseBox.get(course.key)!.students;

              if (students.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                        'No hay estudiantes registrados para este curso, agrega uno con el botón de abajo.'),
                  ),
                );
              }

              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext context, int i) {
                  final student = course.students[i];
                  return ListTile(
                    title: Text('${student.firstName} ${student.lastName}'),
                    subtitle: Text(student.dni.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => dialogAddStudentToCourse(context,
                              student: student, course: course),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              dialogDeleteStudent(context, student, course),
                        )
                      ],
                    ),
                  );
                },
              );
            }),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.up,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.regular,
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.close),
            fabSize: ExpandableFabSize.small,
            shape: const CircleBorder(),
          ),
          children: [
            FloatingActionButton(
              isExtended: true,
              child: const Icon(Icons.person_add),
              onPressed: () =>
                  dialogAddStudentToCourse(context, course: course),
            ),
            FloatingActionButton(
              isExtended: true,
              heroTag: null,
              child: const Icon(Icons.calendar_today),
              onPressed: () => Navigator.pushNamed(context, 'attendance'),
            ),
          ],
        ));
  }

  dialogAddStudentToCourse(BuildContext context,
      {Student? student, Course? course}) {
    final formKey = GlobalKey<FormState>();

    String firstName = '';
    String lastName = '';
    int dni = 0;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Agregar Estudiante'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    initialValue: student?.firstName ?? '',
                    onSaved: (newValue) => firstName = newValue!,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese un apellido';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                    ),
                  ),
                  TextFormField(
                    onSaved: (newValue) => lastName = newValue!,
                    initialValue: student?.lastName ?? '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                  TextFormField(
                    initialValue: student?.dni.toString() ?? '',
                    onSaved: (newValue) => dni = int.parse(newValue!),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese un DNI';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor ingrese un DNI numérico';
                      }
                      if (value.length < 7 || value.length > 10) {
                        return 'Por favor ingrese un DNI válido';
                      }

                      final foundStudents = searchStudents(value)
                          .where((element) => element.dni == int.parse(value));

                      if (foundStudents.isNotEmpty &&
                          student?.id != foundStudents.first.id) {
                        return 'El DNI ya se encuentra registrado';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'DNI',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (student?.id != null) {
                      student?.firstName = firstName;
                      student?.lastName = lastName;
                      student?.dni = dni;
                      updateStudent(student!);
                    } else {
                      addStudent(
                        Student(
                          id: studentBox.length + 1,
                          firstName: firstName,
                          lastName: lastName,
                          dni: dni,
                          attendances: HiveList<Attendance>(attendanceBox),
                        ),
                        course!,
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }

  dialogDeleteStudent(BuildContext context, Student student, Course course) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Eliminar Estudiante'),
            content: Text(
                '¿Está seguro que desea eliminar a ${student.firstName} ${student.lastName}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  deleteStudent(student, course);
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }
}

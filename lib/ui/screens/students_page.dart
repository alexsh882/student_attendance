import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_attendance/main.dart';
import 'package:student_attendance/src/models/models.dart';
import 'package:student_attendance/src/resources/students_dto.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> with StudentDTO {
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
              final students = course.students;
              if (students.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                        'No hay estudiantes registrados para este curso, agrega uno con el botón de abajo.'),
                  ),
                );
              }

              students.sort((a, b) => a.lastName.compareTo(b.lastName));

              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext context, int i) {
                  final student = students[i];
                  return ListTile(
                    title: Text('${student.lastName} ${student.firstName}'),
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
          distance: 70.0,
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
            Row(
              children: [
                const Text('Agregar Estudiante'),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  isExtended: true,
                  child: const Icon(Icons.person_add),
                  onPressed: () =>
                      dialogAddStudentToCourse(context, course: course),
                ),
              ],
            ),
            courseBox.get(course.key)!.students.isEmpty
                ? Container()
                : Row(
                    children: [
                      const Text('Tomar Asistencia'),
                      const SizedBox(
                        width: 10,
                      ),
                      FloatingActionButton(
                        isExtended: true,
                        heroTag: null,
                        child: const Icon(Icons.calendar_today),
                        onPressed: () => Navigator.pushNamed(
                            context, 'attendance',
                            arguments: course.students),
                      )
                    ],
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
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      initialValue: student?.lastName ?? '',
                      onSaved: (newValue) => lastName = newValue!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingrese un apellido';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                    ),
                    TextFormField(
                      onSaved: (newValue) => firstName = newValue!,
                      initialValue: student?.firstName ?? '',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
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

                        final foundStudents = searchStudents(value).where(
                            (element) => element.dni == int.parse(value));

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
                      student?.firstName = firstName.trim();
                      student?.lastName = lastName.trim();
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

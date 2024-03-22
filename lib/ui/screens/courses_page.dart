import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_attendance/main.dart';
import 'package:student_attendance/src/models/models.dart';
import 'package:student_attendance/src/resources/courses_dto.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> with CoursesDTO {
  TextEditingController courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Course>>(
        valueListenable: courseBox.listenable(),
        builder: (context, box, widget) {
          List<Course> courses = box.values.toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Cursos'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(0.8),
              child: courses.isEmpty
                  ? const Center(
                      child:
                          Text('No se hallaron cursos, por favor agregue uno.'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (BuildContext context, int i) {
                        final course = box.getAt(i);
                        return ListTile(
                          title: Text(course?.name ?? ''),
                          subtitle: Text(course?.year.toString() ?? ''),
                          onTap: () => Navigator.pushNamed(context, 'students',
                              arguments: course),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => courseCreateEdit(context,
                                      course: course)),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    dialogDeleteCourse(context, course),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => courseCreateEdit(context),
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  courseCreateEdit(BuildContext context, {Course? course}) {
    final textTitle = course?.id != null ? 'Editar curso' : 'Agregar curso';

    if (course != null) {
      courseController.text = course.name;
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(textTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: courseController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre de la cursada',
                      hintText: 'Ej: TSDSMP 2do año.'),
                ),
                const SizedBox(
                  height: 40,
                  child:
                      Text('Se tomará el año actual como el año de cursado.'),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  if (courseController.text.isNotEmpty) {
                    if (course?.id != null) {
                      course!.name = courseController.text;
                      updateCourse(course);
                    } else {
                      addCourse(Course(
                          id: courseBox.values.length + 1,
                          name: courseController.text,
                          year: course?.year ?? DateTime.now().year,
                          students: HiveList<Student>(studentBox)));
                    }
                    Navigator.pop(context);
                    courseController.clear();
                  }
                },
                child: const Text('Guardar'),
              )
            ],
          );
        });
  }

  dialogDeleteCourse(BuildContext context, Course? course) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Eliminar curso'),
              content: const Text('¿Está seguro que desea eliminar el curso?'),
              actions: [
                OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () {
                    deleteCourse(course!);
                    Navigator.pop(context);
                  },
                  child: const Text('Eliminar'),
                )
              ],
            ));
  }
}

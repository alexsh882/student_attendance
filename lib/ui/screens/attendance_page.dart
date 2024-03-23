import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_attendance/main.dart';
import 'package:student_attendance/src/models/models.dart';
import 'package:student_attendance/src/resources/attendances_dto.dart';

class AttendancePage extends StatelessWidget with AttendanceDTO {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Student> students =
        ModalRoute.of(context)!.settings.arguments as List<Student>;
    String dateOfToday =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencias - $dateOfToday'),
      ),
      body: ValueListenableBuilder(
          valueListenable: studentBox.listenable(),
          builder: (context, box, widget) {
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
                      !studentIsPresent(student)
                          ? const Icon(Icons.check)
                          : IconButton(
                              icon: const Icon(Icons.person_add_alt_1_outlined),
                              onPressed: () =>
                                  addAttendance(context, student: student),
                            ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  bool studentIsPresent(Student student) {
    final attendanceToday = student.attendances
        .where((attendance) =>
            attendance.date.day == DateTime.now().day &&
            attendance.date.month == DateTime.now().month &&
            attendance.date.year == DateTime.now().year &&
            attendance.present == true)
        .toList();
    print(attendanceToday.length);
    return attendanceToday.isEmpty;
  }

  addAttendance(BuildContext context, {required Student student}) {
    final attendanceToday = studentIsPresent(student);
    if (attendanceToday) {
      addAttendanceToStudent(
          student,
          Attendance(
              id: attendanceBox.length + 1,
              date: DateTime.now(),
              present: true));
    }
    print(attendanceToday);
  }
}

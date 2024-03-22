import 'package:student_attendance/main.dart';
import 'package:student_attendance/src/models/models.dart';

mixin StudentDTO {
  addStudent(Student student, Course course) async {
    await studentBox.add(student);
    course.students.add(student);
    await courseBox.put(course.key, course);
  }

  updateStudent(Student student) async {
    await studentBox.put(student.key, student);
  }

  deleteStudent(Student student, Course course) async {
    course.students.remove(student);
    await studentBox.delete(student.key);
    await courseBox.put(course.key, course);
  }

  List<Student> getAllStudents() {
    return studentBox.values.toList();
  }

  Student? getStudentById(int key) {
    return studentBox.get(key);
  }

  List<Student> searchStudents(String query) {
    return studentBox.values
        .where((student) =>
            student.firstName.toLowerCase().contains(query.toLowerCase()) ||
            student.lastName.toLowerCase().contains(query.toLowerCase()) ||
            student.dni.toString().contains(query))
        .toList();
  }

  List<Attendance> getStudentAttendances(Student student) {
    return student.attendances;
  }
}


import 'package:student_attendance/main.dart';
import 'package:student_attendance/src/models/models.dart';

mixin AttendanceDTO {
  addAttendanceToStudent(Student student, Attendance attendance) async {
    student.attendances.add(attendance);
    await studentBox.put(student.key, student);
  }

  updateAttendance(Attendance attendance) async {
    await attendanceBox.put(attendance.key, attendance);
  }

  deleteAttendance(Attendance attendance, Student student) async {
    student.attendances.remove(attendance);
    await studentBox.put(student.key, student);
    await attendanceBox.delete(attendance.key);
  }

  
}
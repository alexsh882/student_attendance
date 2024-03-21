import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_attendance/src/models/models.dart';

import 'package:student_attendance/ui/app.dart';

late Box<YearCourses> courseBox;
late Box<Student> studentBox;
late Box<Attendance> attendanceBox;

const String courseBoxName = 'courseBox';
const String studentBoxName = 'studentBox';
const String attendanceBoxName = 'attendanceBox';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(YearCoursesAdapter());
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(AttendanceAdapter());

  courseBox = await Hive.openBox<YearCourses>(courseBoxName);
  studentBox = await Hive.openBox<Student>(studentBoxName);
  attendanceBox = await Hive.openBox<Attendance>(attendanceBoxName);

  runApp(const MyApp());
}

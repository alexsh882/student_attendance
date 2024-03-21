import 'package:hive_flutter/adapters.dart';
import 'package:student_attendance/src/models/models.dart';

part 'year_courses.g.dart';

@HiveType(typeId: 0, adapterName: 'YearCoursesAdapter')
class YearCourses extends HiveObject {
  YearCourses({
    required this.id,
    required this.year,
    required this.students,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int year;

  @HiveField(2)
  final HiveList<Student> students;
}

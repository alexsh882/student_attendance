import 'package:hive_flutter/adapters.dart';
import 'package:student_attendance/src/models/models.dart';

part 'course.g.dart';

@HiveType(typeId: 0, adapterName: 'CourseAdapter')
class Course extends HiveObject {
  Course({
    required this.id,
    required this.year,
    required this.name,
    required this.students,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  int year;

  @HiveField(2)
  String name;

  @HiveField(3)
  HiveList<Student> students;
}

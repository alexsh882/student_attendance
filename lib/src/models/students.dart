import 'package:hive_flutter/adapters.dart';
import 'package:student_attendance/src/models/models.dart';

part 'students.g.dart';

@HiveType(typeId: 1, adapterName: 'StudentAdapter')
class Student extends HiveObject {
  Student({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.dni,
    required this.attendances,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final int dni;

  @HiveField(4)
  final HiveList<Attendance> attendances;
}

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
  String lastName;

  @HiveField(2)
  String firstName;

  @HiveField(3)
  int dni;

  @HiveField(4)
  HiveList<Attendance> attendances;
}

import 'package:hive_flutter/hive_flutter.dart';


part 'attendance.g.dart';

@HiveType(typeId: 2, adapterName: 'AttendanceAdapter')
class Attendance extends HiveObject {
  Attendance({
    required this.id,
    required this.date,
    required this.present,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final bool present;

  
}

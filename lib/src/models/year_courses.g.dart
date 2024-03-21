// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_courses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YearCoursesAdapter extends TypeAdapter<YearCourses> {
  @override
  final int typeId = 0;

  @override
  YearCourses read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YearCourses(
      id: fields[0] as int,
      year: fields[1] as int,
      students: (fields[2] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, YearCourses obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.students);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearCoursesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

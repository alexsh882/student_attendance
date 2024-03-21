import 'package:student_attendance/main.dart';
import 'package:student_attendance/src/models/models.dart';

mixin CoursesDTO {
  addCourse(Course course) async {
    await courseBox.add(course);
  }

  updateCourse(Course course) async {
    await course.save();
  }

  deleteCourse(Course course) async {
    course.students.clear();
    await courseBox.delete(course.key);
  }

  List<Course> getAllCourses() {
    return courseBox.values.toList();
  }

  Course? getCourseById(int key) {
    return courseBox.get(key);
  }

  List<Student> getCourseStudents(Course course) {
    return course.students;
  }

  List<Course> getCoursesByNames(String name) {
    return courseBox.values.where((course) => course.name == name).toList();
  }

  List<Course> getCourseByYear(int year) {
    return courseBox.values.where((course) => course.year == year).toList();
  }
}

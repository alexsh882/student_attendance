import 'package:flutter/material.dart';

import 'package:student_attendance/ui/screens/screens.dart';

class AppRoutes {
  static const String initialRoute = 'home';

  static Map<String, WidgetBuilder> routes = {
    'home': (context) => const HomePage(),
    'students': (context) => const StudentPage(),
    'add-student': (context) => const StudentStore(),
    'attendance': (context) => const AttendancePage(),
    'courses': (context) => const CoursesPage(),
    'add-course': (context) => const CoursesStore(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const PageNotFound(),
    );
  }
}

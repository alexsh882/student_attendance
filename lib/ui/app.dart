import 'package:flutter/material.dart';
import 'package:student_attendance/ui/screens/screens.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Asistencias App',
      initialRoute: 'home',
      routes: <String, WidgetBuilder>{
        'home': (context) => const HomePage(),
        'attendance': (context) => const AttendancePage(),
        'students': (context) => const StudentPage()
      },
    );
  }
}

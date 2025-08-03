import 'package:flutter/material.dart';
import 'package:horarios_app/view_model/attendance_view_model.dart';
import 'package:horarios_app/views/attendances_screen.dart';
import 'package:horarios_app/views/create_attendance.dart';
import 'package:horarios_app/views/edit_attendance.dart';
import 'package:horarios_app/views/insert_attendance.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AttendanceViewModel())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Horarios INE',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CreateAttendance(),
      routes: {
        '/attendances': (context) => const AttendancesScreen(),
        '/createAttendance': (context) => const CreateAttendance(),
        '/editAttendances': (context) => AttendanceEdit(),
        '/insertAttendance': (context) => InsertAttendance(),
      },
    );
  }
}

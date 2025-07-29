import 'package:flutter/material.dart';
import 'package:horarios_app/view_model/attendance_view_model.dart';
import 'package:provider/provider.dart';

class AttendancesScreen extends StatefulWidget {
  const AttendancesScreen({super.key});

  @override
  State<AttendancesScreen> createState() => _AttendancesScreenState();
}

class _AttendancesScreenState extends State<AttendancesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceViewModel>(context, listen: false).getAttendances();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistencias')),
      body: Consumer<AttendanceViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: viewModel.attendances.length,
            itemBuilder: (context, index) {
              final attendance = viewModel.attendances[index];
              return ListTile(
                title: Text(attendance.type!),
                subtitle: Text(attendance.date!.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_outlined),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/editAttendances',
                      arguments: {'id': attendance.id, 'date': attendance.date},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AttendanceViewModel>(
            context,
            listen: false,
          ).getAttendances();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

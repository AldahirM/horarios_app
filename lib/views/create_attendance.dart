import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:horarios_app/models/attendance.dart';
import 'package:horarios_app/view_model/attendance_view_model.dart';
import 'package:provider/provider.dart';

class CreateAttendance extends StatefulWidget {
  const CreateAttendance({super.key});

  @override
  State<CreateAttendance> createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  @override
  Widget build(BuildContext context) {
    String type = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar nueva asistencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/insertAttendance');
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/attendances');
            },
          ),
        ],
      ),

      body: Consumer<AttendanceViewModel>(
        builder: (context, viewModel, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Registrar nueva asistencia',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GroupButton<String>(
                      buttons: [
                        ("Entrada"),
                        ("Salida comida"),
                        ("Entrada comida"),
                        ("Salida"),
                      ],
                      onSelected: (value, index, isSelected) {
                        type = value;
                      },
                      options: GroupButtonOptions(
                        crossGroupAlignment: CrossGroupAlignment.center,
                        textAlign: TextAlign.center,
                        selectedTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedTextStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        buttonHeight: 40,
                        buttonWidth: 80,
                        selectedColor: Colors.blue,
                        unselectedColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (type.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, selecciona un tipo de asistencia.',
                          ),
                        ),
                      );
                      return;
                    }
                    DateTime date = DateTime.now();
                    if (await viewModel.checkRegisteredTypesAttendances(
                      date,
                      type,
                    )) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Ya existe una asistencia registrada de tipo $type para hoy.',
                            ),
                          ),
                        );
                      }
                      return;
                    }
                    if (context.mounted) {
                      Attendance att = Attendance(type: type, date: date);
                      Provider.of<AttendanceViewModel>(
                        context,
                        listen: false,
                      ).createAttendance(att);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Asistencia registrada'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Registrar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.scale,
                      headerAnimationLoop: true,
                      title: "Precaución",
                      desc: "¿Quieres borrar todas las Asistencias?",
                      showCloseIcon: true,
                      btnCancelText: "No",
                      btnOkText: "Si",
                      btnCancelOnPress: () {
                        
                      },
                      btnOkOnPress: ()  {
                        Provider.of<AttendanceViewModel>(
                          context,
                          listen: false,
                        ).deleteAllData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Todas las asistencias borradas',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ).show();
                  },
                  child: Text("Borrar todas las asistencias"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

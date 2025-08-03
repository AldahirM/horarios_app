import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:horarios_app/models/attendance.dart';
import 'package:horarios_app/view_model/attendance_view_model.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class AttendanceEdit extends StatefulWidget {
  const AttendanceEdit({super.key});

  @override
  State<AttendanceEdit> createState() => _AttendanceEditState();
}

class _AttendanceEditState extends State<AttendanceEdit> {
  String type = '';
  DateTime? newDate;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int id = args['id'];
    final DateTime date = args['date'];
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Asistencia')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Editar Asistencia", style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
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
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                DateTime? aux = await showOmniDateTimePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2026),
                  type: OmniDateTimePickerType.dateAndTime,
                  is24HourMode: true,
                  isShowSeconds: true,
                  title: Text('Selecciona la fecha y hora'),
                );
                if (aux != null) {
                  newDate = aux;
                }
              },
              child: Text("Selecciona la fecha"),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (newDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Selecciona una fecha antes de guardar.',
                          ),
                        ),
                      );
                      return;
                    }
                    if (await Provider.of<AttendanceViewModel>(
                      context,
                      listen: false,
                    ).checkRegisteredTypesAttendances(newDate!, type)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ya existe una asistencia de este tipo para la fecha seleccionada.',
                            ),
                          ),
                        );
                      }
                      return;
                    }
                    if (context.mounted) {
                      Attendance att = Attendance(
                        id: id,
                        type: type,
                        date: newDate ?? DateTime.now(),
                      );
                      Provider.of<AttendanceViewModel>(
                        context,
                        listen: false,
                      ).updateAttendance(att);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Asistencia actualizada con el tipo ${att.type} y la fecha ${att.date.toString()}',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text("Guardar Cambios"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<AttendanceViewModel>(
                      context,
                      listen: false,
                    ).deleteAttendance(id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Asistencia eliminada'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Eliminar Asistencia"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:horarios_app/models/attendance.dart';
import 'package:horarios_app/view_model/attendance_view_model.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class InsertAttendance extends StatefulWidget {
  const InsertAttendance({super.key});

  @override
  State<InsertAttendance> createState() => _InsertAttendanceState();
}

class _InsertAttendanceState extends State<InsertAttendance> {
  String type = '';
  DateTime? newDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Asistencia'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            ElevatedButton(
              onPressed: () async {
                DateTime? aux = await showOmniDateTimePicker(
                  context: context,
                  initialDate: DateTime.now(),
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
                    } else {
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
                      } else {
                        if (context.mounted) {
                          Attendance att = Attendance(
                            type: type,
                            date: newDate!,
                          );
                          Provider.of<AttendanceViewModel>(
                            context,
                            listen: false,
                          ).createAttendance(att);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Asistencia registrada con la fecha ${att.date.toString()}',
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text("Guardar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
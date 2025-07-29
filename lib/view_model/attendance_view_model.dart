import 'package:flutter/foundation.dart';
import 'package:horarios_app/db/db_helper.dart';
import 'package:horarios_app/models/attendance.dart';

class AttendanceViewModel extends ChangeNotifier {
  final DbHelper db = DbHelper.instance;
  List<Attendance> _registeredAttendances = [];
  List<Attendance> _attendances = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Attendance> get attendances => _attendances;
  List<Attendance> get attendanceTypes => _registeredAttendances;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void createAttendance(Attendance att) async {
    if (att.type == null || att.date == null) {
      _errorMessage = 'Tipo de asistencia y fecha son requeridos';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      db.createNewAttendance(att);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void getAttendances() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _attendances = await db.getAttendances();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkRegisteredTypesAttendances(DateTime date, String type) async {
    if(_registeredAttendances.isEmpty){
    _registeredAttendances = await db.getTodayAttendances(date);
    }
    try {
      return _registeredAttendances.any((attendance) => attendance.type == type);
    } catch (e) {
      return false;
    }
  }

  void deleteAttendance(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await db.deleteAttendance(id);
      _attendances.removeWhere((attendance) => attendance.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void updateAttendance(Attendance att) async {
    if (att.type == null || att.date == null || att.id == null) {
      _errorMessage = 'Tipo de asistencia, fecha y ID son requeridos';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await db.updateAttendance(att);
      int index = _attendances.indexWhere((attendance) => attendance.id == att.id);
      if (index != -1) {
        _attendances[index] = att;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void deleteAllData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await db.deleteAllData();
      _attendances.clear();
      _registeredAttendances.clear();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}

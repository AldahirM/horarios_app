class Attendance {
  int? id;
  String? type;
  DateTime? date;


  Attendance({
    this.id,
    required this.type,
    required this.date,
  });
  Map<String, dynamic> toJsonDB() {
    return {
      'id': id,
      'type': type,
      'date': date?.toIso8601String(),
    };
  }
}
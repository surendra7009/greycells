import 'package:greycell_app/src/manager/main_model.dart';

class Student {
  final int slNo;
  final int rollNo;
  final String registrationNo;
  final String name;
  String status; // 'P' for Present, 'A' for Absent

  Student({
    required this.slNo,
    required this.rollNo,
    required this.registrationNo,
    required this.name,
    this.status = '',
  });
}

class AttendanceClass {
  final String className;
  final String section;
  final String timeSlot;
  final List<Student> students;

  AttendanceClass({
    required this.className,
    required this.section,
    required this.timeSlot,
    required this.students,
  });
}

class AttendanceRecord {
  final DateTime date;
  final int presentCount;
  final int absentCount;

  AttendanceRecord({
    required this.date,
    required this.presentCount,
    required this.absentCount,
  });
}

class NCAttendanceModel {
  final MainModel _mainModel;
  List<AttendanceRecord> _attendanceRecords = [];

  NCAttendanceModel(this._mainModel);

  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;

  Future<void> fetchAttendanceData() async {
    // TODO: Implement actual API call to fetch attendance data
    // For now, using dummy data
    _attendanceRecords = [
      AttendanceRecord(
        date: DateTime.now(),
        presentCount: 25,
        absentCount: 5,
      ),
      AttendanceRecord(
        date: DateTime.now().subtract(const Duration(days: 1)),
        presentCount: 28,
        absentCount: 2,
      ),
    ];
  }
} 
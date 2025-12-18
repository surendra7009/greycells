import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/attendance/nc_attendance_model.dart';
import 'package:greycell_app/src/views/webViewScreens/nc_attendance_marking_screen.dart';
import 'package:intl/intl.dart';

class NCAttendanceScreen extends StatefulWidget {
  final MainModel model;
  final String title;
  final String url;

  const NCAttendanceScreen({
    Key? key,
    required this.model,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  State<NCAttendanceScreen> createState() => _NCAttendanceScreenState();
}

class _NCAttendanceScreenState extends State<NCAttendanceScreen> {
  DateTime selectedDate = DateTime.now();
  String orderBy = 'Student Name';
  String attendanceName = 'Class Attendance';
  String attendanceFor = 'CBSE\\General\\2024-25\\IX - D';
  bool isLoading = false;

  final List<String> orderByOptions = [
    'Student Name',
    'Registration No.',
    'Roll No.',
  ];

  final List<String> attendanceNameOptions = [
    'Class Attendance',
  ];

  final List<String> attendanceForOptions = [
    'CBSE\\General\\2024-25\\IX - D',
    'CBSE\\General\\2024-25\\X - D',
  ];

  final List<Map<String, dynamic>> attendanceData = [
    {
      'name': 'Class Attendance',
      'for': 'CBSE\\General\\2024-25\\IX - D',
      'timeSlot': '07:30 AM - 07:45 AM',
      'locked': false,
      'taken': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormField('Attendance Date *', _buildDatePicker()),
            _buildFormField('Order By', _buildDropdown(
              orderBy, 
              orderByOptions,
              (value) => setState(() => orderBy = value)
            )),
            _buildFormField('Attendance Name', _buildDropdown(
              attendanceName, 
              attendanceNameOptions,
              (value) => setState(() => attendanceName = value)
            )),
            _buildFormField('Attendance For', _buildDropdown(
              attendanceFor, 
              attendanceForOptions,
              (value) => setState(() => attendanceFor = value)
            )),
            
            const SizedBox(height: 16),
            
            // Attendance table
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  // Header
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: primaryColor,
                        ),
                        children: [
                          _buildTableHeader('Attendance Name'),
                          _buildTableHeader('Attendance For'),
                          _buildTableHeader('Time Slot'),
                          _buildTableHeader('Lock Time'),
                        ]
                      ),
                    ],
                  ),
                  
                  // Content
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          _buildTableCell('Class Attendance'),
                          _buildTableCell('CBSE\\General\\2024-25\\IX - D'),
                          _buildTableCell('07:30 AM - 07:45 AM'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.yellow.shade800,
                              size: 20,
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Wrap(
              spacing: 8,
              children: [
                _buildActionButton(
                  icon: Icons.check_box,
                  label: 'Take Attendance',
                  onPressed: _takeAttendance,
                  color: Colors.blue.shade700,
                ),
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Edit Attendance',
                  onPressed: () {},
                  color: Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              children: [
                _buildInfoTag(
                  icon: Icons.check_circle,
                  label: 'Attendance Taken',
                  color: Colors.green,
                ),
                _buildInfoTag(
                  icon: Icons.lock,
                  label: 'Locked',
                  color: Colors.red,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateTime>(
          isExpanded: true,
          value: selectedDate,
          items: [
            DropdownMenuItem(
              value: selectedDate,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(DateFormat('dd-MMM-yyyy').format(selectedDate)),
              ),
            ),
          ],
          onChanged: (date) {
            if (date != null) {
              _selectDate(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              onChanged(val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon, 
    required String label, 
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildInfoTag({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _takeAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NCAttendanceMarkingScreen(
          model: widget.model,
          attendanceModel: NCAttendanceModel(widget.model),
        ),
      ),
    );
  }
  
  void _onNext() {
    // Navigate to the next screen or perform action
    _takeAttendance();
  }
} 
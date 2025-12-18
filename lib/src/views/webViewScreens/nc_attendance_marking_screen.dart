import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/attendance/nc_attendance_model.dart';
import 'package:intl/intl.dart';

class NCAttendanceMarkingScreen extends StatefulWidget {
  final MainModel model;
  final NCAttendanceModel attendanceModel;

  const NCAttendanceMarkingScreen({
    Key? key,
    required this.model,
    required this.attendanceModel,
  }) : super(key: key);

  @override
  State<NCAttendanceMarkingScreen> createState() => _NCAttendanceMarkingScreenState();
}

class _NCAttendanceMarkingScreenState extends State<NCAttendanceMarkingScreen> {
  DateTime selectedDate = DateTime.now();
  String orderBy = 'Student Name';
  String attendanceName = '--- All ---';
  String attendanceFor = '--- All ---';
  String copyFromAttendance = '--- All ---';
  String remarks = '';
  String statusSelection = 'Select';
  
  // Radio button selection options
  bool isStudentNameSelected = true;
  bool isRegistrationNoSelected = false;
  bool isRollNoSelected = false;
  
  // Student attendance data
  final List<Map<String, dynamic>> students = [
    {
      'slNo': 1,
      'rollNo': 1,
      'regNo': '2015/129',
      'name': 'ANUPAMA BEHERA',
      'status': '',
    },
    {
      'slNo': 2,
      'rollNo': 2,
      'regNo': '2022/121',
      'name': 'AYUSH KUMAR CHOUDHARY',
      'status': '',
    },
    {
      'slNo': 3,
      'rollNo': 3,
      'regNo': '2024/108',
      'name': 'AYUSH NIRAJ SINGH',
      'status': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First section - Form fields
            _buildFormSection(),
            
            // Attendance table with cancel button
            _buildAttendanceTable(primaryColor),
            
            // Copy From Attendance section
            _buildCopyFromSection(),
            
            // Remarks section
            _buildRemarksSection(),
            
            // P=Present, A=Absent legend
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: const Text(
                'P=Present, A=Absent',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Status selection and apply button
            _buildStatusSection(primaryColor),
            
            // Students table
            _buildStudentsTable(primaryColor),
            
            // Action buttons
            _buildActionButtons(primaryColor),
            
            // Next button (floats at bottom right)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attendance Date field
          _buildFormField(
            'Attendance Date *', 
            _buildDropdown(
              DateFormat('dd-MMM-yyyy').format(selectedDate),
              [DateFormat('dd-MMM-yyyy').format(selectedDate)],
              (value) {}
            ),
            trailing: TextButton(
              onPressed: () {},
              child: const Text(
                'Hide',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          
          // Attendance Name field
          _buildFormField(
            'Attendance Name',
            _buildDropdown(
              attendanceName,
              ['--- All ---', 'Class Attendance'],
              (value) => setState(() => attendanceName = value)
            ),
          ),
          
          // Attendance For field
          _buildFormField(
            'Attendance For',
            _buildDropdown(
              attendanceFor,
              ['--- All ---', 'CBSE\\General\\2024-25\\IX - D'],
              (value) => setState(() => attendanceFor = value)
            ),
          ),
          
          // Order By field with radio buttons
          _buildFormField(
            'Order By',
            Wrap(
              spacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: true,
                      groupValue: isStudentNameSelected,
                      onChanged: (value) {
                        setState(() {
                          isStudentNameSelected = true;
                          isRegistrationNoSelected = false;
                          isRollNoSelected = false;
                        });
                      },
                    ),
                    const Text('Student Name'),
                  ],
                ),
                
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: true,
                      groupValue: isRegistrationNoSelected,
                      onChanged: (value) {
                        setState(() {
                          isStudentNameSelected = false;
                          isRegistrationNoSelected = true;
                          isRollNoSelected = false;
                        });
                      },
                    ),
                    const Text('Registration No.'),
                  ],
                ),
                
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: true,
                      groupValue: isRollNoSelected,
                      onChanged: (value) {
                        setState(() {
                          isStudentNameSelected = false;
                          isRegistrationNoSelected = false;
                          isRollNoSelected = true;
                        });
                      },
                    ),
                    const Text('Roll No.'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttendanceTable(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.0),
              1: FlexColumnWidth(1.6),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.2),
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
            columnWidths: const {
              0: FlexColumnWidth(1.0),
              1: FlexColumnWidth(1.6),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.2),
            },
            children: [
              TableRow(
                children: [
                  _buildTableCell('Class Attendance'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'CBSE\\General\\2024-25\\IX - D',
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  _buildTableCell('07:30 AM - 07:45 AM'),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: const Text('Cancel', style: TextStyle(fontSize: 12))),
                        // const SizedBox(width: 2),
                        Icon(Icons.cancel, color: Colors.red, size: 16),
                      ],
                    ),
                  ),
                ]
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCopyFromSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Hide',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Copy From Attendance',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildDropdown(
                  copyFromAttendance,
                  ['--- All ---', 'Morning Attendance'],
                  (value) => setState(() => copyFromAttendance = value)
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Copy Morning Attendance'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRemarksSection() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Remarks',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            maxLines: 2,
            onChanged: (value) => setState(() => remarks = value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Status for All',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDropdown(
                  statusSelection,
                  ['Select', 'P', 'A'],
                  (value) => setState(() => statusSelection = value)
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _applyStatusToAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStudentsTable(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 32, // Constrain to screen width
          child: Column(
            children: [
              // Header
              Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: const {
                  0: FlexColumnWidth(0.7),
                  1: FlexColumnWidth(0.7),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    children: [
                      _buildTableHeader('Sl. #'),
                      _buildTableHeader('Roll No'),
                      _buildTableHeader('Registration No.'),
                      _buildTableHeader('Name'),
                      _buildTableHeader('Status'),
                    ]
                  ),
                ],
              ),
              
              // Student rows
              for (var student in students)
                Table(
                  border: TableBorder(
                    bottom: BorderSide(color: Colors.grey.shade300),
                    horizontalInside: BorderSide(color: Colors.grey.shade300),
                    verticalInside: BorderSide(color: Colors.grey.shade300),
                    left: BorderSide(color: Colors.grey.shade300),
                    right: BorderSide(color: Colors.grey.shade300),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(0.7),
                    1: FlexColumnWidth(0.7),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      children: [
                        _buildTableCell('${student['slNo']}'),
                        _buildTableCell('${student['rollNo']}'),
                        _buildTableCell('${student['regNo']}'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${student['name']}',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 'P',
                                groupValue: student['status'],
                                onChanged: (value) {
                                  setState(() {
                                    student['status'] = value;
                                  });
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Text('P', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Radio(
                                value: 'A',
                                groupValue: student['status'],
                                onChanged: (value) {
                                  setState(() {
                                    student['status'] = value;
                                  });
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Text('A', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _saveAttendance,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Save'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Print'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Take Attendance'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormField(String label, Widget child, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: child,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdown(String value, List<String> items, Function(String) onChanged) {
    return Container(
      height: 40,
      width: double.infinity,
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
    return Container(
      color: Colors.blue,
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
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  void _applyStatusToAll() {
    if (statusSelection == 'Select') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a status first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      for (var student in students) {
        student['status'] = statusSelection;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status "$statusSelection" applied to all students'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _saveAttendance() {
    // Calculate attendance counts
    int presentCount = students.where((student) => student['status'] == 'P').length;
    int absentCount = students.where((student) => student['status'] == 'A').length;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
} 
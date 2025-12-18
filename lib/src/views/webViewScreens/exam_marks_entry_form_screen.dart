import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';

class ExamMarksEntryFormScreen extends StatefulWidget {
  final MainModel model;

  const ExamMarksEntryFormScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<ExamMarksEntryFormScreen> createState() => _ExamMarksEntryFormScreenState();
}

class _ExamMarksEntryFormScreenState extends State<ExamMarksEntryFormScreen> {
  static const themeColor = Color(0xFF2196F3);
  
  // Sample data - in real app, this would come from API
  final List<StudentMark> students = [
    StudentMark('003268', 'JS/03268', 'AAVYA CHOPRA', '11'),
    StudentMark('003269', 'JS/03269', 'ARYA AGARWAL', '11.5'),
    StudentMark('003270', 'JS/03270', 'VANYA SINGHAL', '20'),
    StudentMark('003271', 'JS/03271', 'LEISHA SACHDEVA', '12'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Exam Marks Entry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Table Header
                  Container(
                    color: themeColor,
                    child: Row(
                      children: [
                        _buildHeaderCell('Roll No.', flex: 1),
                        _buildHeaderCell('Regd. No.', flex: 1),
                        _buildHeaderCell('Name', flex: 1),
                        _buildHeaderCell('TEST 1\nFM : 20', flex: 2),
                      ],
                    ),
                  ),
                  // Table Rows
                  ...students.map((student) => _buildTableRow(student)).toList(),
                ],
              ),
            ),
          ),
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle save
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle publish
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Publish'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableRow(StudentMark student) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          _buildCell(student.rollNo, flex: 1),
          _buildCell(student.regdNo, flex: 1),
          _buildCell(student.name, flex: 1),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'Select',
                          isExpanded: true,
                          items: ['Select', 'Present', 'Absent']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: TextEditingController(text: student.marks),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}

class StudentMark {
  final String rollNo;
  final String regdNo;
  final String name;
  final String marks;

  StudentMark(this.rollNo, this.regdNo, this.name, this.marks);
} 
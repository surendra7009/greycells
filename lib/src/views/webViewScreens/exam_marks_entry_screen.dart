import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/views/webViewScreens/exam_marks_entry_form_screen.dart';

class ExamMarksEntryScreen extends StatefulWidget {
  final MainModel model;

  const ExamMarksEntryScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<ExamMarksEntryScreen> createState() => _ExamMarksEntryScreenState();
}

class _ExamMarksEntryScreenState extends State<ExamMarksEntryScreen> {
  static const themeColor = Color(0xFF2196F3);
  String selectedBatch = '2025-2026';
  String selectedSubject = 'Select';
  String selectedExam = 'Select';
  bool showCommonClassStudents = true;
  bool showDiscipline = false;
  bool showSection = false;
  String orderBy = 'Roll No.';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Exam Wise Marks Entry',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Form Fields
              _buildDropdownField(
                'Batch',
                selectedBatch,
                ['2025-2026'],
                (val) => setState(() => selectedBatch = val ?? ''),
              ),
              
              _buildDropdownField(
                'Subject',
                selectedSubject,
                ['Select', 'Mathematics', 'Science', 'English'],
                (val) => setState(() => selectedSubject = val ?? ''),
                isRequired: true,
              ),
              
              _buildDropdownField(
                'Exam',
                selectedExam,
                ['Select', 'Mid Term', 'Final Term'],
                (val) => setState(() => selectedExam = val ?? ''),
                isRequired: true,
              ),
              
              // Checkboxes
              _buildCheckbox(
                'Show Discipline',
                showDiscipline,
                (val) => setState(() => showDiscipline = val ?? false),
              ),
              
              _buildCheckbox(
                'Show Common Class Students',
                showCommonClassStudents,
                (val) => setState(() => showCommonClassStudents = val ?? false),
              ),
              
              _buildCheckbox(
                'Show Section',
                showSection,
                (val) => setState(() => showSection = val ?? false),
              ),
              
              // Order By Radio Buttons
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Order By'),
              ),
              _buildRadioGroup(),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamMarksEntryFormScreen(model: widget.model),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Next'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Required Fields Note
              const Text(
                'Fields marked with * mark are mandatory.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(item),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: themeColor,
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildRadioGroup() {
    return Column(
      children: [
        _buildRadioOption('Roll No.'),
        _buildRadioOption('Student Name'),
        _buildRadioOption('Registration No.'),
      ],
    );
  }

  Widget _buildRadioOption(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Radio<String>(
            value: label,
            groupValue: orderBy,
            onChanged: (value) => setState(() => orderBy = value ?? ''),
            activeColor: themeColor,
          ),
          Text(label),
        ],
      ),
    );
  }
} 
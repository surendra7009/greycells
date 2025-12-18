import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:intl/intl.dart';

class EditLeaveScreen extends StatefulWidget {
  final MainModel model;

  const EditLeaveScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<EditLeaveScreen> createState() => _EditLeaveScreenState();
}

class _EditLeaveScreenState extends State<EditLeaveScreen> {
  static const themeColor = Color(0xFF2196F3);
  final TextEditingController requestedByController = TextEditingController(text: 'RASHMI THAKUR :: MG017F0647');
  final TextEditingController leaveFromDateController = TextEditingController(text: '28-FEB-2025');
  final TextEditingController leaveToDateController = TextEditingController(text: '28-FEB-2025');
  final TextEditingController proofReqdController = TextEditingController(text: 'No');
  final TextEditingController proofSubmittedController = TextEditingController(text: 'No');
  final TextEditingController prefixHolidaysController = TextEditingController(text: 'Prefixing Holidays are not applicable for this Leave.');
  final TextEditingController suffixHolidaysController = TextEditingController(text: 'Suffixing Holidays are not applicable for this Leave.');
  final TextEditingController prefixDaysController = TextEditingController(text: '0');
  final TextEditingController suffixDaysController = TextEditingController(text: '0');
  final TextEditingController leaveUnitController = TextEditingController(text: '2');
  final TextEditingController totalDaysController = TextEditingController(text: '1');
  final TextEditingController leavePurposeController = TextEditingController(text: 'Fever');
  final TextEditingController addressController = TextEditingController();
  final TextEditingController arrangementsController = TextEditingController(text: 'NA');
  final TextEditingController contactNoController = TextEditingController();
  final TextEditingController stationLeavingController = TextEditingController(text: 'No');
  String selectedLeave = 'Casual Leave';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Edit Leave'),
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
              _buildTextField('Requested By', requestedByController, enabled: false),
              _buildDropdownField('Applied Leave', selectedLeave, ['Casual Leave', 'Leave Without Pay', 'Maternity Leave']),
              _buildDateField('Leave From Date', leaveFromDateController),
              _buildDateField('Leave From Date', leaveFromDateController),
              _buildDateField('Leave To Date', leaveToDateController),
              _buildTextField('Proof Reqd. ?', proofReqdController),
              _buildTextField('Proof Submitted ?', proofSubmittedController),
              _buildTextField('Prefix Holidays', prefixHolidaysController),
              _buildTextField('Suffix Holidays', suffixHolidaysController),
              _buildTextField('Prefix Holidays (Days)', prefixDaysController),
              _buildTextField('Suffix Holidays (Days)', suffixDaysController),
              _buildTextField('Leave Unit Applied', leaveUnitController),
              _buildTextField('Total Days Counted', totalDaysController),
              _buildTextField('Leave Purpose', leavePurposeController),
              _buildTextField('Address During Leave', addressController),
              _buildTextField('Leave Arrangements', arrangementsController),
              _buildTextField('Contact No. During Leave', contactNoController),
              _buildTextField('Station Leaving ?', stationLeavingController),

              const SizedBox(height: 24),

              // Approval Detail Section
              const Text(
                'APPROVAL DETAIL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Approval Status
                    const Text('Approval Status *'),
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: true,
                          onChanged: (value) {},
                          activeColor: themeColor,
                        ),
                        const Text('Approved'),
                        const SizedBox(width: 16),
                        Radio(
                          value: false,
                          groupValue: true,
                          onChanged: (value) {},
                          activeColor: themeColor,
                        ),
                        const Text('Not Approved'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildDateField('Date of Action *', TextEditingController(text: '21-MAR-2025')),
                    _buildDateField('Approved From Date *', TextEditingController(text: '28-FEB-2025')),
                    _buildDateField('Approved To Date *', TextEditingController(text: '28-FEB-2025')),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('View and Print Application'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
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
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => selectedLeave = val);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  controller.text = DateFormat('dd-MMM-yyyy').format(picked).toUpperCase();
                });
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: const Icon(Icons.calendar_today, size: 20),
            ),
          ),
        ],
      ),
    );
  }
} 
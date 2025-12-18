import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:intl/intl.dart';
import 'package:greycell_app/src/views/webViewScreens/edit_leave_screen.dart';

class LeaveAccountDetailScreen extends StatefulWidget {
  final MainModel model;

  const LeaveAccountDetailScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<LeaveAccountDetailScreen> createState() => _LeaveAccountDetailScreenState();
}

class _LeaveAccountDetailScreenState extends State<LeaveAccountDetailScreen> {
  static const themeColor = Color(0xFF2196F3); // Material Blue
  String approvalStatus = '';
  final TextEditingController dateController = TextEditingController(text: '21-MAR-2025');
  final TextEditingController fromDateController = TextEditingController(text: '28-FEB-2025');
  final TextEditingController toDateController = TextEditingController(text: '28-FEB-2025');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Leave Account Current Status (As On Today)'),
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
              // Leave Status Table
              _buildLeaveStatusTable(),
              
              const SizedBox(height: 24),
              
              // Approval History Section
              const Text(
                'APPROVAL HISTORY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildApprovalHistoryTable(),
              
              const SizedBox(height: 24),
              
              // Approval Detail Section
              const Text(
                'APPROVAL DETAIL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildApprovalDetailForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveStatusTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1.2),  // Label column
        1: FlexColumnWidth(1.0),  // Casual Leave
        2: FlexColumnWidth(1.0),  // Leave Without Pay
        3: FlexColumnWidth(1.0),  // Maternity Leave
      },
      children: [
        _buildTableRow([
          _buildCell('Leave\nName', isBlue: true),
          _buildCell('Casual Leave'),
          _buildCell('Leave Without Pay'),
          _buildCell('Maternity Leave'),
        ]),
        _buildTableRow([
          _buildCell('Leave\nCode', isBlue: true),
          _buildCell('CL'),
          _buildCell('LWP'),
          _buildCell('MARTL'),
        ]),
        _buildTableRow([
          _buildCell('Max Annual\nAllowed', isBlue: true),
          _buildCell('15'),
          _buildCell('365'),
          _buildCell('120'),
        ]),
        _buildTableRow([
          _buildCell('Opening\nBalance', isBlue: true),
          _buildCell('0'),
          _buildCell('0'),
          _buildCell('0'),
        ]),
        _buildTableRow([
          _buildCell('Leaves To\nBe Credited', isBlue: true),
          _buildCell('15'),
          _buildCell('365'),
          _buildCell('120'),
        ]),
        _buildTableRow([
          _buildCell('Leave\nAdjustment', isBlue: true),
          _buildCell('null'),
          _buildCell('null'),
          _buildCell('null'),
        ]),
        _buildTableRow([
          _buildCell('Leave Availed\n(Curr. Year)', isBlue: true),
          _buildCell('10'),
          _buildCell('0'),
          _buildCell('0'),
        ]),
        _buildTableRow([
          _buildCell('Balance\nLeave', isBlue: true),
          _buildCell('5'),
          _buildCell('365'),
          _buildCell('120'),
        ]),
        _buildTableRow([
          _buildCell('More times\nto avail', isBlue: true),
          _buildCell('Unlimited'),
          _buildCell('Unlimited'),
          _buildCell('Unlimited'),
        ]),
      ],
    );
  }

  Widget _buildApprovalHistoryTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: themeColor),
          children: [
            _buildHeaderCell('Approver Name'),
            _buildHeaderCell('Level'),
            _buildHeaderCell('Status'),
            _buildHeaderCell('Remarks'),
          ],
        ),
        TableRow(
          children: [
            _buildCell('NEETI BHALLA SAINI'),
            _buildCell('1'),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditLeaveScreen(model: widget.model),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit, size: 16, color: themeColor),
                    SizedBox(width: 4),
                    Text('Edit', style: TextStyle(color: themeColor)),
                  ],
                ),
              ),
            ),
            _buildCell('Not provided.'),
          ],
        ),
      ],
    );
  }

  Widget _buildApprovalDetailForm() {
    return Container(
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
                value: 'Approved',
                groupValue: approvalStatus,
                onChanged: (value) => setState(() => approvalStatus = value.toString()),
                activeColor: themeColor,
              ),
              const Text('Approved'),
              const SizedBox(width: 16),
              Radio(
                value: 'Not Approved',
                groupValue: approvalStatus,
                onChanged: (value) => setState(() => approvalStatus = value.toString()),
                activeColor: themeColor,
              ),
              const Text('Not Approved'),
            ],
          ),
          const SizedBox(height: 16),

          // Date Fields
          _buildDateField('Date of Action *', dateController),
          _buildDateField('Approved From Date *', fromDateController),
          _buildDateField('Approved To Date *', toDateController),

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

  TableRow _buildTableRow(List<Widget> cells) {
    return TableRow(children: cells);
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(String text, {bool isBlue = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: isBlue ? themeColor : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isBlue ? Colors.white : Colors.black87,
          fontSize: 13,
          fontWeight: isBlue ? FontWeight.w500 : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
} 
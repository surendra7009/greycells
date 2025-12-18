import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:intl/intl.dart';
import 'package:greycell_app/src/views/webViewScreens/leave_account_status_screen.dart';

class ApplyLeaveScreen extends StatefulWidget {
  final MainModel model;

  const ApplyLeaveScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String leaveType = '--- Select ---';
  String remarks = '';
  final TextEditingController _remarksController = TextEditingController();
  
  // Define the theme color
  static const themeColor = Color(0xFF2196F3); // Material Blue

  // Sample leave history data
  final List<Map<String, dynamic>> leaveHistory = [
    {
      'slNo': 1,
      'leaveNo': '2025-1, CL(15)',
      'fromDate': '28 FEB 2025',
      'toDate': '28 FEB 2025',
      'appliedDate': '28 FEB 2025',
      'status': 'Waiting',
    },
    {
      'slNo': 2,
      'leaveNo': '2024-2252, PL(365)',
      'fromDate': '03 DEC 2024',
      'toDate': '04 DEC 2024',
      'appliedDate': '02 DEC 2024',
      'status': 'Approved',
    },
  ];

  // Sample approvers data
  final List<Map<String, dynamic>> approvers = [
    {
      'name': 'NEETI BHALLA SAINI',
      'level': '1',
      'status': 'Approved',
      'remarks': 'Manual approval given at level-1',
    }
  ];

  void _showWithdrawForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'WITHDRAW APPLIED LEAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Leave *'),
                    Row(
                      children: [
                        Radio(
                          value: 'CL',
                          groupValue: leaveType,
                          onChanged: (value) => setState(() => leaveType = value.toString()),
                          activeColor: themeColor,
                        ),
                        const Text('CL'),
                        Radio(
                          value: 'LWP',
                          groupValue: leaveType,
                          onChanged: (value) => setState(() => leaveType = value.toString()),
                          activeColor: themeColor,
                        ),
                        const Text('LWP'),
                        Radio(
                          value: 'ML',
                          groupValue: leaveType,
                          onChanged: (value) => setState(() => leaveType = value.toString()),
                          activeColor: themeColor,
                        ),
                        const Text('ML'),
                        Radio(
                          value: 'PL',
                          groupValue: leaveType,
                          onChanged: (value) => setState(() => leaveType = value.toString()),
                          activeColor: themeColor,
                        ),
                        const Text('PL'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDateField('From Date *', fromDate),
                    _buildDateField('To Date *', toDate),
                    _buildTextField('Proof Reqd. ?'),
                    _buildCheckboxField('(Hard copy) Proof submitted ?'),
                    _buildTextField('Include Holidays ?'),
                    _buildTextField('Prefixing Holidays ?'),
                    _buildTextField('Suffixing Holidays ?'),
                    _buildTextField('Aadhaar Card No.'),
                    _buildTextField('Suffix Holidays'),
                    _buildTextField('Leave Unit'),
                    _buildTextField('Units Counted'),
                    _buildTextField('Total Prefix Days'),
                    _buildTextField('Total Suffix Days'),
                    _buildTextField('Contact No. During Leave'),
                    _buildTextField('Min. Units to Avail'),
                    _buildTextField('Total Units Applied (including Prefix/Suffix, if any)'),
                    _buildTextField('Leave Purpose *', required: true),
                    _buildTextField('Address During Leave'),
                    _buildTextField('Leave Arrangements *\n(Classes / Other Resp.)\n(Put NA if not applicable)', maxLines: 3),
                    _buildTextField('Reason to withdraw leave', maxLines: 3),
                    _buildCheckboxField('Leaving station during this Leave period ?'),
                    _buildTextField('Leave Year(YYYY)*'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Withdraw'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Print Report'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime initialDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd-MMM-yyyy').format(initialDate)),
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            maxLines: maxLines,
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

  Widget _buildCheckboxField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
            activeColor: themeColor,
          ),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Apply For Leave'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _showWithdrawForm,
                    icon: const Icon(Icons.add),
                    label: const Text('New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeaveAccountStatusScreen(model: widget.model),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text('Leave Account Current Status'),
                    ),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: 'Leave No.',
                          items: ['Leave No.'].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Leave history table
            _buildLeaveHistoryTable(themeColor),

            const SizedBox(height: 24),

            // Approvers section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Approvers For The Leave Application',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Approvers table
            _buildApproversTable(themeColor),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveHistoryTable(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FixedColumnWidth(30),  // #
          1: FlexColumnWidth(2.0),  // Leave No./Leave Code
          2: FlexColumnWidth(1.2),  // From Date
          3: FlexColumnWidth(1.2),  // To Date
          4: FlexColumnWidth(1.2),  // Applied Date
          5: FlexColumnWidth(1.0),  // Current Status
          6: FixedColumnWidth(80),  // Edit
        },
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            children: [
              _buildTableHeader('#'),
              _buildTableHeader('Leave\nCode'),
              _buildTableHeader('From'),
              _buildTableHeader('To'),
              _buildTableHeader('Applied'),
              _buildTableHeader('Status'),
              _buildTableHeader('Action'),
            ],
          ),
          // Data rows
          for (var leave in leaveHistory)
            TableRow(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              children: [
                _buildTableCell('${leave['slNo']}'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${leave['leaveNo']}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                _buildTableCell('${leave['fromDate']}'),
                _buildTableCell('${leave['toDate']}'),
                _buildTableCell('${leave['appliedDate']}'),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${leave['status']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: leave['status'] == 'Approved' ? Colors.green : 
                             leave['status'] == 'Waiting' ? Colors.orange : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: primaryColor),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 20,
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.print, color: primaryColor),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 20,
                        tooltip: 'Print',
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
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

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Widget _buildApproversTable(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(2),  // Approver Name
          1: FlexColumnWidth(0.5),  // Level
          2: FlexColumnWidth(1),  // Status
          3: FlexColumnWidth(2),  // Remarks
        },
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            children: [
              _buildTableHeader('Approver Name'),
              _buildTableHeader('Level'),
              _buildTableHeader('Status'),
              _buildTableHeader('Remarks'),
            ],
          ),
          // Data rows
          for (var approver in approvers)
            TableRow(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              children: [
                _buildTableCell('${approver['name']}'),
                _buildTableCell('${approver['level']}'),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${approver['status']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: approver['status'] == 'Approved' ? Colors.green : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildTableCell('${approver['remarks']}'),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }
} 
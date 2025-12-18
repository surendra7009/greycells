import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/views/webViewScreens/leave_account_detail_screen.dart';

import 'edit_leave_screen.dart';

class ApproveLeaveScreen extends StatefulWidget {
  final MainModel model;

  const ApproveLeaveScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<ApproveLeaveScreen> createState() => _ApproveLeaveScreenState();
}

class _ApproveLeaveScreenState extends State<ApproveLeaveScreen> {
  static const themeColor = Color(0xFF2196F3); // Material Blue
  String selectedStatus = '';
  String searchQuery = '';

  // Sample data for the table
  final List<Map<String, dynamic>> leaveRequests = [
    {
      'slNo': 1,
      'leaveCode': 'MGD17F06477/CL',
      'appliedBy': 'RASHMI THAKUR',
      'fromDate': '28 FEB 2025',
      'toDate': '28 FEB 2025',
      'totalDays': '30',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Approve Leave'),
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
              // Leave Account Current Status Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveAccountDetailScreen(model: widget.model),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Leave Account Current Status'),
                ),
              ),

              const SizedBox(height: 24),

              // Self Status Radio Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Self Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      children: [
                        _buildRadioButton('Approved'),
                        _buildRadioButton('Not Approved'),
                        _buildRadioButton('Recommended'),
                        _buildRadioButton('Verified'),
                        _buildRadioButton('Waiting'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Search Section
              Row(
                children: [
                  Container(
                    width: 120,
                    height: 40,
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Leave Requests Table
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnWidths: const {
                    0: FixedColumnWidth(30),  // Sl.#
                    1: FlexColumnWidth(1.2),  // Applier Code
                    2: FlexColumnWidth(1.0),  // Applied By
                    3: FlexColumnWidth(0.8),  // From Date
                    4: FlexColumnWidth(0.8),  // To Date
                    5: FixedColumnWidth(40),  // Total Days
                    6: FixedColumnWidth(70),  // Actions
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        color: themeColor,
                      ),
                      children: [
                        _buildTableHeader('#'),
                        _buildTableHeader('Code'),
                        _buildTableHeader('Applied\nBy'),
                        _buildTableHeader('From'),
                        _buildTableHeader('To'),
                        _buildTableHeader('Days'),
                        _buildTableHeader('Action'),
                      ],
                    ),
                    for (var request in leaveRequests)
                      TableRow(
                        children: [
                          _buildTableCell('${request['slNo']}'),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '${request['leaveCode']}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '${request['appliedBy']}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          _buildTableCell('${request['fromDate'].split(' ')[0]}\n${request['fromDate'].split(' ')[1]}'),
                          _buildTableCell('${request['toDate'].split(' ')[0]}\n${request['toDate'].split(' ')[1]}'),
                          _buildTableCell('${request['totalDays']}'),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildActionIcon(Icons.edit, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditLeaveScreen(model: widget.model),
                                    ),
                                  );
                                }),
                                _buildActionIcon(Icons.remove_red_eye, () {}),
                                _buildActionIcon(Icons.print, () {}),
                              ],
                            ),
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

  Widget _buildRadioButton(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          groupValue: selectedStatus,
          onChanged: (String? value) {
            setState(() {
              selectedStatus = value ?? '';
            });
          },
          activeColor: themeColor,
        ),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Icon(
          icon,
          color: themeColor,
          size: 16,
        ),
      ),
    );
  }
} 
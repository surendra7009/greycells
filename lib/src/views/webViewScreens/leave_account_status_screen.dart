import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';

class LeaveAccountStatusScreen extends StatelessWidget {
  final MainModel model;
  static const themeColor = Color(0xFF2196F3); // Material Blue

  const LeaveAccountStatusScreen({Key? key, required this.model}) : super(key: key);

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
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1.0),
              2: FlexColumnWidth(1.0),
              3: FlexColumnWidth(1.0),
            },
            children: [
              _buildTableRow(
                ['Leave\nName', 'Casual\nLeave', 'Leave Without\nPay', 'Maternity\nLeave'],
                isHeader: true,
                isBlue: true,
              ),
              _buildTableRow(['Leave\nCode', 'CL', 'LWP', 'MARTL'], isBlue: true),
              _buildTableRow(['Max Annual\nAllowed', '15', '365', '120'], isBlue: true),
              _buildTableRow(['Opening\nBalance', '0', '0', '0'], isBlue: true),
              _buildTableRow(['Leaves To\nBe Credited', '15', '365', '120'], isBlue: true),
              _buildTableRow(['Leave\nAdjustment', 'null', 'null', 'null'], isBlue: true),
              _buildTableRow(['Leave\nAvailed\n(Curr. Year)', '10', '0', '0'], isBlue: true),
              _buildTableRow(['Balance\nLeave', '5', '365', '120'], isBlue: true),
              _buildTableRow(['More times\nto avail', 'Unlimited', 'Unlimited', 'Unlimited'], isBlue: true),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false, bool isBlue = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isBlue ? themeColor : Colors.white,
      ),
      children: cells.map((cell) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Text(
          cell,
          style: TextStyle(
            color: isBlue ? Colors.white : Colors.black87,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }
} 
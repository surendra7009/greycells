import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class GCDataTableCard extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final String emptyPlaceholder;
  final Map<int, TableColumnWidth>? columnWidths;
  final List<Map<String, dynamic>>? rawData; // Raw data for export
  final String? title;

  const GCDataTableCard({
    Key? key,
    required this.headers,
    required this.rows,
    this.emptyPlaceholder = 'No data available',
    this.columnWidths,
    this.rawData,
    this.title,
  })  : assert(headers.length > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasRows = rows.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? 'Results',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (hasRows && rawData != null)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'export_csv') {
                        _exportToCSV(context);
                      } else if (value == 'copy') {
                        _copyToClipboard(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'export_csv',
                        child: Row(
                          children: [
                            Icon(Icons.file_download, size: 20),
                            SizedBox(width: 8),
                            Text('Export to CSV'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'copy',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 20),
                            SizedBox(width: 8),
                            Text('Copy to Clipboard'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasRows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    emptyPlaceholder,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate minimum table width based on column widths
                    double minTableWidth = 0;
                    int flexCount = 0;
                    if (columnWidths != null) {
                      for (var entry in columnWidths!.entries) {
                        if (entry.value is FixedColumnWidth) {
                          minTableWidth += (entry.value as FixedColumnWidth).value;
                        } else if (entry.value is FlexColumnWidth) {
                          flexCount++;
                        }
                      }
                    }
                    // Estimate flex widths - use 120px per flex column
                    final estimatedFlexWidth = flexCount * 120.0;
                    final screenWidth = MediaQuery.of(context).size.width;
                    final availableWidth = screenWidth - 64; // Account for padding
                    final totalTableWidth = minTableWidth + estimatedFlexWidth;
                    
                    return SizedBox(
                      width: totalTableWidth > availableWidth 
                          ? totalTableWidth 
                          : availableWidth,
                      child: columnWidths != null
                          ? Table(
                              border: TableBorder.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              columnWidths: columnWidths,
                              children: [
                                // Header row
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.08),
                                  ),
                                  children: headers.map((header) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        header,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                // Data rows
                                for (var row in rows)
                                  TableRow(
                                    children: row.map((cell) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 8,
                                        ),
                                        child: cell,
                                      );
                                    }).toList(),
                                  ),
                              ],
                            )
                          : DataTable(
                              headingRowColor: WidgetStateProperty.resolveWith(
                                (_) => Theme.of(context).primaryColor.withOpacity(0.08),
                              ),
                              columns: headers
                                  .map(
                                    (header) => DataColumn(
                                      label: Text(
                                        header,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              rows: rows
                                  .map(
                                    (cells) => DataRow(
                                      cells: [
                                        for (var cell in cells)
                                          DataCell(Padding(
                                            padding:
                                                const EdgeInsets.symmetric(vertical: 6.0),
                                            child: cell,
                                          )),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _exportToCSV(BuildContext context) {
    if (rawData == null || rawData!.isEmpty) return;

    try {
      // Build CSV content
      final StringBuffer csv = StringBuffer();
      
      // Add headers
      csv.writeln(headers.join(','));
      
      // Add data rows
      for (var data in rawData!) {
        final List<String> row = [];
        for (var header in headers) {
          String value = '';
          switch (header) {
            case '#':
              value = '${rawData!.indexOf(data) + 1}';
              break;
            case 'Reference No':
              value = _escapeCSV(data['referenceNo']?.toString() ?? '');
              break;
            case 'Subject Name':
              value = _escapeCSV(data['subject']?.toString() ?? '');
              break;
            case 'Status':
              value = _escapeCSV(data['status']?.toString() ?? '');
              break;
            case 'Initiated By':
              value = _escapeCSV(data['initiatedBy']?.toString() ?? '');
              break;
            case 'Assigned to':
              value = _escapeCSV(data['assignedTo']?.toString() ?? '');
              break;
            case 'Edit / View':
              value = '';
              break;
            default:
              value = _escapeCSV(data[header.toLowerCase()]?.toString() ?? '');
          }
          row.add(value);
        }
        csv.writeln(row.join(','));
      }
      
      // Share the CSV content
      Share.share(
        csv.toString(),
        subject: '${title ?? 'Data'} Export',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard(BuildContext context) {
    if (rawData == null || rawData!.isEmpty) return;

    try {
      final StringBuffer text = StringBuffer();
      
      // Add headers
      text.writeln(headers.join('\t'));
      
      // Add data rows
      for (var data in rawData!) {
        final List<String> row = [];
        for (var header in headers) {
          String value = '';
          switch (header) {
            case '#':
              value = '${rawData!.indexOf(data) + 1}';
              break;
            case 'Reference No':
              value = data['referenceNo']?.toString() ?? '';
              break;
            case 'Subject Name':
              value = data['subject']?.toString() ?? '';
              break;
            case 'Status':
              value = data['status']?.toString() ?? '';
              break;
            case 'Initiated By':
              value = data['initiatedBy']?.toString() ?? '';
              break;
            case 'Assigned to':
              value = data['assignedTo']?.toString() ?? '';
              break;
            case 'Edit / View':
              value = '';
              break;
            default:
              value = data[header.toLowerCase()]?.toString() ?? '';
          }
          row.add(value);
        }
        text.writeln(row.join('\t'));
      }
      
      Clipboard.setData(ClipboardData(text: text.toString()));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error copying data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _escapeCSV(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

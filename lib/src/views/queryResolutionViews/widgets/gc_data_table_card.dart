import 'package:flutter/material.dart';

class GCDataTableCard extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final String emptyPlaceholder;
  final Map<int, TableColumnWidth>? columnWidths;

  const GCDataTableCard({
    Key? key,
    required this.headers,
    required this.rows,
    this.emptyPlaceholder = 'No data available',
    this.columnWidths,
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
            Text(
              'Results',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
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
                child: columnWidths != null
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate minimum table width - sum of fixed widths + estimated flex widths
                          double minTableWidth = 0;
                          int flexCount = 0;
                          for (var entry in columnWidths!.entries) {
                            if (entry.value is FixedColumnWidth) {
                              minTableWidth += (entry.value as FixedColumnWidth).value;
                            } else if (entry.value is FlexColumnWidth) {
                              flexCount++;
                            }
                          }
                          // Estimate flex widths - use 150px per flex column as minimum
                          final estimatedFlexWidth = flexCount * 150.0;
                          final screenWidth = MediaQuery.of(context).size.width;
                          final availableWidth = screenWidth - 64; // Account for padding
                          final totalTableWidth = minTableWidth + estimatedFlexWidth;
                          
                          return SizedBox(
                            width: totalTableWidth > availableWidth 
                                ? totalTableWidth 
                                : availableWidth,
                            child: Table(
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
                                        horizontal: 12,
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
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: cell,
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          );
                        },
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
              ),
          ],
        ),
      ),
    );
  }
}

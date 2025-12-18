import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:intl/intl.dart';

class QueryAssignReportView extends StatefulWidget {
  final MainModel model;

  const QueryAssignReportView({Key? key, required this.model}) : super(key: key);

  @override
  State<QueryAssignReportView> createState() => _QueryAssignReportViewState();
}

class _QueryAssignReportViewState extends State<QueryAssignReportView> {
  final DateFormat _dateFormat = DateFormat('dd-MMM-yyyy');

  late DateTime _fromDate;
  late DateTime _toDate;

  String _natureValue = '';
  String _categoryValue = '';
  String _priorityValue = '';
  String _statusValue = '';

  List<Map<String, String>> _queryNatureList = [];
  List<Map<String, String>> _queryStatusList = [];
  List<Map<String, String>> _priorityList = [];
  List<Map<String, String>> _categoryList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _toDate = DateTime.now();
    _fromDate = _toDate.subtract(const Duration(days: 15));
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _fetchQueryNatureList(),
        _fetchQueryStatusList(),
        _fetchQueryPriorityList(),
        _fetchCategoryList(),
      ]);
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchQueryNatureList() async {
    try {
      final natureList = await widget.model.getQueryNatureVector();
      if (!mounted) return;
      setState(() {
        _queryNatureList = natureList;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load query nature list: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchQueryStatusList() async {
    try {
      final statusList = await widget.model.getQueryStatusVector();
      if (!mounted) return;
      setState(() {
        _queryStatusList = statusList;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load query status list: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchQueryPriorityList() async {
    try {
      final priorityList = await widget.model.getQueryPriorityHelpdeskVector();
      if (!mounted) return;
      setState(() {
        _priorityList = priorityList;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load query priority list: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchCategoryList() async {
    try {
      final categoryList = await widget.model.getCategoryHelpdeskVector();
      if (!mounted) return;
      setState(() {
        _categoryList = categoryList;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load category list: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initialDate = isFrom ? _fromDate : _toDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: isFrom ? 'Select From Date' : 'Select To Initiated Date',
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_fromDate.isAfter(_toDate)) {
            _toDate = _fromDate;
          }
        } else {
          _toDate = picked.isBefore(_fromDate) ? _fromDate : picked;
        }
      });
    }
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          controller: TextEditingController(
              text: _dateFormat.format(value).toUpperCase()),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: onTap,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value.isEmpty ? null : value,
          hint: const Text('--- All ---'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: [
            const DropdownMenuItem(value: '', child: Text('--- All ---')),
            ...items,
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _onPrintReport() {
    // For now this screen only prepares filters; actual report
    // is expected to be rendered via server-side HTML/PDF.
    // You can wire this up to a WebView using `RestAPIs.GREYCELL_REPORT_URL`
    // if required in future.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Print Report is generated from the server-side report.'),
      ),
    );
  }

  void _onNext() {
    // This screen currently only provides filters; in the
    // web application the "Next" button typically navigates
    // to a tabular report page. In the mobile app, that
    // functionality can be implemented as a separate screen
    // calling `getQueryResolutionList` from the model.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Use these filters with `getQueryResolutionList` in a list view screen.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Assign Report'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[100],
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateField(
                            label: 'From Date',
                            value: _fromDate,
                            onTap: () => _pickDate(isFrom: true),
                          ),
                          const SizedBox(height: 12),
                          _buildDateField(
                            label: 'To Initiated Date',
                            value: _toDate,
                            onTap: () => _pickDate(isFrom: false),
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Nature',
                            value: _natureValue,
                            items: _queryNatureList.map((nature) {
                              return DropdownMenuItem(
                                value: nature['id'],
                                child: Text(nature['name'] ?? ''),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _natureValue = value);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Category',
                            value: _categoryValue,
                            items: [
                              const DropdownMenuItem(value: '', child: Text('--- All ---')),
                              ..._categoryList.map((category) {
                                return DropdownMenuItem(
                                  value: category['id'],
                                  child: Text(category['name'] ?? ''),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _categoryValue = value);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Priority',
                            value: _priorityValue,
                            items: _priorityList.map((priority) {
                              return DropdownMenuItem(
                                value: priority['id'],
                                child: Text(priority['name'] ?? ''),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _priorityValue = value);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Status',
                            value: _statusValue,
                            items: _queryStatusList.map((status) {
                              return DropdownMenuItem(
                                value: status['id'],
                                child: Text(status['name'] ?? ''),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _statusValue = value);
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: _onPrintReport,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Print Report'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/response/success.dart';
import 'package:greycell_app/src/models/response/failure.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DaysNotResolvedReportView extends StatefulWidget {
  final MainModel model;

  const DaysNotResolvedReportView({Key? key, required this.model}) : super(key: key);

  @override
  State<DaysNotResolvedReportView> createState() => _DaysNotResolvedReportViewState();
}

class _DaysNotResolvedReportViewState extends State<DaysNotResolvedReportView> {
  final TextEditingController _daysController = TextEditingController();

  String _natureValue = '';
  String _categoryValue = '';
  String _priorityValue = '';

  List<Map<String, String>> _queryNatureList = [];
  List<Map<String, String>> _priorityList = [];
  List<Map<String, String>> _categoryList = [];
  bool _isLoading = false;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _fetchQueryNatureList(),
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.number,
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
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
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

  Future<void> _onPrintReport({required bool isPdf}) async {
    if (_daysController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter "More Than (Days)" value.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final response = await widget.model.generateDaysNotResolvedReport(
        categoryId: _categoryValue.isEmpty ? null : _categoryValue,
        natureId: _natureValue.isEmpty ? null : _natureValue,
        priorityId: _priorityValue.isEmpty ? null : _priorityValue,
        days: _daysController.text.trim(),
      );

      if (!mounted) return;

      if (response is Success) {
        final reportFilePath = response.success['getReportFilePath']?.toString();
        if (reportFilePath != null && reportFilePath.isNotEmpty) {
          try {
            await launchUrlString(
              reportFilePath,
              mode: LaunchMode.externalApplication,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isPdf
                    ? 'PDF report opened successfully.'
                    : 'Excel report opened successfully.'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to open report: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isPdf
                  ? 'PDF report generated successfully.'
                  : 'Excel report generated successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (response is Failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.responseMessage ?? 'Failed to generate report.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Days Not Resolved Report'),
        backgroundColor: primaryColor,
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
                          _buildTextField(
                            label: 'More Than (Days)',
                            controller: _daysController,
                            isRequired: true,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _isGenerating
                                    ? null
                                    : () => _onPrintReport(isPdf: true),
                                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                label: const Text('Print Report'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _isGenerating
                                    ? null
                                    : () => _onPrintReport(isPdf: false),
                                icon: const Icon(Icons.table_chart, color: Colors.green),
                                label: const Text('Print Report'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
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
}


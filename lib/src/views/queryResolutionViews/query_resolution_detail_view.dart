import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/response/response.dart';
import 'package:greycell_app/src/models/response/success.dart';
import 'package:greycell_app/src/models/response/failure.dart';
import 'package:greycell_app/src/views/queryResolutionViews/widgets/gc_data_table_card.dart';
import 'package:greycell_app/src/config/query_constants.dart';

enum QueryResolutionMode { initiate, edit }

class QueryResolutionDetailView extends StatefulWidget {
  final MainModel model;
  final QueryResolutionMode mode;
  final Map<String, String>? seedData;
  final bool isFromInitiateQueryDrawer;

  const QueryResolutionDetailView({
    Key? key,
    required this.model,
    this.mode = QueryResolutionMode.initiate,
    this.seedData,
    this.isFromInitiateQueryDrawer = false,
  }) : super(key: key);

  @override
  State<QueryResolutionDetailView> createState() =>
      _QueryResolutionDetailViewState();
}

class _QueryResolutionDetailViewState extends State<QueryResolutionDetailView> {
  late final TextEditingController _referenceController;
  late final TextEditingController _subjectController;
  late final TextEditingController _statusDisplayController;
  late final TextEditingController _priorityTextController;
  late final TextEditingController _assignToController;
  late final TextEditingController _queryController;
  late final TextEditingController _remarkController;
  late final TextEditingController _categoryController;
  late final TextEditingController _natureController;
  late final TextEditingController _assignAllController;

  String _changeStatusToValue = '';

  List<Map<String, String>> _queryNatureList = [];
  List<Map<String, String>> _categoryList = [];
  List<Map<String, dynamic>> _remarkHistory = [];
  String? _queryId;
  String? _currentStatusId;
  bool _isLoadingDetails = false;
  bool _isSaving = false;
  bool _isSavingRemark = false;

  bool get _isInitiateMode => widget.mode == QueryResolutionMode.initiate;

  bool get _isQueryResolutionEditMode => widget.mode == QueryResolutionMode.edit;

  bool get _isFromInitiateQueryDrawer => widget.isFromInitiateQueryDrawer;

  @override
  void initState() {
    super.initState();
    final defaults = widget.seedData ?? {};

    _referenceController =
        TextEditingController(text: defaults['reference'] ?? '');
    _subjectController = TextEditingController(text: defaults['subject'] ?? '');
    _statusDisplayController =
        TextEditingController(text: _isInitiateMode ? 'Initiated' : (defaults['status'] ?? ''));
    _priorityTextController =
        TextEditingController(text: defaults['priorityText'] ?? defaults['priorityName'] ?? '');
    _assignToController =
        TextEditingController(text: defaults['assignTo'] ?? '');
    _queryController = TextEditingController(text: defaults['query'] ?? '');
    _remarkController = TextEditingController(text: defaults['remark'] ?? '');
    _categoryController = TextEditingController(text: defaults['categoryName'] ?? defaults['category'] ?? '');
    _natureController = TextEditingController(text: defaults['natureName'] ?? defaults['nature'] ?? '');
    _assignAllController = TextEditingController(text: defaults['assignAll'] ?? '');

    _currentStatusId = defaults['statusId'] ?? '';
    _queryId = defaults['id'];

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!_isInitiateMode && _queryId != null && _queryId!.isNotEmpty) {
      await _fetchQueryDetails();
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
      // Silently fail - we'll use the name from API response
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
      // Silently fail - we'll use the name from API response
    }
  }

  Future<void> _fetchQueryDetails() async {
    if (_queryId == null || _queryId!.isEmpty) return;

    setState(() {
      _isLoadingDetails = true;
    });

    try {
      Map<String, dynamic> details;
      
      // Use getQueryResolutionDetails for Query Resolution
      try {
        details = await widget.model.getQueryResolutionDetails(queryResolutionId: _queryId!);
      } catch (e) {
        // If details API fails, use seedData if available
        final seedData = widget.seedData ?? {};
        if (seedData.isNotEmpty) {
          details = {
            'referenceNo': seedData['reference'] ?? '',
            'subject': seedData['subject'] ?? '',
            'assignTo': seedData['assignTo'] ?? '',
            'query': seedData['query'] ?? '',
            'currentStatus': seedData['status'] ?? '',
            'currentStatusId': seedData['statusId'] ?? '',
            'categoryId': seedData['categoryId'] ?? '',
            'natureId': seedData['natureId'] ?? '',
            'priorityText': seedData['priorityName'] ?? '',
            'remarks': [],
          };
        } else {
          rethrow;
        }
      }
      
      if (!mounted) return;

      // Fetch lists to get names from IDs if needed
      await Future.wait([
        _fetchQueryNatureList(),
        _fetchCategoryList(),
      ]);

      setState(() {
        _referenceController.text = details['referenceNo'] ?? _referenceController.text;
        _subjectController.text = details['subject'] ?? _subjectController.text;
        _assignToController.text = details['assignTo'] ?? _assignToController.text;
        _queryController.text = details['query'] ?? _queryController.text;
        _currentStatusId = details['currentStatusId'] ?? _currentStatusId;
        _changeStatusToValue = ''; // Initialize change status to empty
        
        // Set category name - use name from API or find from list
        final categoryName = details['category'] ?? '';
        final categoryId = details['categoryId'] ?? '';
        if (categoryName.isNotEmpty) {
          _categoryController.text = categoryName;
        } else if (categoryId.isNotEmpty) {
          final category = _categoryList.firstWhere(
            (cat) => cat['id'] == categoryId,
            orElse: () => {'name': ''},
          );
          _categoryController.text = category['name'] ?? '';
        }
        
        // Set nature name - use name from API or find from list
        final natureName = details['queryNature'] ?? '';
        final natureId = details['natureId'] ?? '';
        if (natureName.isNotEmpty) {
          _natureController.text = natureName;
        } else if (natureId.isNotEmpty) {
          final nature = _queryNatureList.firstWhere(
            (nat) => nat['id'] == natureId,
            orElse: () => {'name': ''},
          );
          _natureController.text = nature['name'] ?? '';
        }
        
        // Set priority if available
        if (details['priorityText'] != null && details['priorityText'].toString().isNotEmpty) {
          _priorityTextController.text = details['priorityText'] ?? '';
        }
        
        if (details['currentStatus'] != null && details['currentStatus'].toString().isNotEmpty) {
          _statusDisplayController.text = details['currentStatus'] ?? '';
        }
        
        _remarkHistory = List<Map<String, dynamic>>.from(details['remarks'] ?? []);
      });
    } catch (error) {
      if (!mounted) return;
      // Try to use seedData as fallback
      final seedData = widget.seedData ?? {};
      if (seedData.isNotEmpty && _isQueryResolutionEditMode) {
        setState(() {
          _referenceController.text = seedData['reference'] ?? _referenceController.text;
          _subjectController.text = seedData['subject'] ?? _subjectController.text;
          _assignToController.text = seedData['assignedTo'] ?? _assignToController.text;
          _categoryController.text = seedData['categoryName'] ?? seedData['category'] ?? '';
          _natureController.text = seedData['natureName'] ?? seedData['nature'] ?? '';
          if (seedData['status'] != null) {
            _statusDisplayController.text = seedData['status'] ?? '';
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to load query details: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _subjectController.dispose();
    _statusDisplayController.dispose();
    _priorityTextController.dispose();
    _assignToController.dispose();
    _queryController.dispose();
    _remarkController.dispose();
    _categoryController.dispose();
    _natureController.dispose();
    _assignAllController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    // For Query Resolution edit mode, validate change status to
    if (_isQueryResolutionEditMode) {
      if (_changeStatusToValue.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Change Status To.')),
        );
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      ResponseMania response;
      if (_isQueryResolutionEditMode) {
        // For Query Resolution edit mode, only update status
        final selectedStatus = QueryConstants.changeStatusToOptions.firstWhere(
          (s) => s['id'] == _changeStatusToValue,
          orElse: () => {'id': '', 'name': ''},
        );
        final statusId = selectedStatus['id'] ?? '';
        final statusName = selectedStatus['name'] ?? '';
        
        if (statusId.isEmpty || statusName.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid status selected.')),
          );
          return;
        }
        
        response = await widget.model.saveOrUpdateQueryResolution(
          queryResolutionId: _queryId!,
          currentStatusId: statusId,
          currentStatusName: statusName,
        );
      } else {
        // For initiate mode, this shouldn't happen in Query Resolution
        // But keeping for safety
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid operation mode.')),
        );
        return;
      }

      if (!mounted) return;

      if (response is Success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isQueryResolutionEditMode
                ? 'Query resolution updated successfully.'
                : 'Query resolution saved successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else if (response is Failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.responseMessage ?? 'Operation failed.'),
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
        _isSaving = false;
      });
    }
  }

  Future<void> _onSaveRemark() async {
    if (_remarkController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a remark first.')),
      );
      return;
    }

    if (_queryId == null || _queryId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Query ID not available. Please save the query first.')),
      );
      return;
    }

    if (_currentStatusId == null || _currentStatusId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status not available.')),
      );
      return;
    }

    setState(() {
      _isSavingRemark = true;
    });

    try {
      final response = await widget.model.saveQueryResolutionRemark(
        queryResolutionId: _queryId!,
        remark: _remarkController.text.trim(),
        currentStatusId: _currentStatusId!,
      );

      if (!mounted) return;

      if (response is Success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Remark saved successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        _remarkController.clear();
        await _fetchQueryDetails();
      } else if (response is Failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.responseMessage ?? 'Failed to save remark.'),
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
        _isSavingRemark = false;
      });
    }
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
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
        TextField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? Colors.grey[200] : Colors.grey[100],
            suffixIcon: suffix,
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
    required ValueChanged<String?>? onChanged,
  }) {
    // Remove duplicates and ensure value exists in items
    final uniqueItems = <String, DropdownMenuItem<String>>{};
    for (final item in items) {
      if (item.value != null && item.value!.isNotEmpty) {
        uniqueItems[item.value!] = item;
      }
    }
    final finalItems = uniqueItems.values.toList();
    
    // Validate that the value exists in items, if not set to null
    final validValue = value.isNotEmpty && finalItems.any((item) => item.value == value) 
        ? value 
        : null;
    
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
          value: validValue,
          hint: const Text('--- Select ---'),
          decoration: InputDecoration(
            filled: true,
            fillColor: onChanged == null ? Colors.grey[200] : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: [
            const DropdownMenuItem(value: '', child: Text('--- Select ---')),
            ...finalItems,
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildRemarkHistory() {
    final headers = ['Remark By', 'Remark Date', 'Remark'];

    final rows = _remarkHistory
        .map(
          (row) => [
            Text(row['userName']?.toString() ?? ''),
            Text(row['dateTime']?.toString() ?? ''),
            Text(row['remark']?.toString() ?? ''),
          ],
        )
        .toList();

    return GCDataTableCard(
      headers: headers,
      rows: rows,
      emptyPlaceholder: 'No remarks recorded yet.',
    );
  }




  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isInitiateMode ? 'Query Resolution' : 'Edit Query Resolution'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoadingDetails
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[100],
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
            _buildSectionCard(
              title: 'Query Details',
              children: [
                _buildTextField(
                  label: 'Policy / Reference No.',
                  controller: _referenceController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Current Status *',
                  controller: _statusDisplayController,
                  readOnly: true,
                ),
                if (_isQueryResolutionEditMode) ...[
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Change Status To *',
                    value: _changeStatusToValue,
                    items: QueryConstants.changeStatusToOptions.map((status) {
                      return DropdownMenuItem(
                        value: status['id'],
                        child: Text(status['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _changeStatusToValue = value);
                      }
                    },
                  ),
                ],
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Subject Name *',
                  controller: _subjectController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Category *',
                  controller: _categoryController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Query Nature *',
                  controller: _natureController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Assign To *',
                  controller: _assignToController,
                  readOnly: true,
                ),
                if (!_isFromInitiateQueryDrawer) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Assign To (All) *',
                    controller: _assignAllController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Priority *',
                    controller: _priorityTextController,
                    readOnly: true,
                  ),
                ],
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Query *',
                  controller: _queryController,
                  maxLines: 4,
                  readOnly: true,
                ),
              ],
            ),
            if (!_isInitiateMode) ...[
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Remark Details',
                children: [
                  _buildTextField(
                    label: 'Remark *',
                    controller: _remarkController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSavingRemark ? null : _onSaveRemark,
                          child: _isSavingRemark
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Save Remark'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRemarkHistory(),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onSubmit,
                    child: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(_isQueryResolutionEditMode ? 'Update' : 'Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

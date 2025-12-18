import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/response/response.dart';
import 'package:greycell_app/src/models/response/success.dart';
import 'package:greycell_app/src/models/response/failure.dart';
import 'package:greycell_app/src/views/queryResolutionViews/widgets/gc_data_table_card.dart';

enum InitiateQueryMode { initiate, edit }

class InitiateQueryDetailView extends StatefulWidget {
  final MainModel model;
  final InitiateQueryMode mode;
  final Map<String, String>? seedData;

  const InitiateQueryDetailView({
    Key? key,
    required this.model,
    this.mode = InitiateQueryMode.initiate,
    this.seedData,
  }) : super(key: key);

  @override
  State<InitiateQueryDetailView> createState() =>
      _InitiateQueryDetailViewState();
}

class _InitiateQueryDetailViewState extends State<InitiateQueryDetailView> {
  late final TextEditingController _referenceController;
  late final TextEditingController _subjectController;
  late final TextEditingController _assignToController;
  late final TextEditingController _queryController;
  late final TextEditingController _remarkController;

  String _statusValue = '';
  String _categoryValue = '';
  String _natureValue = '';

  List<Map<String, String>> _queryNatureList = [];
  List<Map<String, String>> _queryStatusList = [];
  List<Map<String, String>> _categoryList = [];
  List<Map<String, dynamic>> _remarkHistory = [];
  String? _queryId;
  String? _currentStatusId;
  bool _isLoading = false;
  bool _isLoadingDetails = false;
  bool _isSaving = false;
  bool _isSavingRemark = false;

  bool get _isInitiateMode => widget.mode == InitiateQueryMode.initiate;

  @override
  void initState() {
    super.initState();
    final defaults = widget.seedData ?? {};

    _referenceController =
        TextEditingController(text: defaults['reference'] ?? '');
    _subjectController = TextEditingController(text: defaults['subject'] ?? '');
    _assignToController =
        TextEditingController(text: defaults['assignTo'] ?? '');
    _queryController = TextEditingController(text: defaults['query'] ?? '');
    _remarkController = TextEditingController(text: defaults['remark'] ?? '');

    _statusValue = defaults['statusId'] ?? defaults['status'] ?? '';
    _currentStatusId = defaults['statusId'] ?? '';
    _categoryValue = defaults['categoryId'] ?? defaults['category'] ?? '';
    _natureValue = defaults['natureId'] ?? defaults['nature'] ?? '';
    _queryId = defaults['id'];
    
    // Set default status to "Initiated" (ID 1) if in initiate mode
    if (_isInitiateMode) {
      _statusValue = '1';
      _currentStatusId = '1';
    }

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _fetchQueryNatureList(),
      _fetchQueryStatusList(),
      _fetchCategoryList(),
    ]);

    if (!_isInitiateMode && _queryId != null && _queryId!.isNotEmpty) {
      await _fetchQueryDetails();
    } else if (_isInitiateMode && _queryStatusList.isNotEmpty) {
      // Set default status to "Initiated" (usually ID 1)
      final initiatedStatus = _queryStatusList.firstWhere(
        (status) => status['name']?.toLowerCase() == 'initiated',
        orElse: () => _queryStatusList.first,
      );
      _statusValue = initiatedStatus['id'] ?? '1';
      _currentStatusId = initiatedStatus['id'] ?? '1';
    }
  }

  Future<void> _fetchQueryNatureList() async {
    setState(() {
      _isLoading = true;
    });

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
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchQueryStatusList() async {
    try {
      final statusList = await widget.model.getQueryStatusVector();
      if (!mounted) return;
      setState(() {
        _queryStatusList = statusList;
        if (_queryStatusList.isNotEmpty && _isInitiateMode) {
          final initiatedStatus = _queryStatusList.firstWhere(
            (status) => status['name']?.toLowerCase() == 'initiated',
            orElse: () => _queryStatusList.first,
          );
          _statusValue = initiatedStatus['id'] ?? '';
          _currentStatusId = initiatedStatus['id'] ?? '';
        }
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

  Future<void> _fetchQueryDetails() async {
    if (_queryId == null || _queryId!.isEmpty) return;

    setState(() {
      _isLoadingDetails = true;
    });

    try {
      final details = await widget.model.getInitiateQueryDetails(queryId: _queryId!);
      if (!mounted) return;

      setState(() {
        _referenceController.text = details['referenceNo'] ?? _referenceController.text;
        _subjectController.text = details['subject'] ?? _subjectController.text;
        _assignToController.text = details['assignTo'] ?? _assignToController.text;
        _queryController.text = details['query'] ?? _queryController.text;
        _statusValue = details['currentStatusId'] ?? _statusValue;
        _currentStatusId = details['currentStatusId'] ?? _currentStatusId;
        
        // Validate category value exists in dropdown items (API returns numeric ID)
        final categoryFromApi = details['category'] ?? '';
        if (categoryFromApi.isNotEmpty) {
          final categoryExists = _categoryList.any((cat) => cat['id'] == categoryFromApi);
          if (categoryExists) {
            _categoryValue = categoryFromApi;
          }
        }
        
        // Validate nature value exists in dropdown items
        final natureFromApi = details['queryNature'] ?? '';
        if (natureFromApi.isNotEmpty) {
          final natureExists = _queryNatureList.any((nature) => nature['id'] == natureFromApi);
          if (natureExists) {
            _natureValue = natureFromApi;
          }
        }
        
        // Set status value from API
        if (details['currentStatusId'] != null && details['currentStatusId'].toString().isNotEmpty) {
          _statusValue = details['currentStatusId'] ?? _statusValue;
          _currentStatusId = details['currentStatusId'] ?? _currentStatusId;
        }
        
        _remarkHistory = List<Map<String, dynamic>>.from(details['remarks'] ?? []);
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load query details: $error'),
          backgroundColor: Colors.red,
        ),
      );
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
    _assignToController.dispose();
    _queryController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Subject Name.')),
      );
      return;
    }

    if (_natureValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Query Nature.')),
      );
      return;
    }

    if (_categoryValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Category.')),
      );
      return;
    }

    if (_queryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Query.')),
      );
      return;
    }

    if (_statusValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Current Status.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      ResponseMania response;
      
      // Get status name for API call
      final statusName = _queryStatusList.firstWhere(
        (s) => s['id'] == _statusValue,
        orElse: () => {'name': ''},
      )['name'] ?? '';
      
      if (_isInitiateMode) {
        // Use addInitiateQuery for initiate mode
        response = await widget.model.addInitiateQuery(
          queryId: null,
          currentStatus: _statusValue,
          subject: _subjectController.text.trim(),
          category: _categoryValue,
          queryNature: _natureValue,
          assignTo: _assignToController.text.trim(),
          query: _queryController.text.trim(),
        );
      } else {
        // Use updateInitiateQuery for edit mode - always calls APIUpdateInitiateQuery
        response = await widget.model.updateInitiateQuery(
          queryId: _queryId!,
          currentStatus: _statusValue,
          currentStatusName: statusName,
          subject: _subjectController.text.trim(),
          category: _categoryValue,
          queryNature: _natureValue,
          assignTo: _assignToController.text.trim(),
          query: _queryController.text.trim(),
        );
      }

      if (!mounted) return;

      if (response is Success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isInitiateMode
                ? 'Query initiated successfully.'
                : 'Query updated successfully.'),
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
      final response = await widget.model.addInitiateQueryRemarks(
        queryId: _queryId!,
        remark: _remarkController.text.trim(),
        currentStatus: _currentStatusId!,
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
        title: Text(_isInitiateMode ? 'Initiate Query' : 'Edit Initiate Query'),
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
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildDropdown(
                              label: 'Current Status *',
                              value: _statusValue,
                              items: _queryStatusList.map((status) {
                                return DropdownMenuItem(
                                  value: status['id'],
                                  child: Text(status['name'] ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _statusValue = value;
                                    _currentStatusId = value;
                                  });
                                }
                              },
                            ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Subject Name *',
                        controller: _subjectController,
                        readOnly: !_isInitiateMode,
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Category *',
                        value: _categoryValue,
                        items: _categoryList.map((category) {
                          return DropdownMenuItem(
                            value: category['id'],
                            child: Text(category['name'] ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _categoryValue = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildDropdown(
                              label: 'Query Nature *',
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
                      _buildTextField(
                        label: 'Assign To *',
                        controller: _assignToController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Query *',
                        controller: _queryController,
                        maxLines: 4,
                        readOnly: !_isInitiateMode,
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
                              : Text(_isInitiateMode ? 'Save' : 'Update'),
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


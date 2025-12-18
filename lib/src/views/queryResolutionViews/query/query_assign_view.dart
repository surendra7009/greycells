import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/views/queryResolutionViews/widgets/gc_data_table_card.dart';
import 'package:greycell_app/src/views/queryResolutionViews/query_resolution_detail_view.dart';
import 'package:intl/intl.dart';

class QueryAssignView extends StatefulWidget {
  final MainModel model;

  const QueryAssignView({Key? key, required this.model}) : super(key: key);

  @override
  State<QueryAssignView> createState() => _QueryAssignViewState();
}

class _QueryAssignViewState extends State<QueryAssignView> {
  final DateFormat _dateFormat = DateFormat('dd-MMM-yyyy');

  late DateTime _fromDate;
  late DateTime _toDate;

  String _natureValue = '';
  String _categoryValue = '';
  String _priorityValue = '';

  List<Map<String, String>> _queryNatureList = [];
  List<Map<String, String>> _priorityList = [];
  List<Map<String, String>> _categoryList = [];
  List<Map<String, dynamic>> _queryList = [];
  
  bool _isLoading = false;
  bool _isLoadingQueries = false;
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _recordPerPageController =
      TextEditingController(text: '10');
  String _searchColumn = 'REF_NO';

  @override
  void initState() {
    super.initState();
    _toDate = DateTime.now();
    _fromDate = _toDate.subtract(const Duration(days: 15));
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _recordPerPageController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load dropdown options first, then query list separately
      await Future.wait([
        _fetchQueryNatureList(),
        _fetchQueryPriorityList(),
        _fetchCategoryList(),
      ]);
      // Only fetch query list if user is logged in
      if (widget.model.user != null && widget.model.school != null) {
        await _fetchQueryList();
      }
    } catch (e) {
      // Silently handle errors during initial load
      if (mounted) {
        setState(() {
          _errorMessage = null; // Don't show error on initial load
        });
      }
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
      setState(() {
        _errorMessage = 'Unable to load query nature list.';
      });
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
      // Ignore priority loading errors
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
      // Ignore category loading errors
    }
  }

  Future<void> _fetchQueryList() async {
    // Don't fetch if user is not logged in
    if (widget.model.user == null || widget.model.school == null) {
      return;
    }

    setState(() {
      _isLoadingQueries = true;
      _errorMessage = null;
    });

    try {
      final fromDateStr = _dateFormat.format(_fromDate).toUpperCase();
      final toDateStr = _dateFormat.format(_toDate).toUpperCase();

      final queryList = await widget.model.getQueryResolutionList(
        fromDate: fromDateStr,
        toDate: toDateStr,
        queryNatureId: _natureValue.isNotEmpty ? _natureValue : null,
        categoryId: _categoryValue.isNotEmpty ? _categoryValue : null,
        priorityId: _priorityValue.isNotEmpty ? _priorityValue : null,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout: Unable to fetch query list');
        },
      );

      if (!mounted) return;

      // Apply search filter if search keyword is provided
      List<Map<String, dynamic>> filteredList = queryList;
      if (_searchController.text.isNotEmpty) {
        final searchKeyword = _searchController.text.toLowerCase();
        filteredList = queryList.where((query) {
          switch (_searchColumn) {
            case 'REF_NO':
              return query['referenceNo']?.toString().toLowerCase().contains(searchKeyword) ?? false;
            case 'SUBJECT':
              return query['subject']?.toString().toLowerCase().contains(searchKeyword) ?? false;
            case 'QUERY_STATUS':
              return query['status']?.toString().toLowerCase().contains(searchKeyword) ?? false;
            default:
              return false;
          }
        }).toList();
      }

      setState(() {
        _queryList = filteredList;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load query list.';
        _queryList = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingQueries = false;
      });
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initialDate = isFrom ? _fromDate : _toDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: isFrom ? 'Select From Date' : 'Select To Date',
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
      await _fetchQueryList();
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

  String? _getDropdownValue(String value, List<DropdownMenuItem<String>> items, bool includeAllOption) {
    // If includeAllOption is true and value is empty, return null to show hint
    if (includeAllOption && value.isEmpty) {
      return null;
    }
    
    // If value is empty and no items, return null
    if (value.isEmpty) {
      return null;
    }
    
    // Check if value exists in items (excluding empty values)
    final validItems = items.where((item) => item.value != null && item.value!.isNotEmpty).toList();
    final valueExists = validItems.any((item) => item.value == value);
    
    // If value doesn't exist in items, return null
    if (!valueExists) {
      return null;
    }
    
    return value;
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(List<DropdownMenuItem<String>> items, bool includeAllOption) {
    // Filter out any items with null or empty values to prevent duplicates
    final validItems = items.where((item) => item.value != null && item.value!.isNotEmpty).toList();
    
    if (includeAllOption) {
      return [
        const DropdownMenuItem(value: '', child: Text('--- All ---')),
        ...validItems,
      ];
    }
    
    return validItems;
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    bool showAsterisk = false,
    bool includeAllOption = false,
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
            if (showAsterisk) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _getDropdownValue(value, items, includeAllOption),
          hint: includeAllOption ? const Text('--- All ---') : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: _buildDropdownItems(items, includeAllOption),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Records / Page',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _recordPerPageController.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: '10', child: Text('10')),
                          DropdownMenuItem(value: '20', child: Text('20')),
                          DropdownMenuItem(value: '50', child: Text('50')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _recordPerPageController.text = value;
                            });
                            _fetchQueryList();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search By',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _searchColumn,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'REF_NO', child: Text('Reference No.')),
                          DropdownMenuItem(
                              value: 'SUBJECT', child: Text('Subject Name')),
                          DropdownMenuItem(
                              value: 'QUERY_STATUS', child: Text('Current Status')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _searchColumn = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search keyword',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => _fetchQueryList(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchQueryList();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    _fetchQueryList();
  }

  @override
  Widget build(BuildContext context) {
    final headers = [
      '#',
      'Reference No',
      'Subject Name',
      'Query',
      'Initiated By',
      'Assigned to',
      'Current Status',
      'Edit / View',
    ];

    final rows = _queryList.asMap().entries.map((entry) {
      final index = entry.key;
      final query = entry.value;
      return [
        Text('${index + 1}'),
        Text(query['referenceNo']?.toString() ?? ''),
        Text(query['subject']?.toString() ?? ''),
        Text(
          query['query']?.toString() ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(query['initiatedBy']?.toString() ?? ''),
        Text(query['assignedTo']?.toString() ?? ''),
        Chip(
          label: Text(query['status']?.toString() ?? ''),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QueryResolutionDetailView(
                  model: widget.model,
                  mode: QueryResolutionMode.edit,
                  isFromInitiateQueryDrawer: false,
                  seedData: {
                    'id': query['id']?.toString() ?? '',
                    'reference': query['referenceNo']?.toString() ?? '',
                    'subject': query['subject']?.toString() ?? '',
                    'assignTo': query['assignedToName']?.toString() ?? query['assignedTo']?.toString() ?? '',
                    'status': query['status']?.toString() ?? '',
                    'statusId': query['statusId']?.toString() ?? '',
                    'query': query['query']?.toString() ?? '',
                    'categoryId': query['categoryId']?.toString() ?? '',
                    'natureId': query['natureId']?.toString() ?? '',
                    'priorityName': query['priorityName']?.toString() ?? '',
                  },
                ),
              ),
            );
          },
        ),
      ];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Assign'),
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
                          Text(
                            'Filters',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildDateField(
                            label: 'From Date',
                            value: _fromDate,
                            onTap: () => _pickDate(isFrom: true),
                          ),
                          const SizedBox(height: 12),
                          _buildDateField(
                            label: 'To Date',
                            value: _toDate,
                            onTap: () => _pickDate(isFrom: false),
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Query Nature',
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
                            includeAllOption: true,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Category',
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
                            includeAllOption: true,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Query Priority',
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
                            includeAllOption: true,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _applyFilters,
                            icon: const Icon(Icons.filter_alt),
                            label: const Text('Apply Filters'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchRow(),
                  const SizedBox(height: 16),
                  _isLoadingQueries
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red, size: 48),
                                    const SizedBox(height: 8),
                                    Text(
                                      _errorMessage!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: _fetchQueryList,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GCDataTableCard(
                              headers: headers,
                              rows: rows,
                              emptyPlaceholder: 'No query records found.',
                              columnWidths: const {
                                0: FixedColumnWidth(50),   // #
                                1: FlexColumnWidth(1.2),   // Reference No
                                2: FlexColumnWidth(2.0),   // Subject Name
                                3: FlexColumnWidth(2.5),   // Query
                                4: FlexColumnWidth(1.5),   // Initiated By
                                5: FlexColumnWidth(1.5),   // Assigned to
                                6: FlexColumnWidth(1.0),   // Current Status
                                7: FixedColumnWidth(80),   // Edit / View
                              },
                            ),
                ],
              ),
            ),
    );
  }
}


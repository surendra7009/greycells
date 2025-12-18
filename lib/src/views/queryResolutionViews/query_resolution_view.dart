import 'package:flutter/material.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/views/queryResolutionViews/widgets/gc_data_table_card.dart';
import 'package:greycell_app/src/views/queryResolutionViews/query_resolution_detail_view.dart';
import 'package:greycell_app/src/views/queryResolutionViews/initiate_query_detail_view.dart';
import 'package:intl/intl.dart';

class QueryResolutionView extends StatefulWidget {
  final MainModel model;
  final String? title;

  const QueryResolutionView({
    Key? key,
    required this.model,
    this.title,
  }) : super(key: key);

  @override
  State<QueryResolutionView> createState() => _QueryResolutionViewState();
}

class _QueryResolutionViewState extends State<QueryResolutionView> {
  final DateFormat _dateFormat = DateFormat('dd-MMM-yyyy');

  late DateTime _fromDate;
  late DateTime _toDate;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _recordPerPageController =
      TextEditingController(text: '10');

  String _natureValue = '';
  String _categoryValue = '';
  String _priorityValue = '';
  String _searchColumn = 'REF_NO';

  List<Map<String, String>> _queryNatureList = [];
  List<Map<String, String>> _priorityList = [];
  List<Map<String, String>> _categoryList = [];
  List<Map<String, dynamic>> _queryList = [];
  bool _isLoading = false;
  bool _isLoadingQueries = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _toDate = DateTime.now();
    _fromDate = _toDate.subtract(const Duration(days: 15));
    _fetchQueryNatureList();
    _fetchCategoryList();
    
    // Fetch priority list only for Query Resolution mode (priority filter is shown)
    if (widget.title == 'Query Resolution') {
      _fetchQueryPriorityList();
    }
    
    // Always fetch query list - it will call the correct API based on title
    _fetchQueryList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _recordPerPageController.dispose();
    super.dispose();
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
    }
  }

  Future<void> _fetchQueryNatureList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
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
    } catch (_) {
      // Silently ignore priority loading errors to avoid blocking the main view
    }
  }

  Future<void> _fetchCategoryList() async {
    try {
      final categoryList = await widget.model.getCategoryHelpdeskVector();
      if (!mounted) return;
      setState(() {
        _categoryList = categoryList;
      });
    } catch (_) {
      // Silently ignore category loading errors to avoid blocking the main view
    }
  }

  Future<void> _fetchQueryList() async {
    setState(() {
      _isLoadingQueries = true;
      _errorMessage = null;
    });

    try {
      final fromDateStr = _dateFormat.format(_fromDate).toUpperCase();
      final toDateStr = _dateFormat.format(_toDate).toUpperCase();
      
      List<Map<String, dynamic>> queryList;
      
      // Use getQueryResolutionList for "Query Resolution" mode
      if (widget.title == 'Query Resolution') {
        queryList = await widget.model.getQueryResolutionList(
          fromDate: fromDateStr,
          toDate: toDateStr,
          queryNatureId: _natureValue.isNotEmpty ? _natureValue : null,
          categoryId: _categoryValue.isNotEmpty ? _categoryValue : null,
          priorityId: _priorityValue.isNotEmpty ? _priorityValue : null,
        );
      } else {
        // Use getInitiateQueryList for "Initiate Query" mode
        queryList = await widget.model.getInitiateQueryList(
          fromDate: fromDateStr,
          toDate: toDateStr,
          queryNatureId: _natureValue.isNotEmpty ? _natureValue : null,
          categoryId: _categoryValue.isNotEmpty ? _categoryValue : null,
        );
      }

      if (!mounted) return;

      // Apply search filter if search keyword is provided
      List<Map<String, dynamic>> filteredList = queryList;
      if (_searchController.text.isNotEmpty) {
        final searchKeyword = _searchController.text.toLowerCase();
        filteredList = queryList.where((query) {
          switch (_searchColumn) {
            case 'REF_NO':
              return query['referenceNo']?.toLowerCase().contains(searchKeyword) ?? false;
            case 'SUBJECT':
              return query['subject']?.toLowerCase().contains(searchKeyword) ?? false;
            case 'QUERY_STATUS':
              return query['status']?.toLowerCase().contains(searchKeyword) ?? false;
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

  void _applyFilters() {
    _fetchQueryList();
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required VoidCallback onTap,
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
    required List<DropdownMenuItem<String>> items,
    required String value,
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
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildStatisticsCards() {
    if (_queryList.isEmpty) return const SizedBox.shrink();
    
    final totalQueries = _queryList.length;
    final resolvedQueries = _queryList.where((q) => 
      (q['status']?.toString().toLowerCase() ?? '').contains('resolved') ||
      (q['status']?.toString().toLowerCase() ?? '').contains('closed')
    ).length;
    final pendingQueries = totalQueries - resolvedQueries;
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    totalQueries.toString(),
                    Icons.assignment,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Resolved',
                    resolvedQueries.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pendingQueries.toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
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
                  child: _buildDropdown(
                    label: 'Records / Page',
                    value: _recordPerPageController.text,
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
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'Search By',
                    value: _searchColumn,
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

  @override
  Widget build(BuildContext context) {
    final headers = [
      '#',
      'Reference No',
      'Subject Name',
      'Status',
      'Initiated By',
      'Assigned to',
      'Edit / View',
    ];

    final rows = _queryList.asMap().entries.map((entry) {
      final index = entry.key;
      final query = entry.value;
      return [
        Text(
          '${index + 1}',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          query['referenceNo'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          query['subject'] ?? '',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        Chip(
          label: Text(
            query['status'] ?? '',
            style: const TextStyle(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: Theme.of(context).primaryColorDark),
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        Text(
          query['initiatedBy'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          query['assignedTo'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        IconButton(
          icon: const Icon(Icons.open_in_new, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => widget.title == 'Initiate Query'
                    ? InitiateQueryDetailView(
                        model: widget.model,
                        mode: InitiateQueryMode.edit,
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
                      )
                    : QueryResolutionDetailView(
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

    final bool hideNewButton = widget.title == 'Query Resolution';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Query Resolution'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: hideNewButton
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => widget.title == 'Initiate Query'
                        ? InitiateQueryDetailView(
                            model: widget.model,
                            mode: InitiateQueryMode.initiate,
                          )
                        : QueryResolutionDetailView(
                            model: widget.model,
                            mode: QueryResolutionMode.initiate,
                            isFromInitiateQueryDrawer: false,
                          ),
                  ),
                );
              },
              child: const Icon(Icons.add),
              tooltip: 'Initiate Query',
            ),
      body: Container(
        color: Colors.grey[100],
        child: RefreshIndicator(
          onRefresh: _fetchQueryList,
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
                    Column(
                      children: [
                        _buildDateField(
                          label: 'From Date *',
                          value: _fromDate,
                          onTap: () => _pickDate(isFrom: true),
                        ),
                        const SizedBox(height: 12),
                        _buildDateField(
                          label: 'To Date *',
                          value: _toDate,
                          onTap: () => _pickDate(isFrom: false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildDropdown(
                            label: 'Nature *',
                            value: _natureValue,
                            items: [
                              const DropdownMenuItem(value: '', child: Text('--- All ---')),
                              ..._queryNatureList.map((nature) {
                                return DropdownMenuItem(
                                  value: nature['id'],
                                  child: Text(nature['name'] ?? ''),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _natureValue = value);
                              }
                            },
                          ),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      label: 'Category *',
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
                    if (widget.title == 'Query Resolution') ...[
                      const SizedBox(height: 12),
                      _buildDropdown(
                        label: 'Priority *',
                        value: _priorityValue,
                        items: [
                          const DropdownMenuItem(
                              value: '', child: Text('--- All ---')),
                          ..._priorityList.map((priority) {
                            return DropdownMenuItem(
                              value: priority['id'],
                              child: Text(priority['name'] ?? ''),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _priorityValue = value);
                          }
                        },
                      ),
                    ],
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
            _buildStatisticsCards(),
            const SizedBox(height: 16),
            _isLoadingQueries
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 48),
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
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final tableWidth = constraints.maxWidth;
                          // Calculate fixed widths based on available space
                          final fixedWidths = tableWidth - 130; // Reserve space for # and Edit columns
                          return GCDataTableCard(
                            headers: headers,
                            rows: rows,
                            emptyPlaceholder: 'No query records found.',
                            rawData: _queryList,
                            title: 'Query Results',
                            columnWidths: {
                              0: FixedColumnWidth(40),   // #
                              1: FixedColumnWidth(fixedWidths * 0.15),   // Reference No
                              2: FixedColumnWidth(fixedWidths * 0.30),   // Subject Name
                              3: FixedColumnWidth(fixedWidths * 0.12),   // Status
                              4: FixedColumnWidth(fixedWidths * 0.20),   // Initiated By
                              5: FixedColumnWidth(fixedWidths * 0.20),   // Assigned to
                              6: FixedColumnWidth(50),   // Edit / View
                            },
                          );
                        },
                      ),
            ],
          ),
        ),
      ),
    );
  }
}

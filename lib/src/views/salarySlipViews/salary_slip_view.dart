import 'package:flutter/material.dart';
import 'package:greycell_app/src/config/apiauth_config.dart';
import 'package:greycell_app/src/config/core_config.dart';
import 'package:greycell_app/src/config/data.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/salarySlip/salary_slip_report.dart';
import 'package:greycell_app/src/models/user/staff_model.dart';
import 'package:greycell_app/src/views/webViewScreens/web_view_screen.dart';

class SalarySlipView extends StatefulWidget {
  final MainModel model;

  const SalarySlipView({Key? key, required this.model}) : super(key: key);

  @override
  State<SalarySlipView> createState() => _SalarySlipViewState();
}

class _SalarySlipViewState extends State<SalarySlipView> {
  late final TextEditingController _staffCodeController;
  late final TextEditingController _staffNameController;
  late final TextEditingController _yearMonthDisplayController;

  DateTime? _selectedMonth;
  String _apiYearMonth = '';
  bool _includeLoanDetails = false;
  bool _isUpdatingDisplay = false;
  bool _isFetchingReport = false;

  static const _newReportUrl =
      'https://arrowleaf.solutions/schooldemo/salary-slip/view-new-report.html';
  static const _oldReportUrl =
      'https://arrowleaf.solutions/schooldemo/salary-slip/view-old-report.html';

  final Map<String, int> _monthLookup = {
    for (int i = 0; i < CustomDateTime.monthList.length; i++) ...{
      CustomDateTime.monthList[i]['short'].toString().toLowerCase(): i + 1,
      CustomDateTime.monthList[i]['name'].toString().toLowerCase(): i + 1,
    }
  };

  @override
  void initState() {
    super.initState();
    final staff = _resolveStaff();
    final staffCode = staff?.getStaffCode ?? widget.model.user?.getUserId ?? '';
    final staffName = staff?.getStaffName ?? widget.model.user?.getUserId ?? '';
    final defaults = _getDefaultMonthPair();

    _staffCodeController = TextEditingController(text: staffCode);
    _staffNameController = TextEditingController(text: staffName);
    _yearMonthDisplayController =
        TextEditingController(text: defaults.displayFormat);

    _apiYearMonth = defaults.apiFormat;
    _selectedMonth = defaults.date;
  }

  Staff? _resolveStaff() {
    try {
      return widget.model.staff;
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _staffCodeController.dispose();
    _staffNameController.dispose();
    _yearMonthDisplayController.dispose();
    super.dispose();
  }

  _MonthPair _getDefaultMonthPair() {
    final now = DateTime.now();
    final previous = DateTime(now.year, now.month - 1, 1);
    final monthMeta = CustomDateTime.monthList[previous.month - 1];
    final display =
        '${monthMeta['short'].toString().toUpperCase()}-${previous.year.toString()}';
    final api = '${previous.year}${previous.month.toString().padLeft(2, '0')}';
    return _MonthPair(displayFormat: display, apiFormat: api, date: previous);
  }

  Future<void> _pickMonth() async {
    final initialDate = _selectedMonth ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: 'Select Month',
    );

    if (picked != null) {
      final monthMeta = CustomDateTime.monthList[picked.month - 1];
      final display =
          '${monthMeta['short'].toString().toUpperCase()}-${picked.year.toString()}';
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month, 1);
        _yearMonthDisplayController.text = display;
        _apiYearMonth =
            '${picked.year}${picked.month.toString().padLeft(2, '0')}';
      });
    }
  }

  void _handleManualMonthChange(String value) {
    final input = value.trim();
    if (input.isEmpty || !input.contains('-')) {
      return;
    }

    final parts = input.split('-');
    if (parts.length != 2) {
      return;
    }

    final monthPart = parts[0].trim().toLowerCase();
    final yearPart = parts[1].trim();

    if (yearPart.length != 4 || int.tryParse(yearPart) == null) {
      return;
    }

    int? monthIndex = _monthLookup[monthPart];
    if (monthIndex == null && monthPart.length >= 3) {
      monthIndex = _monthLookup[monthPart.substring(0, 3)];
    }

    if (monthIndex == null) {
      return;
    }

    final resolvedMonthIndex = monthIndex;
    final display =
        '${CustomDateTime.monthList[resolvedMonthIndex - 1]['short'].toString().toUpperCase()}-$yearPart';

    setState(() {
      _selectedMonth = DateTime(int.parse(yearPart), resolvedMonthIndex, 1);
      _apiYearMonth =
          '${yearPart}${resolvedMonthIndex.toString().padLeft(2, '0')}';
    });

    if (_yearMonthDisplayController.text != display) {
      _isUpdatingDisplay = true;
      _yearMonthDisplayController.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );
      _isUpdatingDisplay = false;
    }
  }

  Future<void> _openReport({required bool isNew}) async {
    final staffCode = _staffCodeController.text.trim();
    final staffName = _staffNameController.text.trim();

    if (staffCode.isEmpty || staffName.isEmpty) {
      _showMessage('Staff profile is incomplete. Please try again later.',
          offerFallback: false);
      return;
    }

    if (isNew) {
      await _fetchSalarySlipViaApi(staffCode: staffCode);
    } else {
      _openStaticReport(useNewReport: false, staffCode: staffCode);
    }
  }

  void _openStaticReport({
    required bool useNewReport,
    required String staffCode,
  }) {
    final uri = Uri.parse(useNewReport ? _newReportUrl : _oldReportUrl).replace(
      queryParameters: {
        'yearMonth': _apiYearMonth,
        'staffCode': staffCode,
        'includeLoan': _includeLoanDetails.toString(),
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewScreen(
          url: uri.toString(),
          title: 'Salary Slip',
          model: widget.model,
        ),
      ),
    );
  }

  Future<void> _fetchSalarySlipViaApi({required String staffCode}) async {
    if (_apiYearMonth.isEmpty) {
      _showMessage('Please select a month to continue.');
      return;
    }
    final loginUserId = widget.model.user?.getUserId ?? staffCode;
    final staffId = _resolveStaffId() ?? staffCode;

    setState(() => _isFetchingReport = true);
    try {
      final SalarySlipReport? report = await widget.model.getSalarySlipReport(
        staffCode: staffCode,
        yearMonth: _apiYearMonth,
        loginUserId: loginUserId,
        staffId: staffId,
        toYearMonthLabel: _yearMonthDisplayController.text.trim(),
        includeLoanDetails: _includeLoanDetails,
      );

      if (!mounted) return;

      if (report == null) {
        _showMessage('Unable to fetch salary slip.', offerFallback: true);
        return;
      }

      if (!report.isSuccess) {
        _showMessage(
          report.message ?? 'Unable to fetch salary slip.',
          offerFallback: true,
        );
        return;
      }

      final resolvedUrl = report.resolveReportUrl(
        primaryHost: widget.model.school?.schoolFirstServerAddress,
        reportsBaseUrl: RestAPIs.GREYCELL_REPORT_URL,
      );

      if (resolvedUrl == null) {
        _showMessage(
          'Salary slip generated but download link is missing.',
          offerFallback: true,
        );
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: resolvedUrl,
            title: 'Salary Slip',
            model: widget.model,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage(
        'Something went wrong while fetching salary slip.',
        offerFallback: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isFetchingReport = false);
      }
    }
  }

  String? _resolveStaffId() {
    final staff = _resolveStaff();
    return widget.model.user?.getUserWingId ??
        staff?.getUserId ??
        staff?.getStaffCode;
  }

  void _showMessage(String message, {bool offerFallback = false}) {
    final fallbackCode = _staffCodeController.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: offerFallback && fallbackCode.isNotEmpty
            ? SnackBarAction(
                label: 'Open Web',
                onPressed: () => _openStaticReport(
                    useNewReport: true, staffCode: fallbackCode),
              )
            : null,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
    String? hint,
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
          readOnly: true,
          decoration: _inputDecoration(hint ?? ''),
        ),
      ],
    );
  }

  Widget _buildYearMonthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YYYYMM *',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _yearMonthDisplayController,
          decoration: _inputDecoration('Sep-2025').copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: _pickMonth,
            ),
          ),
          textCapitalization: TextCapitalization.characters,
          onChanged: (value) {
            if (_isUpdatingDisplay) return;
            _handleManualMonthChange(value);
          },
        ),
        const SizedBox(height: 6),
        Text(
          '(Displayed: MMM-YYYY | API format: $_apiYearMonth)',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLoanCheckbox() {
    return CheckboxListTile(
      value: _includeLoanDetails,
      onChanged: (value) {
        setState(() {
          _includeLoanDetails = value ?? false;
        });
      },
      title: Text(
        'Print Loan Details',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildApiField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Format (YYYYMM)',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: _inputDecoration('').copyWith(
            suffixIcon: const Icon(Icons.lock),
          ),
          child: Text(
            _apiYearMonth,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _openReport(isNew: false),
            icon: const Icon(Icons.history),
            label: const Text('View Old Report'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                _isFetchingReport ? null : () => _openReport(isNew: true),
            icon: _isFetchingReport
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf),
            label: Text(
              _isFetchingReport ? 'Generating...' : 'View New Report',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStaff = widget.model.user?.getUserType == Core.STAFF_USER;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Slip Report'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isFetchingReport ? null : () => _openReport(isNew: true),
        child: _isFetchingReport
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.arrow_circle_right),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isStaff)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Chip(
                              label: Text(
                                'Staff Access',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                            ),
                          ),
                        if (isStaff) const SizedBox(height: 16),
                        _buildReadOnlyField(
                          label: 'Staff Code',
                          controller: _staffCodeController,
                          hint: 'MG018M0698',
                        ),
                        const SizedBox(height: 20),
                        _buildReadOnlyField(
                          label: 'Staff Name',
                          controller: _staffNameController,
                          hint: 'John Smith',
                        ),
                        const SizedBox(height: 20),
                        _buildYearMonthField(),
                        const SizedBox(height: 20),
                        _buildApiField(),
                        const SizedBox(height: 10),
                        _buildLoanCheckbox(),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isFetchingReport)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthPair {
  final String displayFormat;
  final String apiFormat;
  final DateTime date;

  _MonthPair({
    required this.displayFormat,
    required this.apiFormat,
    required this.date,
  });
}

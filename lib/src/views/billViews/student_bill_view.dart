import 'package:flutter/material.dart';
import 'package:greycell_app/src/config/core_config.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/student/student_model.dart';
import 'package:greycell_app/src/views/webViewScreens/web_view_screen.dart';

class StudentBillView extends StatefulWidget {
  final MainModel model;

  const StudentBillView({Key? key, required this.model}) : super(key: key);

  @override
  State<StudentBillView> createState() => _StudentBillViewState();
}

class _StudentBillViewState extends State<StudentBillView> {
  late final TextEditingController _studentNameController;
  late final TextEditingController _rollNoController;
  late final TextEditingController _registrationNoController;

  String? _selectedCurriculum;
  String? _selectedBatch;
  String? _selectedFeeSchemeType;

  List<Map<String, String>> _curriculumOptions = [];
  bool _isCurriculumLoading = false;
  String? _curriculumError;

  List<Map<String, String>> _batchOptions = [];
  bool _isBatchLoading = false;
  String? _batchError;

  List<String> _feeSchemeTypes = [];
  bool _isFeeSchemeLoading = false;
  String? _feeSchemeError;
  Map<String, Map<String, String>> _feeSchemeTypeMap = {};
  String? _studentId;
  bool _isGeneratingReport = false;

  @override
  void initState() {
    super.initState();
    final student = _resolveStudent();
    final studentName = student?.fullName ?? widget.model.user?.getUserId ?? '';
    final rollNo = student?.getUserId ?? '';
    final registrationNo = student?.getRegistrationNo ?? '';

    _studentNameController = TextEditingController(text: studentName);
    _rollNoController = TextEditingController(text: rollNo);
    _registrationNoController = TextEditingController(text: registrationNo);

    _fetchCurriculumOptions();
  }

  Future<void> _fetchCurriculumOptions() async {
    setState(() {
      _isCurriculumLoading = true;
      _curriculumError = null;
    });

    try {
      final options = await widget.model.fetchCourseVectorCurriculum();
      if (!mounted) return;
      setState(() {
        _curriculumOptions = options;
        _selectedCurriculum =
            options.isNotEmpty ? options.first['value'] : null;
      });
      // Fetch batches for the selected curriculum
      if (_selectedCurriculum != null) {
        _fetchBatchOptions(_selectedCurriculum);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _curriculumOptions = [];
        _selectedCurriculum = null;
        _curriculumError = 'Unable to load curriculum list. Please try again.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isCurriculumLoading = false;
      });
    }
  }

  Future<void> _fetchBatchOptions(String? courseId) async {
    if (courseId == null || courseId.isEmpty) {
      setState(() {
        _batchOptions = [];
        _selectedBatch = null;
        _isBatchLoading = false;
        _batchError = null;
      });
      return;
    }

    setState(() {
      _isBatchLoading = true;
      _batchError = null;
      _selectedBatch = null;
    });

    try {
      final options = await widget.model.fetchBatchVectorOnCourse(
        courseId: courseId,
      );
      if (!mounted) return;
      setState(() {
        _batchOptions = options;
        _selectedBatch = options.isNotEmpty ? options.first['value'] : null;
      });
      // Fetch fee scheme types when batch is selected
      if (_selectedBatch != null && _selectedCurriculum != null) {
        _fetchFeeSchemeTypes();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _batchOptions = [];
        _selectedBatch = null;
        _batchError = 'Unable to load batch list. Please try again.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isBatchLoading = false;
      });
    }
  }

  Future<void> _fetchFeeSchemeTypes() async {
    setState(() {
      _isFeeSchemeLoading = true;
      _feeSchemeError = null;
      _selectedFeeSchemeType = null;
    });

    try {
      final billDetails = await widget.model.fetchStudentBillDetails();
      if (!mounted) return;
      setState(() {
        _feeSchemeTypes = List<String>.from(billDetails['feeSchemeTypes'] ?? []);
        _feeSchemeTypeMap = Map<String, Map<String, String>>.from(
            billDetails['feeSchemeTypeMap'] ?? {});
        _studentId = billDetails['studentId']?.toString();
        _selectedFeeSchemeType =
            _feeSchemeTypes.isNotEmpty ? _feeSchemeTypes.first : null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _feeSchemeTypes = [];
        _feeSchemeTypeMap = {};
        _studentId = null;
        _selectedFeeSchemeType = null;
        _feeSchemeError = 'Unable to load fee scheme types. Please try again.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isFeeSchemeLoading = false;
      });
    }
  }

  Student? _resolveStudent() {
    try {
      return widget.model.student;
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _rollNoController.dispose();
    _registrationNoController.dispose();
    super.dispose();
  }

  Future<void> _viewStudentBill() async {
    if (_selectedCurriculum == null ||
        _selectedBatch == null ||
        _selectedFeeSchemeType == null ||
        _studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Curriculum, Batch, and Fee Scheme Type to continue.'),
        ),
      );
      return;
    }

    final feeSchemeInfo = _feeSchemeTypeMap[_selectedFeeSchemeType];
    if (feeSchemeInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fee scheme type information not found.'),
        ),
      );
      return;
    }

    setState(() {
      _isGeneratingReport = true;
    });

    try {
      final reportUrl = await widget.model.fetchStudentBillPrint(
        courseId: _selectedCurriculum!,
        batchId: _selectedBatch!,
        feeSchemeTypeId: feeSchemeInfo['id']!,
        feeSchemeTypeName: feeSchemeInfo['name']!,
        studentId: _studentId!,
        buttonName: 'P', // P for PDF
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: reportUrl,
            title: 'Student Bill',
            model: widget.model,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating bill: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isGeneratingReport = false;
      });
    }
  }

  Future<void> _viewAccountDetail() async {
    if (_selectedCurriculum == null ||
        _selectedBatch == null ||
        _selectedFeeSchemeType == null ||
        _studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Curriculum, Batch, and Fee Scheme Type to continue.'),
        ),
      );
      return;
    }

    final feeSchemeInfo = _feeSchemeTypeMap[_selectedFeeSchemeType];
    if (feeSchemeInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fee scheme type information not found.'),
        ),
      );
      return;
    }

    setState(() {
      _isGeneratingReport = true;
    });

    try {
      final reportUrl = await widget.model.fetchStudentBillAccountPrint(
        courseId: _selectedCurriculum!,
        batchId: _selectedBatch!,
        feeSchemeTypeId: feeSchemeInfo['id']!,
        feeSchemeTypeName: feeSchemeInfo['name']!,
        studentId: _studentId!,
        buttonName: 'P', // P for PDF
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: reportUrl,
            title: 'Account Detail',
            model: widget.model,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating account detail: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isGeneratingReport = false;
      });
    }
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
          enabled: false,
          decoration: _inputDecoration(hint ?? ''),
        ),
      ],
    );
  }

  String? _resolveDropdownValue(
      String? value, List<Map<String, String>> options) {
    if (value == null ||
        !options.any((option) => option['value'] == value)) {
      return null;
    }
    return value;
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<Map<String, String>> options,
    required Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${isRequired ? ' *' : ''}',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _resolveDropdownValue(value, options),
          decoration: _inputDecoration('--Select--'),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(option['title'] ?? ''),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCurriculumField() {
    if (_isCurriculumLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Curriculum *',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_curriculumError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Curriculum *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _curriculumError!,
                  style: const TextStyle(color: Colors.orange),
                ),
                TextButton(
                  onPressed: _fetchCurriculumOptions,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_curriculumOptions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Curriculum *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('No curriculum data available.'),
          ),
        ],
      );
    }

    return _buildDropdownField(
      label: 'Curriculum',
      value: _selectedCurriculum,
      options: _curriculumOptions,
      onChanged: (value) {
        setState(() {
          _selectedCurriculum = value;
          _selectedBatch = null;
          _selectedFeeSchemeType = null;
          _feeSchemeTypes = [];
        });
        // Fetch batches when curriculum changes
        _fetchBatchOptions(value);
      },
      isRequired: true,
    );
  }

  Widget _buildBatchField() {
    if (_selectedCurriculum == null || _selectedCurriculum!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Please select a curriculum first.'),
          ),
        ],
      );
    }

    if (_isBatchLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Batch *',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_batchError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _batchError!,
                  style: const TextStyle(color: Colors.orange),
                ),
                TextButton(
                  onPressed: () => _fetchBatchOptions(_selectedCurriculum),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_batchOptions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('No batch data available.'),
          ),
        ],
      );
    }

    return _buildDropdownField(
      label: 'Batch',
      value: _selectedBatch,
      options: _batchOptions,
      onChanged: (value) {
        setState(() {
          _selectedBatch = value;
          _selectedFeeSchemeType = null;
          _feeSchemeTypes = [];
        });
        // Fetch fee scheme types when batch is selected
        if (value != null && _selectedCurriculum != null) {
          _fetchFeeSchemeTypes();
        }
      },
      isRequired: true,
    );
  }

  Widget _buildFeeSchemeRadioGroup() {
    if (_selectedCurriculum == null || _selectedBatch == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fee Scheme Type *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Please select Curriculum and Batch first.'),
          ),
        ],
      );
    }

    if (_isFeeSchemeLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Fee Scheme Type *',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_feeSchemeError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fee Scheme Type *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _feeSchemeError!,
                  style: const TextStyle(color: Colors.orange),
                ),
                TextButton(
                  onPressed: _fetchFeeSchemeTypes,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_feeSchemeTypes.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fee Scheme Type *',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('No fee scheme types available.'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fee Scheme Type *',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ..._feeSchemeTypes.map((scheme) {
          return RadioListTile<String>(
            title: Text(scheme),
            value: scheme,
            groupValue: _selectedFeeSchemeType,
            onChanged: (value) {
              setState(() {
                _selectedFeeSchemeType = value;
              });
            },
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActionButtons() {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isGeneratingReport ? null : _viewStudentBill,
            icon: _isGeneratingReport
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.receipt_long, color: Colors.white),
            label: const Text(
              'Student Bill',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isGeneratingReport ? null : _viewAccountDetail,
            icon: _isGeneratingReport
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.account_balance_wallet, color: Colors.white),
            label: const Text(
              'Account Detail',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.model.user?.getUserType == Core.STUDENT_USER;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Bill Print Report'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewStudentBill,
        child: const Icon(Icons.arrow_circle_right),
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
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
                    if (isStudent)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Chip(
                          label: Text(
                            'Student Access',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                      ),
                    if (isStudent) const SizedBox(height: 16),
                    _buildReadOnlyField(
                      label: 'Student Name',
                      controller: _studentNameController,
                      hint: 'John Doe',
                    ),
                    const SizedBox(height: 20),
                    _buildReadOnlyField(
                      label: 'Roll No',
                      controller: _rollNoController,
                      hint: '7969949',
                    ),
                    const SizedBox(height: 20),
                    _buildReadOnlyField(
                      label: 'Registration No / School No',
                      controller: _registrationNoController,
                      hint: 'REG2025-12345',
                    ),
                    const SizedBox(height: 20),
                    _buildCurriculumField(),
                    const SizedBox(height: 20),
                    _buildBatchField(),
                    const SizedBox(height: 20),
                    _buildFeeSchemeRadioGroup(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
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

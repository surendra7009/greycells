class SalarySlipReport {
  final bool isSuccess;
  final String? message;
  final String? reportName;
  final String? reportUrl;
  final String? reportPath;
  final Map<String, dynamic> raw;

  const SalarySlipReport({
    required this.isSuccess,
    this.message,
    this.reportName,
    this.reportUrl,
    this.reportPath,
    this.raw = const <String, dynamic>{},
  });

  factory SalarySlipReport.fromJson(Map<String, dynamic> json) {
    return SalarySlipReport(
      isSuccess: json['isSuccess'] == true,
      message: _stringValue(json['message']) ??
          _stringValue(json['responseMessage']) ??
          _stringValue(json['msg']),
      reportName: _stringValue(json['reportName']) ??
          _stringValue(json['fileName']) ??
          _stringValue(json['reportTitle']),
      reportUrl: _stringValue(json['reportUrl']) ??
          _stringValue(json['printFileUrl']) ??
          _stringValue(json['pdfPath']),
      reportPath: _stringValue(json['reportPath']) ??
          _stringValue(json['printFilePath']) ??
          _stringValue(json['pdfFilePath']),
      raw: json,
    );
  }

  factory SalarySlipReport.failure({String? message}) {
    return SalarySlipReport(
      isSuccess: false,
      message: message,
    );
  }

  bool get hasDownloadLink =>
      (reportUrl != null && reportUrl!.isNotEmpty) ||
      (reportPath != null && reportPath!.isNotEmpty) ||
      _stringValue(raw['downloadUrl'])?.isNotEmpty == true ||
      _stringValue(raw['fileUrl'])?.isNotEmpty == true;

  String? resolveReportUrl({
    String? primaryHost,
    String? reportsBaseUrl,
  }) {
    final candidates = <String?>[
      reportUrl,
      reportPath,
      _stringValue(raw['downloadUrl']),
      _stringValue(raw['fileUrl']),
      _stringValue(raw['reportFile']),
    ];

    for (final candidate in candidates) {
      if (candidate == null || candidate.isEmpty) {
        continue;
      }
      if (candidate.startsWith('http://') || candidate.startsWith('https://')) {
        return candidate;
      }
      final normalized = _normalizePath(candidate);
      final hosts = <String?>[
        primaryHost,
        reportsBaseUrl,
      ];
      for (final host in hosts) {
        if (host != null && host.isNotEmpty) {
          return _joinUrl(host, normalized);
        }
      }
      return normalized;
    }
    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.trim().isEmpty ? null : value.trim();
    return value.toString();
  }

  static String _normalizePath(String path) {
    if (path.isEmpty) return path;
    return path.startsWith('/') ? path : '/$path';
  }

  static String _joinUrl(String base, String path) {
    final buffer = StringBuffer();
    if (base.endsWith('/')) {
      buffer.write(base.substring(0, base.length - 1));
    } else {
      buffer.write(base);
    }
    buffer.write(path);
    return buffer.toString();
  }
}

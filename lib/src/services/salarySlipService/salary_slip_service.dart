import 'dart:convert';

import 'package:greycell_app/src/commons/widgets/query_params.dart';
import 'package:greycell_app/src/config/apiauth_config.dart';
import 'package:greycell_app/src/manager/data_manager.dart';
import 'package:greycell_app/src/models/salarySlip/salary_slip_report.dart';
import 'package:http/http.dart' as http;

mixin SalarySlipService on DataManager {
  Map<String, String> get _headers => {"Content-Type": "application/json"};

  Future<SalarySlipReport?> getSalarySlipReport({
    required String staffCode,
    required String yearMonth,
    required String loginUserId,
    String? staffId,
    String? toYearMonthLabel,
    bool includeLoanDetails = false,
  }) async {
    if (school?.schoolFirstServerAddress == null) {
      return SalarySlipReport.failure(
        message: "School server is not configured. Please try again later.",
      );
    }

    try {
      final String tokenUrl =
          "${school!.schoolFirstServerAddress}${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.SALARY_SLIP_PRINT_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return SalarySlipReport.failure(
          message: "Unable to fetch authorization token.",
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.SALARY_SLIP_PRINT_CALLBACKS);
      queryParams.append("apiCode", ApiAuth.SALARY_SLIP_PRINT_API_CODE);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("txtStaffCode", staffCode);
      queryParams.append("hdnStaffId", staffId);
      queryParams.append("txtYearMonth", yearMonth);
      queryParams.append("txtToYearMonth", toYearMonthLabel ?? yearMonth);
      queryParams.append("chkPrintLoanAmount", includeLoanDetails ? "Y" : "N");
      queryParams.append(
          "accessToken", tokenResponse['accessToken'].toString());

      final String reportUrl =
          "${school!.schoolFirstServerAddress}${RestAPIs.SALARY_SLIP_REPORT_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(reportUrl), headers: _headers);

      if (response.statusCode != 200) {
        return SalarySlipReport.failure(
          message: "Unable to fetch salary slip. Please try again.",
        );
      }

      final String jsonPayload = await dataFilter.toJsonResponse(
        callback: ApiAuth.SALARY_SLIP_PRINT_CALLBACKS,
        response: response.body,
      );
      final dynamic parsed = json.decode(jsonPayload);
      if (parsed is Map<String, dynamic>) {
        return SalarySlipReport.fromJson(parsed);
      }

      return SalarySlipReport.failure(
        message: "Unexpected response received from server.",
      );
    } catch (error) {
      print("SalarySlipService error: $error");
      return SalarySlipReport.failure(
        message: "Something went wrong while fetching the salary slip.",
      );
    }
  }
}

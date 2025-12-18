import 'dart:convert';
import 'dart:developer';

import 'package:greycell_app/src/config/apiauth_config.dart';
import 'package:greycell_app/src/manager/data_manager.dart';
import 'package:greycell_app/src/models/courseModel/time_table_model.dart';
import 'package:greycell_app/src/models/response/failure.dart';
import 'package:greycell_app/src/models/response/response.dart';
import 'package:greycell_app/src/models/response/success.dart';
import 'package:http/http.dart' as http;
import 'package:greycell_app/src/commons/widgets/query_params.dart';
import 'package:intl/intl.dart';

mixin CourseService on DataManager {
  Map<String, String> get getHeader => {"Content-Type": "application/json"};

  Future<List<Map<String, String>>> fetchCourseVectorCurriculum() async {
    final List<Map<String, String>> curriculumOptions = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.COURSE_VECTOR_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception(responseTokenErrorMessage);
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.COURSE_VECTOR_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.COURSE_VECTOR_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl = "$baseUrl${RestAPIs.COURSE_VECTOR_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch curriculum details.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.COURSE_VECTOR_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getCourseVec'] ?? [];

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length > 1) {
          final dynamic rawValue = entry[0];
          final dynamic rawTitle = entry[1];
          final String value =
              rawValue == null ? '' : rawValue.toString().trim();
          final String title =
              rawTitle == null ? '' : rawTitle.toString().trim();
          if (value.isNotEmpty && title.isNotEmpty) {
            curriculumOptions.add({'value': value, 'title': title});
          }
        }
      }
    } catch (error, stackTrace) {
      log(
        'fetchCourseVectorCurriculum error: $error',
        stackTrace: stackTrace,
        name: 'CourseService',
      );
      rethrow;
    }
    return curriculumOptions;
  }

  Future<List<Map<String, String>>> fetchBatchVectorOnCourse(
      {required String courseId}) async {
    final List<Map<String, String>> batchOptions = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      if (courseId.isEmpty) {
        throw Exception('Course ID is required to fetch batches.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.BATCH_VECTOR_ON_COURSE_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception(responseTokenErrorMessage);
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.BATCH_VECTOR_ON_COURSE_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("cmbCourseId", courseId);
      queryParams.append("apiCode", ApiAuth.BATCH_VECTOR_ON_COURSE_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.BATCH_VECTOR_ON_COURSE_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch batch details.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.BATCH_VECTOR_ON_COURSE_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getBatchVec'] ?? [];

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length > 1) {
          final dynamic rawValue = entry[0];
          final dynamic rawTitle = entry[1];
          final String value =
              rawValue == null ? '' : rawValue.toString().trim();
          final String title =
              rawTitle == null ? '' : rawTitle.toString().trim();
          if (value.isNotEmpty && title.isNotEmpty) {
            batchOptions.add({'value': value, 'title': title});
          }
        }
      }
    } catch (error, stackTrace) {
      log(
        'fetchBatchVectorOnCourse error: $error',
        stackTrace: stackTrace,
        name: 'CourseService',
      );
      rethrow;
    }
    return batchOptions;
  }

  Future<Map<String, dynamic>> fetchStudentBillDetails() async {
    final Map<String, dynamic> billDetails = {
      'feeSchemeTypes': <String>[],
      'feeSchemeTypeMap': <String, Map<String, String>>{},
      'studentId': '',
    };
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.BILL_STUDENT_DETAILS_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception(responseTokenErrorMessage);
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.BILL_STUDENT_DETAILS_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.BILL_STUDENT_DETAILS_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.BILL_STUDENT_DETAILS_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch student bill details.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.BILL_STUDENT_DETAILS_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getFeeSchTypeVec'] ?? [];
      final List<String> feeSchemeTypes = [];
      final Map<String, Map<String, String>> feeSchemeTypeMap = {};

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length > 1) {
          final dynamic rawId = entry[0];
          final dynamic rawTitle = entry[1];
          final String id = rawId == null ? '' : rawId.toString().trim();
          final String title =
              rawTitle == null ? '' : rawTitle.toString().trim();
          if (id.isNotEmpty && title.isNotEmpty) {
            feeSchemeTypes.add(title);
            feeSchemeTypeMap[title] = {'id': id, 'name': title};
          }
        }
      }

      billDetails['feeSchemeTypes'] = feeSchemeTypes;
      billDetails['feeSchemeTypeMap'] = feeSchemeTypeMap;
      billDetails['studentId'] = content['getStudentId']?.toString() ?? '';
    } catch (error, stackTrace) {
      log(
        'fetchStudentBillDetails error: $error',
        stackTrace: stackTrace,
        name: 'CourseService',
      );
      rethrow;
    }
    return billDetails;
  }

  Future<List<String>> fetchStudentBillFeeSchemeTypes() async {
    final billDetails = await fetchStudentBillDetails();
    return List<String>.from(billDetails['feeSchemeTypes'] ?? []);
  }

  Future<String> fetchStudentBillPrint({
    required String courseId,
    required String batchId,
    required String feeSchemeTypeId,
    required String feeSchemeTypeName,
    required String studentId,
    String buttonName = 'P', // P for PDF, X for Excel
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.MY_STUDENT_BILL_PRINT_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception(responseTokenErrorMessage);
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.MY_STUDENT_BILL_PRINT_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("cmbCourseId", courseId);
      queryParams.append("cmbBatchId", batchId);
      queryParams.append("cmbFeeSchemeTypeId", feeSchemeTypeId);
      queryParams.append("cmbFeeSchemeTypeName", feeSchemeTypeName);
      queryParams.append("hdnStudentId", studentId);
      queryParams.append("buttonName", buttonName);
      queryParams.append("apiCode", ApiAuth.MY_STUDENT_BILL_PRINT_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.MY_STUDENT_BILL_PRINT_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch student bill print.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.MY_STUDENT_BILL_PRINT_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final String reportFilePath = content['getReportFilePath']?.toString() ?? '';

      if (reportFilePath.isEmpty) {
        throw Exception('Report file path not found in response.');
      }

      return reportFilePath;
    } catch (error, stackTrace) {
      log(
        'fetchStudentBillPrint error: $error',
        stackTrace: stackTrace,
        name: 'CourseService',
      );
      rethrow;
    }
  }

  Future<String> fetchStudentBillAccountPrint({
    required String courseId,
    required String batchId,
    required String feeSchemeTypeId,
    required String feeSchemeTypeName,
    required String studentId,
    String buttonName = 'P', // P for PDF, X for Excel
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.MY_STUDENT_BILL_ACCOUNT_PRINT_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception(responseTokenErrorMessage);
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.MY_STUDENT_BILL_ACCOUNT_PRINT_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("cmbCourseId", courseId);
      queryParams.append("cmbBatchId", batchId);
      queryParams.append("cmbFeeSchemeTypeId", feeSchemeTypeId);
      queryParams.append("cmbFeeSchemeTypeName", feeSchemeTypeName);
      queryParams.append("hdnStudentId", studentId);
      queryParams.append("buttonName", buttonName);
      queryParams.append("apiCode", ApiAuth.MY_STUDENT_BILL_ACCOUNT_PRINT_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.MY_STUDENT_BILL_ACCOUNT_PRINT_URL}?$queryParams";
      print(requestUrl);
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);
      print(response.body);
      if (response.statusCode != 200) {
        throw Exception('Unable to fetch student bill account print.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.MY_STUDENT_BILL_ACCOUNT_PRINT_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final String reportFilePath = content['getReportFilePath']?.toString() ?? '';

      if (reportFilePath.isEmpty) {
        throw Exception('Report file path not found in response.');
      }

      return reportFilePath;
    } catch (error, stackTrace) {
      log(
        'fetchStudentBillAccountPrint error: $error',
        stackTrace: stackTrace,
        name: 'CourseService',
      );
      rethrow;
    }
  }

  Future<ResponseMania> getCourseDetails({required DateTime date}) async {
    Success _success;
    try {
      String tokenUrl =
          "${school?.schoolFirstServerAddress}${RestAPIs.TOKEN_URL}";
      final response = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.STDN_TIMETABLE_DTLS /*  ApiAuth.COURSE_API_CODE */,
      );
      if (response != null) {
        final URLQueryParams queryParams = URLQueryParams();
        queryParams.append(
            "callback", "stdnTimeTableDtlCall" /* ApiAuth.COURSE_CALLBACKS */);
        queryParams.append(
            "apiCode", "STDN_TIMETABLE_DTLS" /* ApiAuth.COURSE_API_CODE */);
        queryParams.append("loginUserId", user!.getUserId);
        queryParams.append(
            "txtTimeTableDate", DateFormat("dd-MMM-yyyy").format(date));
        queryParams.append("accessToken", response['accessToken'].toString());

        final String dueUrl =
            "${school?.schoolFirstServerAddress}${RestAPIs.APIStudTimeTableDtl}?$queryParams";
        // final String dueUrl =
        //     "${school?.schoolFirstServerAddress}${RestAPIs.COURSE_URL}?$queryParams";
        print(dueUrl);
        http.Response _response =
            await http.get(Uri.parse(dueUrl), headers: getHeader);

        if (_response.statusCode == 200) {
          log(_response.body);
          RegExp regExp = RegExp(r'{[\s\S]*}');

          // Extract the first match
          var match = regExp.firstMatch(_response.body);

          // final jsonResponse = await dataFilter.toJsonResponse(
          //     callback: ApiAuth.COURSE_CALLBACKS, response: _response.body);

          // final Map<String, dynamic> content = json.decode(jsonResponse);
          // print(content);
          TimeTableModel tableModel =
              TimeTableModel.fromJson(json.decode(match!.group(0)!));
          if (tableModel.isSuccess ?? false) {
            // Data Exist
            _success = Success(success: tableModel);
          } else if (!tableModel.isSuccess!) {
            // No Data
            print("No Data");
            return Failure(
                responseStatus: ResponseManiaStatus.FAILED,
                responseMessage: responseFailedMessage);
          } else {
            // Error In response
            return Failure(
                responseStatus: ResponseManiaStatus.FAILED,
                responseMessage: responseFailedMessage);
          }
        } else {
          print('Status Code: ${_response.statusCode}');
          return Failure(
              responseStatus: ResponseManiaStatus.ERROR,
              responseMessage: 'Not Found');
        }
      } else {
        return Failure(
            responseStatus: ResponseManiaStatus.ERROR,
            responseMessage: responseTokenErrorMessage);
      }
    } catch (e) {
      print('Errro In Catch: $e');
      return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: internalMessage);
    }
    notifyListeners();
    return _success;
  }
}

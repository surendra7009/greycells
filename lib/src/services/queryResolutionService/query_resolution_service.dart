import 'dart:convert';
import 'dart:developer';

import 'package:greycell_app/src/config/apiauth_config.dart';
import 'package:greycell_app/src/manager/data_manager.dart';
import 'package:greycell_app/src/models/response/failure.dart';
import 'package:greycell_app/src/models/response/response.dart';
import 'package:greycell_app/src/models/response/success.dart';
import 'package:http/http.dart' as http;
import 'package:greycell_app/src/commons/widgets/query_params.dart';

mixin QueryResolutionService on DataManager {
  Map<String, String> get getHeader => {"Content-Type": "application/json"};

  // Get Query Nature Vector
  Future<List<Map<String, String>>> getQueryNatureVector() async {
    final List<Map<String, String>> natureList = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.QUERY_NATURE_VECTOR_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.QUERY_NATURE_VECTOR_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.QUERY_NATURE_VECTOR_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_NATURE_VECTOR_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch query nature list.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_NATURE_VECTOR_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getQueryNatureVector'] ?? [];

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length >= 2) {
          final String id = entry[0]?.toString() ?? '';
          final String name = entry[1]?.toString() ?? '';
          if (id.isNotEmpty && name.isNotEmpty) {
            natureList.add({'id': id, 'name': name});
          }
        }
      }
    } catch (error, stackTrace) {
      log(
        'getQueryNatureVector error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return natureList;
  }

  // Get Query Status Vector
  Future<List<Map<String, String>>> getQueryStatusVector() async {
    final List<Map<String, String>> statusList = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.QUERY_STATUS_VECTOR_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.QUERY_STATUS_VECTOR_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.QUERY_STATUS_VECTOR_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_STATUS_VECTOR_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch query status list.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_STATUS_VECTOR_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getQueryStatusVector'] ?? [];

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length >= 2) {
          final String id = entry[0]?.toString() ?? '';
          final String name = entry[1]?.toString() ?? '';
          if (id.isNotEmpty && name.isNotEmpty) {
            statusList.add({'id': id, 'name': name});
          }
        }
      }
    } catch (error, stackTrace) {
      log(
        'getQueryStatusVector error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return statusList;
  }

  // Get Query Priority Helpdesk Vector
  Future<List<Map<String, String>>> getQueryPriorityHelpdeskVector() async {
    final List<Map<String, String>> priorityList = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.QUERY_PRIORITY_HELPDESK_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.QUERY_PRIORITY_HELPDESK_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.QUERY_PRIORITY_HELPDESK_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_PRIORITY_HELPDESK_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch query priority list.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_PRIORITY_HELPDESK_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getQueryPriorityVector'] ?? [];

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length >= 2) {
          final String id = entry[0]?.toString() ?? '';
          final String name = entry[1]?.toString() ?? '';
          if (id.isNotEmpty && name.isNotEmpty) {
            priorityList.add({'id': id, 'name': name});
          }
        }
      }
    } catch (error, stackTrace) {
      log(
        'getQueryPriorityHelpdeskVector error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return priorityList;
  }

  // Get Category Helpdesk Vector
  Future<List<Map<String, String>>> getCategoryHelpdeskVector() async {
    final List<Map<String, String>> categoryList = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.CATEGORY_HELPDESK_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.CATEGORY_HELPDESK_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.CATEGORY_HELPDESK_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.CATEGORY_HELPDESK_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch category list.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.CATEGORY_HELPDESK_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getCategoryVector'] ?? [];

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length >= 2) {
          final String id = entry[0]?.toString() ?? '';
          final String name = entry[1]?.toString() ?? '';
          if (id.isNotEmpty && name.isNotEmpty) {
            categoryList.add({'id': id, 'name': name});
          }
        }
      }
    } catch (error, stackTrace) {
      log(
        'getCategoryHelpdeskVector error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return categoryList;
  }

  // Get Initiate Query List
  Future<List<Map<String, dynamic>>> getInitiateQueryList({
    required String fromDate,
    required String toDate,
    String? queryNatureId,
    String? categoryId,
  }) async {
    final List<Map<String, dynamic>> queryList = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.INITIATE_QUERY_LIST_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.INITIATE_QUERY_LIST_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("txtFromDate", fromDate);
      queryParams.append("txtToDate", toDate);
      if (queryNatureId != null && queryNatureId.isNotEmpty) {
        queryParams.append("cmbQueryNatureId", queryNatureId);
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams.append("cmbCategoryId", categoryId);
      }
      queryParams.append("apiCode", ApiAuth.INITIATE_QUERY_LIST_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.INITIATE_QUERY_LIST_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch query list.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.INITIATE_QUERY_LIST_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> rawList = content['getInitiateQueryList'] ?? [];

      for (final dynamic entry in rawList) {
        if (entry is List && entry.length >= 6) {
          queryList.add({
            'id': entry[0]?.toString() ?? '',
            'referenceNo': entry[1]?.toString() ?? '',
            'subject': entry[2]?.toString() ?? '',
            'status': entry[3]?.toString() ?? '',
            'categoryId': entry[4]?.toString() ?? '',
            'initiatedBy': entry[5]?.toString() ?? '',
            'assignedTo': entry.length > 6 ? (entry[6]?.toString() ?? '') : '',
          });
        }
      }
    } catch (error, stackTrace) {
      log(
        'getInitiateQueryList error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return queryList;
  }

  // Get Initiate Query Details
  Future<Map<String, dynamic>> getInitiateQueryDetails({
    required String queryId,
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
        apiCode: ApiAuth.INITIATE_QUERY_DETAILS_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.INITIATE_QUERY_DETAILS_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("hdnInitiateQueryId", queryId);
      queryParams.append("apiCode", ApiAuth.INITIATE_QUERY_DETAILS_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.INITIATE_QUERY_DETAILS_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch query details.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.INITIATE_QUERY_DETAILS_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      
      final List<dynamic> remarkVector = content['getRemarkVector'] ?? [];
      final List<Map<String, dynamic>> remarks = [];
      
      for (final dynamic remark in remarkVector) {
        if (remark is List && remark.length >= 5) {
          remarks.add({
            'id': remark[0]?.toString() ?? '',
            'userId': remark[1]?.toString() ?? '',
            'userName': remark[2]?.toString() ?? '',
            'dateTime': remark[3]?.toString() ?? '',
            'remark': remark[4]?.toString() ?? '',
            'statusId': remark.length > 5 ? (remark[5]?.toString() ?? '') : '',
          });
        }
      }

      return {
        'query': content['getQuery']?.toString() ?? '',
        'subject': content['getSubject']?.toString() ?? '',
        'assignTo': content['getAssignTo']?.toString() ?? '',
        'referenceNo': content['getReferenceNo']?.toString() ?? '',
        'remainingDays': content['getRemainingDays']?.toString() ?? '',
        'currentStatus': content['getCurrentStatus']?.toString() ?? '',
        'queryNature': content['getQueryNature']?.toString() ?? '',
        'currentStatusId': content['getCurrentStatusId']?.toString() ?? '',
        'category': content['getCategory']?.toString() ?? '',
        'initiateQueryId': content['getInitiateQueryId']?.toString() ?? '',
        'remarks': remarks,
      };
    } catch (error, stackTrace) {
      log(
        'getInitiateQueryDetails error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
  }

  // Add Initiate Query
  Future<ResponseMania> addInitiateQuery({
    String? queryId,
    required String currentStatus,
    required String subject,
    required String category,
    required String queryNature,
    String? assignTo,
    required String query,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.INITIATE_QUERY_ADD_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.INITIATE_QUERY_ADD_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      if (queryId != null && queryId.isNotEmpty) {
        queryParams.append("hdnInitiateQueryId", queryId);
      }
      queryParams.append("cmbCurrentStatus", currentStatus);
      queryParams.append("txtSubject", subject);
      queryParams.append("cmbCategory", category);
      queryParams.append("cmbQueryNature", queryNature);
      if (assignTo != null && assignTo.isNotEmpty) {
        queryParams.append("txtAssignTo", assignTo);
      }
      queryParams.append("txtareaQuery", query);
      queryParams.append("apiCode", ApiAuth.INITIATE_QUERY_ADD_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.INITIATE_QUERY_ADD_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to add query.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.INITIATE_QUERY_ADD_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      
      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage: content['message']?.toString() ?? 'Failed to add query.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'addInitiateQuery error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }

  // Update Initiate Query
  Future<ResponseMania> updateInitiateQuery({
    required String queryId,
    required String currentStatus,
    required String currentStatusName,
    required String subject,
    required String category,
    required String queryNature,
    String? assignTo,
    required String query,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }
  
      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.INITIATE_QUERY_UPDATE_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.INITIATE_QUERY_UPDATE_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("hdnInitiateQueryId", queryId);
      queryParams.append("cmbCurrentStatus", currentStatus);
      queryParams.append("currentStatusName", currentStatusName);
      queryParams.append("txtSubject", subject);
      queryParams.append("cmbCategory", category);
      queryParams.append("cmbQueryNature", queryNature);
      if (assignTo != null && assignTo.isNotEmpty) {
        queryParams.append("txtAssignTo", assignTo);
      }
      queryParams.append("txtareaQuery", query);
      queryParams.append("apiCode", ApiAuth.INITIATE_QUERY_UPDATE_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.INITIATE_QUERY_UPDATE_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to update query.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.INITIATE_QUERY_UPDATE_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      
      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage: content['message']?.toString() ?? 'Failed to update query.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'updateInitiateQuery error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }

  // Add Initiate Query Remarks
  Future<ResponseMania> addInitiateQueryRemarks({
    required String queryId,
    required String remark,
    required String currentStatus,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.INITIATE_QUERY_REMARKS_ADD_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.INITIATE_QUERY_REMARKS_ADD_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("hdnInitiateQueryId", queryId);
      queryParams.append("textareaRemark", remark);
      queryParams.append("cmbCurrentStatus", currentStatus);
      queryParams.append("apiCode", ApiAuth.INITIATE_QUERY_REMARKS_ADD_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.INITIATE_QUERY_REMARKS_ADD_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to add remarks.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.INITIATE_QUERY_REMARKS_ADD_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      
      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage: content['message']?.toString() ?? 'Failed to add remarks.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'addInitiateQueryRemarks error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }

  // Get Initiate Query Remarks List
  Future<List<Map<String, dynamic>>> getInitiateQueryRemarksList({
    required String queryId,
    String? currentStatus,
  }) async {
    final List<Map<String, dynamic>> remarksList = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.INITIATE_QUERY_REMARKS_LIST_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.INITIATE_QUERY_REMARKS_LIST_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("hdnInitiateQueryId", queryId);
      if (currentStatus != null && currentStatus.isNotEmpty) {
        queryParams.append("cmbCurrentStatus", currentStatus);
      }
      queryParams.append("apiCode", ApiAuth.INITIATE_QUERY_REMARKS_LIST_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);

      final String requestUrl =
          "$baseUrl${RestAPIs.INITIATE_QUERY_REMARKS_LIST_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch remarks list.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.INITIATE_QUERY_REMARKS_LIST_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> remarkVector = content['getRemarkVector'] ?? [];

      for (final dynamic remark in remarkVector) {
        if (remark is List && remark.length >= 5) {
          remarksList.add({
            'id': remark[0]?.toString() ?? '',
            'userId': remark[1]?.toString() ?? '',
            'userName': remark[2]?.toString() ?? '',
            'dateTime': remark[3]?.toString() ?? '',
            'remark': remark[4]?.toString() ?? '',
            'statusId': remark.length > 5 ? (remark[5]?.toString() ?? '') : '',
          });
        }
      }
    } catch (error, stackTrace) {
      log(
        'getInitiateQueryRemarksList error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return remarksList;
  }

  // ==================== QUERY RESOLUTION & ASSIGN FLOWS ====================

  /// Get Query Resolution list (assigned queries) – mirrors
  /// `APIGetAssignedToAction` / `QueryResolutionListLoadAction` collection.
  ///
  /// This returns a raw list of map rows so that the UI can decide
  /// how to render / filter them.
  Future<List<Map<String, dynamic>>> getQueryResolutionList({
    required String fromDate,
    required String toDate,
    String? queryNatureId,
    String? categoryId,
    String? priorityId,
  }) async {
    final List<Map<String, dynamic>> list = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      // Token for QueryResolutionListLoadAction
      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.QUERY_RESOLUTION_LIST_LOAD_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append(
        "callback",
        ApiAuth.QUERY_RESOLUTION_LIST_LOAD_CALLBACKS,
      );
      queryParams.append("loginUserId", loginUserId);
      queryParams.append(
        "apiCode",
        ApiAuth.QUERY_RESOLUTION_LIST_LOAD_API_CODE,
      );
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("cmbQueryNature", queryNatureId);
      queryParams.append("cmbQueryCategory", categoryId);
      queryParams.append("cmbQueryPriority", priorityId);
      queryParams.append("txtFromDate", fromDate);
      queryParams.append("txtToDate", toDate);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_RESOLUTION_LIST_LOAD_URL}?$queryParams";
    print("Request URL: $requestUrl");
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch query resolution list.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_RESOLUTION_LIST_LOAD_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);

      // The API returns data in 'getQueryListVector' key
      // Response structure: [id, referenceNo, subject, query, date, statusId, status, natureId, categoryId, priorityId, assignedToId, assignedToName, initiatedBy]
      final List<dynamic> rawList =
          (content['getQueryListVector'] as List<dynamic>?) ??
              (content['getQueryResolutionList'] as List<dynamic>?) ??
              (content['getAssignedToList'] as List<dynamic>?) ??
              (content['rows'] as List<dynamic>?) ??
              [];

      for (final dynamic row in rawList) {
        if (row is Map<String, dynamic>) {
          list.add(row);
        } else if (row is List) {
          // Map the array structure: [id, referenceNo, subject, query, date, statusId, status, natureId, natureName, categoryId, categoryName, priorityName, assignedToName, assignedToId]
          list.add({
            'id': row.isNotEmpty ? row[0]?.toString() ?? '' : '',
            'referenceNo': row.length > 1 ? row[1]?.toString() ?? '' : '',
            'subject': row.length > 2 ? row[2]?.toString() ?? '' : '',
            'query': row.length > 3 ? row[3]?.toString() ?? '' : '',
            'date': row.length > 4 ? row[4]?.toString() ?? '' : '',
            'statusId': row.length > 5 ? row[5]?.toString() ?? '' : '',
            'status': row.length > 6 ? row[6]?.toString() ?? '' : '',
            'natureId': row.length > 7 ? row[7]?.toString() ?? '' : '',
            'natureName': row.length > 8 ? row[8]?.toString() ?? '' : '',
            'categoryId': row.length > 9 ? row[9]?.toString() ?? '' : '',
            'categoryName': row.length > 10 ? row[10]?.toString() ?? '' : '',
            'priorityName': row.length > 11 ? row[11]?.toString() ?? '' : '',
            'assignedToName': row.length > 12 ? row[12]?.toString() ?? '' : '',
            'assignedToId': row.length > 13 ? row[13]?.toString() ?? '' : '',
            'assignedTo': row.length > 12 ? row[12]?.toString() ?? '' : '', // For backward compatibility
          });
        }
      }
    } catch (error, stackTrace) {
      log(
        'getQueryResolutionList error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return list;
  }

  /// Get Query Resolution details – mirrors `APIGetQueryDetailsLoadAction`.
  /// Returns a raw map with commonly used fields plus a `remarks` list.
  Future<Map<String, dynamic>> getQueryResolutionDetails({
    required String queryResolutionId,
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
        apiCode: ApiAuth.QUERY_DETAILS_LOAD_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append(
        "callback",
        ApiAuth.QUERY_DETAILS_LOAD_CALLBACKS,
      );
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.QUERY_DETAILS_LOAD_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("hdnQueryResolutionId", queryResolutionId);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_DETAILS_LOAD_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch query resolution details.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_DETAILS_LOAD_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);

      // Check if response is in array format (like list API) or object format
      // Array format: content['getQueryListVector'] or similar
      // Object format: content['getQuery'], content['getSubject'], etc.
      
      Map<String, dynamic> detailsMap = {};
      
      // Try array format first (similar to list API structure)
      final List<dynamic>? queryVector = content['getQueryListVector'] as List<dynamic>?;
      if (queryVector != null && queryVector.isNotEmpty && queryVector[0] is List) {
        // Array format: [id, referenceNo, subject, query, date, statusId, status, natureId, natureName, categoryId, categoryName, priorityName, assignedToName, assignedToId]
        final row = queryVector[0] as List;
        detailsMap = {
          'id': row.isNotEmpty ? row[0]?.toString() ?? '' : '',
          'referenceNo': row.length > 1 ? row[1]?.toString() ?? '' : '',
          'subject': row.length > 2 ? row[2]?.toString() ?? '' : '',
          'query': row.length > 3 ? row[3]?.toString() ?? '' : '',
          'date': row.length > 4 ? row[4]?.toString() ?? '' : '',
          'statusId': row.length > 5 ? row[5]?.toString() ?? '' : '',
          'currentStatus': row.length > 6 ? row[6]?.toString() ?? '' : '',
          'natureId': row.length > 7 ? row[7]?.toString() ?? '' : '',
          'queryNature': row.length > 8 ? row[8]?.toString() ?? '' : '',
          'categoryId': row.length > 9 ? row[9]?.toString() ?? '' : '',
          'category': row.length > 10 ? row[10]?.toString() ?? '' : '',
          'priorityText': row.length > 11 ? row[11]?.toString() ?? '' : '',
          'assignedTo': row.length > 12 ? row[12]?.toString() ?? '' : '',
          'assignedToId': row.length > 13 ? row[13]?.toString() ?? '' : '',
        };
      } else {
        // Object format: individual fields
        detailsMap = {
          'query': content['getQuery']?.toString() ?? '',
          'subject': content['getSubject']?.toString() ?? '',
          'assignTo': content['getAssignTo']?.toString() ?? '',
          'referenceNo': content['getReferenceNo']?.toString() ?? '',
          'remainingDays': content['getRemainingDays']?.toString() ?? '',
          'currentStatus': content['getCurrentStatus']?.toString() ?? '',
          'queryNature': content['getQueryNature']?.toString() ?? '',
          'currentStatusId': content['getCurrentStatusId']?.toString() ?? '',
          'category': content['getCategory']?.toString() ?? '',
          'categoryId': content['getCategoryId']?.toString() ?? '',
          'natureId': content['getNatureId']?.toString() ?? '',
          'queryResolutionId': content['getQueryResolutionId']?.toString() ?? '',
          'priorityText': content['getPriorityText']?.toString() ?? '',
          'priorityId': content['getPriorityId']?.toString() ?? '',
        };
      }

      final List<dynamic> remarkVector =
          (content['getRemarkVector'] as List<dynamic>?) ?? [];
      final List<Map<String, dynamic>> remarks = [];

      for (final dynamic remark in remarkVector) {
        if (remark is List && remark.length >= 5) {
          remarks.add({
            'id': remark[0]?.toString() ?? '',
            'userId': remark[1]?.toString() ?? '',
            'userName': remark[2]?.toString() ?? '',
            'dateTime': remark[3]?.toString() ?? '',
            'remark': remark[4]?.toString() ?? '',
            'statusId': remark.length > 5 ? (remark[5]?.toString() ?? '') : '',
          });
        }
      }

      return {
        ...detailsMap,
        'remarks': remarks,
      };
    } catch (error, stackTrace) {
      log(
        'getQueryResolutionDetails error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
  }

  /// Save / update Query Resolution – mirrors `APIQueryResolutionSaveUpdateAction`.
  Future<ResponseMania> saveOrUpdateQueryResolution({
    required String queryResolutionId,
    required String currentStatusId,
    required String currentStatusName,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.QUERY_RESOLUTION_SAVE_UPDATE_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append(
        "callback",
        ApiAuth.QUERY_RESOLUTION_SAVE_UPDATE_CALLBACKS,
      );
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.QUERY_RESOLUTION_SAVE_UPDATE_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("hdnQueryResolutionId", queryResolutionId);
      queryParams.append("cmbCurrentStatus", currentStatusId);
      queryParams.append("currentStatusName", currentStatusName);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_RESOLUTION_SAVE_UPDATE_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to save query resolution.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_RESOLUTION_SAVE_UPDATE_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);

      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage:
              content['message']?.toString() ?? 'Failed to save query resolution.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'saveOrUpdateQueryResolution error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }

  /// Get remarks details for a query resolution – mirrors `APIGetRemarksDetailsAction`.
  Future<List<Map<String, dynamic>>> getQueryResolutionRemarks({
    required String queryResolutionId,
  }) async {
    final List<Map<String, dynamic>> remarksList = [];
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        throw Exception('Missing school configuration or user information.');
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.REMARKS_DETAILS_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        throw Exception('Unable to get authentication token.');
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append(
        "callback",
        ApiAuth.REMARKS_DETAILS_CALLBACKS,
      );
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.REMARKS_DETAILS_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("hdnQueryResolutionId", queryResolutionId);

      final String requestUrl =
          "$baseUrl${RestAPIs.REMARKS_DETAILS_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch remarks details.');
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.REMARKS_DETAILS_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);
      final List<dynamic> remarkVector =
          (content['getRemarkVector'] as List<dynamic>?) ?? [];

      for (final dynamic remark in remarkVector) {
        if (remark is List && remark.length >= 5) {
          remarksList.add({
            'id': remark[0]?.toString() ?? '',
            'userId': remark[1]?.toString() ?? '',
            'userName': remark[2]?.toString() ?? '',
            'dateTime': remark[3]?.toString() ?? '',
            'remark': remark[4]?.toString() ?? '',
            'statusId': remark.length > 5 ? (remark[5]?.toString() ?? '') : '',
          });
        }
      }
    } catch (error, stackTrace) {
      log(
        'getQueryResolutionRemarks error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      rethrow;
    }
    return remarksList;
  }

  /// Save a remark for a query resolution – mirrors `APIGetRemarksDetailsSaveAction`.
  Future<ResponseMania> saveQueryResolutionRemark({
    required String queryResolutionId,
    required String remark,
    required String currentStatusId,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.REMARKS_DETAILS_SAVE_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append(
        "callback",
        ApiAuth.REMARKS_DETAILS_SAVE_CALLBACKS,
      );
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.REMARKS_DETAILS_SAVE_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("hdnQueryResolutionId", queryResolutionId);
      queryParams.append("textareaRemark", remark);
      queryParams.append("hdnCurrentStatusId", currentStatusId);

      final String requestUrl =
          "$baseUrl${RestAPIs.REMARKS_DETAILS_SAVE_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to save remark.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.REMARKS_DETAILS_SAVE_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);

      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage:
              content['message']?.toString() ?? 'Failed to save remark.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'saveQueryResolutionRemark error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }

  /// Assign / update assignment with priority – mirrors `APIQueryAssignSaveAction`.
  Future<ResponseMania> saveQueryAssign({
    required String queryId,
    required String remark,
    required String currentStatusId,
    required String queryNatureId,
    required String categoryId,
    required String priorityId,
    required String assignedToId,
    required String currentStatusName,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.QUERY_ASSIGN_SAVE_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append(
        "callback",
        ApiAuth.QUERY_ASSIGN_SAVE_CALLBACKS,
      );
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.QUERY_ASSIGN_SAVE_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("hdnQueryId", queryId);
      queryParams.append("textareaRemark", remark);
      queryParams.append("cmbCurrentStatus", currentStatusId);
      queryParams.append("cmbQueryNature", queryNatureId);
      queryParams.append("cmbCategory", categoryId);
      queryParams.append("cmbPriority", priorityId);
      queryParams.append("cmbAssignedTo", assignedToId);
      queryParams.append("currentStatusName", currentStatusName);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_ASSIGN_SAVE_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to save assignment.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_ASSIGN_SAVE_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);

      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage:
              content['message']?.toString() ?? 'Failed to save assignment.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'saveQueryAssign error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }

  /// Save a remark for assign flow – mirrors `APIQueryAssignRemarksSaveAction`.
  Future<ResponseMania> saveQueryAssignRemark({
    required String queryResolutionId,
    required String remark,
    required String currentStatusId,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.QUERY_ASSIGN_REMARKS_SAVE_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append(
        "callback",
        ApiAuth.QUERY_ASSIGN_REMARKS_SAVE_CALLBACKS,
      );
      queryParams.append("loginUserId", loginUserId);
      queryParams.append(
        "apiCode",
        ApiAuth.QUERY_ASSIGN_REMARKS_SAVE_API_CODE,
      );
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("hdnQueryResolutionId", queryResolutionId);
      queryParams.append("textareaRemark", remark);
      queryParams.append("hdnCurrentStatusId", currentStatusId);

      final String requestUrl =
          "$baseUrl${RestAPIs.QUERY_ASSIGN_REMARKS_SAVE_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to save assign remark.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.QUERY_ASSIGN_REMARKS_SAVE_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);

      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage: content['message']?.toString() ??
              'Failed to save assign remark.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'saveQueryAssignRemark error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }

  /// Generate Days Not Resolved Report
  Future<ResponseMania> generateDaysNotResolvedReport({
    String? categoryId,
    String? natureId,
    String? priorityId,
    required String days,
  }) async {
    try {
      final String? baseUrl = school?.schoolFirstServerAddress;
      final String? loginUserId = user?.getUserId;

      if (baseUrl == null || loginUserId == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Missing school configuration or user information.',
        );
      }

      final String tokenUrl = "$baseUrl${RestAPIs.TOKEN_URL}";
      final Map<String, dynamic>? tokenResponse = await dataFilter.getToken(
        serverUrl: tokenUrl,
        apiCode: ApiAuth.DAYS_NOT_RESOLVED_REPORT_API_CODE,
      );

      if (tokenResponse == null || tokenResponse['accessToken'] == null) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: responseTokenErrorMessage,
        );
      }

      final URLQueryParams queryParams = URLQueryParams();
      queryParams.append("callback", ApiAuth.DAYS_NOT_RESOLVED_REPORT_CALLBACKS);
      queryParams.append("loginUserId", loginUserId);
      queryParams.append("apiCode", ApiAuth.DAYS_NOT_RESOLVED_REPORT_API_CODE);
      queryParams.append("accessToken", tokenResponse['accessToken']);
      queryParams.append("txtDays", days);
      
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams.append("cmbQueryCategory", categoryId);
      }
      if (natureId != null && natureId.isNotEmpty) {
        queryParams.append("cmbQueryNature", natureId);
      }
      if (priorityId != null && priorityId.isNotEmpty) {
        queryParams.append("cmbQueryPriority", priorityId);
      }

      final String requestUrl =
          "$baseUrl${RestAPIs.DAYS_NOT_RESOLVED_REPORT_URL}?$queryParams";
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: getHeader);

      if (response.statusCode != 200) {
        return Failure(
          responseStatus: ResponseManiaStatus.ERROR,
          responseMessage: 'Unable to generate report.',
        );
      }

      final String filteredResponse = await dataFilter.toJsonResponse(
        callback: ApiAuth.DAYS_NOT_RESOLVED_REPORT_CALLBACKS,
        response: response.body,
      );

      final Map<String, dynamic> content = json.decode(filteredResponse);

      if (content['isSuccess'] == true) {
        final success = Success(success: content);
        notifyListeners();
        return success;
      } else {
        return Failure(
          responseStatus: ResponseManiaStatus.FAILED,
          responseMessage: content['message']?.toString() ?? 'Failed to generate report.',
        );
      }
    } catch (error, stackTrace) {
      log(
        'generateDaysNotResolvedReport error: $error',
        stackTrace: stackTrace,
        name: 'QueryResolutionService',
      );
      return Failure(
        responseStatus: ResponseManiaStatus.ERROR,
        responseMessage: internalMessage,
      );
    }
  }
}


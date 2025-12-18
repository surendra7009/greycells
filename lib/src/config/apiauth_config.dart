class ApiAuth {
  static final String KSPLID = "kspl_123";

  // LOGIN APICODE AND CALLBACK
  static final String LOGIN_API_CODE = 'LOG_IN';
  static final String LOGIN_CALLBACKS = 'logInCall';

  // SCHOOL APICODE AND CALLBACK
  static final String SCHOOL_VERIFY_API_CODE = 'CLIENT_VALIDATE';
  static final String SCHOOL_VERIFY_CALLBACKS = 'clientList';

  // STUDENT PROFILE INFO
  static final String STUDENT_INFO_API_CODE = 'STUDENT_INFO';
  static final String STUDENT_INFO_CALLBACKS = 'studentInfo';

  // STUDENT PROFILE INFO
  static final String ATTENDANCE_API_CODE = 'MY_ATTND';
  static final String ATTENDANCE_CALLBACKS = 'logInCall';

  // AVAILABLE SESSION
  static final String AVAILABLE_SESSION_API_CODE = 'AVAILABLE_TERM';
  static final String AVAILABLE_SESSION_CALLBACKS = 'myAvailTermCall';

  // TERM_WISE_EXAMS
  static final String EXAM_API_CODE = 'TERMWISE_STDNEXAMS';
  static final String EXAM_CALLBACKS = 'myAvailTermCall';

  // SUBJECT_MARKS
  static final String MARK_API_CODE = 'TERMEXAMWISE_STDNMARKS';
  static final String MARK_CALLBACKS = 'myAvailTermCall';

  // ACADEMIC EVENTS
  static final String ACADEMIC_CALENDAR_API_CODE = 'CLS_ACDMC_CALENDAR';
  static final String ACADEMIC_CALENDAR_CALLBACKS = 'classAcdmcCalendar';

  // ACADEMIC NOTICES
  static final String NOTICE_API_CODE = 'VIEW_NOTICE';
  static final String NOTICE_CALLBACKS = 'viewNoticeCall';

  // CLIENT ADDRESS
  static final String CONTACT_API_CODE = 'CLIENT_ADDRESS';
  static final String CONTACT_CALLBACKS = 'clientAddress';

  // ACCOUNT DUE
  static final String ACCOUNT_DUE_API_CODE = 'ONLINE_PAY_DUE_LIST';
  static final String ACCOUNT_DUE_CALLBACKS = 'onlineDueDetail';

  // COURSE
  static final String COURSE_API_CODE = 'MY_SUBJECT';
  static final String COURSE_CALLBACKS = 'mySubject';
  static final String STDN_TIMETABLE_DTLS = "STDN_TIMETABLE_DTLS";
  static final String COURSE_VECTOR_API_CODE = 'CourseVector';
  static final String COURSE_VECTOR_CALLBACKS = 'COURSEVECTOR';
  static final String BATCH_VECTOR_ON_COURSE_API_CODE = 'BatchVectorOnCourse';
  static final String BATCH_VECTOR_ON_COURSE_CALLBACKS = 'COURSEVECTOR';
  static final String BILL_STUDENT_DETAILS_API_CODE = 'BillStudentDetails';
  static final String BILL_STUDENT_DETAILS_CALLBACKS = 'BILLSTDNDETAILS';
  static final String MY_STUDENT_BILL_PRINT_API_CODE = 'MyStudentBillPrint';
  static final String MY_STUDENT_BILL_PRINT_CALLBACKS = 'MYSTDNBILLPRINTRPT';
  static final String MY_STUDENT_BILL_ACCOUNT_PRINT_API_CODE = 'MyStudentBillAccountPrint';
  static final String MY_STUDENT_BILL_ACCOUNT_PRINT_CALLBACKS = 'MYSTDNBILLACCOUNTRPT';

  // PayMessage
  static final String PAY_MESSAGE_API_CODE = 'ONLINE_PAY_MSG';
  static final String ONLINE_PAY_RPT = "ONLINE_PAY_RPT";
  static final String PAY_MESSAGE_CALLBACKS = 'onlinePayMessage';
  static final String STDNPAYMENT_DETAILS_LIST = "STDNPAYMENT_DETAILS_LIST";
  static final String STDNFEE_RECEIPT_REPORT = "STDNFEE_RECEIPT_REPORT";

  // Faculty / Staff
  static final String STAFF_PPROFILE_API_CODE = 'STAFF_INFO';
  static final String STAFF_PPROFILE_CALLBACKS = 'staffInformation';

  // Faculty TimeTable
  static final String STAFF_TIMETABLE_API_CODE = 'STAFF_TIMETABLE';
  static final String STAFF_TIMETABLE_CALLBACKS = 'StaffTimeTable';

  // Menu List
  static final String MENU_LIST_API_CODE = 'MY_MENULIST';
  static final String MENU_LIST_CALLBACKS = 'myMenusList';

  // Attendance My School Scheme Entry
  static final String ATTENDANCE_ENTRY_API_CODE = 'STUD_ATTND_SAVE';
  static final String ATTENDANCE_ENTRY_SCHOOL_SCHEME_CALLBACKS =
      'mySchoolSchemeDtl';

  // Attendance My School Entry
  static final String ATTENDANCE_ENTRY_SCHOOL_CALLBACKS = 'mySchoolDtl';

  // Attendance Criteria
  static final String ATTENDANCE_ENTRY_CRITERIA_CALLBACKS = 'attndCriteria';

  // Attendance Student List
  static final String ATTENDANCE_ENTRY_STUDLIST_CALLBACKS = 'studentListDtl';

  // Attendance Student List
  static final String ATTENDANCE_ENTRY_STATUS_CALLBACKS =
      'attendStatusListVector';

  // Attendance Student List
  static final String ATTENDANCE_ENTRY_SAVE_CALLBACKS = 'attendSave';

  // AVAILABLE_EXAMRPT_TERM
  static final String AVAILABLE_EXAMRPT_TERM_API_CODE =
      'AVAILABLE_EXAMRPT_TERM';
  static final String AVAILABLE_EXAMRPT_TERM_CALLBACKS = 'myAvailExamRptTerm';

  // MY_EXAMREPORTLIST
  static final String MY_EXAMREPORTLIST_API_CODE = 'MY_EXAMREPORTLIST';
  static final String MY_EXAMREPORTLIST_CALLBACKS = 'myExamReportsList';

  // MY_EXAMREPORT
  static final String MY_EXAMREPORT_API_CODE = 'MY_EXAMREPORT';
  static final String MY_EXAMREPORT_CALLBACKS = 'myReportCardDtl';

  // STAFF_LEAVE_BALANCE
  static final String STAFF_LEAVE_BALANCE_API_CODE = 'STAFF_LEAVE_BALANCE';
  static final String STAFF_LEAVE_BALANCE_CALLBACKS = 'StaffLeaveBalance';

  // SALARY SLIP
  static final String SALARY_SLIP_PRINT_API_CODE = 'SalarySlipPrint';
  static final String SALARY_SLIP_PRINT_CALLBACKS = 'SALARYSLIPRPT';

  // HELP DESK / QUERY RESOLUTION
  static final String QUERY_NATURE_VECTOR_API_CODE = 'QueryNatureVector';
  static final String QUERY_NATURE_VECTOR_CALLBACKS = 'Query_Nature_Vector';
  static final String CATEGORY_HELPDESK_API_CODE = 'CategoryHelpdesk';
  static final String CATEGORY_HELPDESK_CALLBACKS = 'CATEGORYHELPDESK';
  static final String INITIATE_QUERY_LIST_API_CODE = 'InitiateQueryList';
  static final String INITIATE_QUERY_LIST_CALLBACKS = 'Initiate_Query_List';
  static final String INITIATE_QUERY_DETAILS_API_CODE = 'InitiateQueryDetails';
  static final String INITIATE_QUERY_DETAILS_CALLBACKS = 'Initiate_Query_Dtls';
  static final String QUERY_STATUS_VECTOR_API_CODE = 'QueryStatusVector';
  static final String QUERY_STATUS_VECTOR_CALLBACKS = 'Query_Status_Vector';
  static final String QUERY_PRIORITY_HELPDESK_API_CODE = 'QueryPriorityHelpdesk';
  static final String QUERY_PRIORITY_HELPDESK_CALLBACKS = 'QUERYPRIORITYHELPDESK';
  static final String INITIATE_QUERY_ADD_API_CODE = 'InitiateQueryAdd';
  static final String INITIATE_QUERY_ADD_CALLBACKS = 'Initiate_Query_Add';
  static final String INITIATE_QUERY_UPDATE_API_CODE = 'InitiateQueryUpdate';
  static final String INITIATE_QUERY_UPDATE_CALLBACKS = 'Initiate_Query_Update';
  static final String INITIATE_QUERY_REMARKS_ADD_API_CODE = 'InitiateQueryRemarksAdd';
  static final String INITIATE_QUERY_REMARKS_ADD_CALLBACKS = 'Initiate_Query_Remarks_Add';
  static final String INITIATE_QUERY_REMARKS_LIST_API_CODE = 'InitiateQueryRemarksList';
  static final String INITIATE_QUERY_REMARKS_LIST_CALLBACKS = 'Initiate_Query_Remarks_List';
  static final String DAYS_NOT_RESOLVED_REPORT_API_CODE = 'DaysNotResolvedReport';
  static final String DAYS_NOT_RESOLVED_REPORT_CALLBACKS = 'DAYSNOTRESOLVEDREPORT';

  // HELP DESK / QUERY RESOLUTION – ASSIGN & RESOLUTION FLOWS (from Postman collection)
  // Assigned / Resolution list APIs
  static final String ASSIGNED_TO_ACTION_API_CODE = 'APIGetAssignedToAction';
  static final String ASSIGNED_TO_ACTION_CALLBACKS = 'GETASSIGNEDTOACTION';
  static final String QUERY_RESOLUTION_LIST_LOAD_API_CODE =
      'QueryResolutionListLoadAction';
  static final String QUERY_RESOLUTION_LIST_LOAD_CALLBACKS =
      'QUERYRESOLUTIONLISTLOADACTION';

  // Resolution details & save/update APIs
  static final String QUERY_DETAILS_LOAD_API_CODE = 'QueryDetailsLoadAction';
  static final String QUERY_DETAILS_LOAD_CALLBACKS = 'QUERYDETAILSLOADACTION';
  static final String QUERY_RESOLUTION_SAVE_UPDATE_API_CODE =
      'QUERYRESOLUTIONSAVEUPDATEACTION';
  static final String QUERY_RESOLUTION_SAVE_UPDATE_CALLBACKS =
      'QUERYRESOLUTIONSAVEUPDATEACTION';

  // Resolution remarks APIs
  static final String REMARKS_DETAILS_API_CODE = 'APIGetRemarksDetailsAction';
  static final String REMARKS_DETAILS_CALLBACKS = 'GETREMARKSDETAILS';
  static final String REMARKS_DETAILS_SAVE_API_CODE =
      'REMARKSDETAILSSAVEACTION';
  static final String REMARKS_DETAILS_SAVE_CALLBACKS =
      'REMARKSDETAILSSAVEACTION';

  // Assign & assign-remarks APIs
  static final String QUERY_ASSIGN_SAVE_API_CODE = 'QUERYASSIGNSAVEACTION';
  static final String QUERY_ASSIGN_SAVE_CALLBACKS = 'QUERYASSIGNSAVEACTION';
  static final String QUERY_ASSIGN_REMARKS_SAVE_API_CODE =
      'QUERYASSIGNREMARKSSAVEACTION';
  static final String QUERY_ASSIGN_REMARKS_SAVE_CALLBACKS =
      'QUERYASSIGNREMARKSSAVEACTION';
}

class RestAPIs {
  // static final String _GREYCELL_SERVER_URL = "http://103.139.89.125";
  static final String _GREYCELL_SERVER_URL = "http://erp.vordurja.in";

  // WebView
  static final String WEB_VIEW_URL =
      "$_GREYCELL_SERVER_URL/IITBRestAPI/api_folder/index.html";
//old = GSLRestAPI
  // App
  static final String KSPL_LOGO_URL =
      "$_GREYCELL_SERVER_URL/images/logos/KSPL.jpg";
  static final String GREYCELL_SCHOOL_VALIDATE_URL =
      "$_GREYCELL_SERVER_URL/IITBRestAPI/1/getAPIClientList";
  static final String GREYCELL_TOKEN_URL =
      "$_GREYCELL_SERVER_URL/IITBRestAPI/1/GetAPPSToken";

  static final String GREYCELL_REPORT_URL =
      "$_GREYCELL_SERVER_URL/IITBRestAPI/reports/";

  // Dynamic Srver EndPoints
  static final String LOGIN_URL = "/1/LoginAPI";
  static final String TOKEN_URL = "/1/GetAPPSToken";
  static final String PROFILE_URL = "/1/APIgetStudDtl";
  static final String STAFF_PROFILE_URL = "/1/APIgetStaffDtl";
  static final String ATTENDANCE_URL = "/1/APIStudMyAttndDtl";
  static final String MENU_LIST_URL = "/1/APIStdnMenusList";
  static final String ATTENDANCE_ENTRY_SCHOOL_SCHEME_URL =
      "/1/APIGetSchoolSchemeAttendance";
  static final String ATTENDANCE_ENTRY_SCHOOL_URL =
      "/1/APIGetSchoolDtlAttendance";
  static final String ATTENDANCE_ENTRY_CRITERIA_URL =
      "/1/APIGetAttendanceCriteria";
  static final String ATTENDANCE_ENTRY_STUDLIST_URL =
      "/1/APIGetStdnListForAttendance";
  static final String ATTENDANCE_ENTRY_STATUS_URL =
      "/1/APIGetAttendanceStatusVector";
  static final String ATTENDANCE_ENTRY_SAVE_URL =
      "/1/APIGetAttendanceAddUpdate";
  static final String SESSION_URL = "/1/APIGetMyTermList";
  static final String AVAILABLE_EXAMRPT_TERM_URL = "/1/APIGetMyExamRptTermList";
  static final String MY_EXAMREPORTLIST_URL = "/1/APIStudExamReportsList";
  static final String MY_EXAMREPORT_URL = "/1/APIStudReportCardDtl";

  static final String EXAM_URL = "/1/APIGetMyTermwiseExam";
  static final String MARK_URL = "/1/APIGetMyTermExamwiseMark";
  static final String ACADEMIC_CALENDAR_URL = "/1/getAPIClassAcdmcCal";
  static final String NOTICE_URL = "/1/APIViewNoticeList";
  static final String CONTACT_URL = "/1/getAPIClientAddress";
  static final String ACCOUNT_DUE_URL = "/1/APIStudPayDueDtl";
  static final String COURSE_URL = "/1/APIStudMySubjectDtl";
  static final String APIStudTimeTableDtl = "/1/APIStudTimeTableDtl";
  static final String COURSE_VECTOR_URL = "/1/APIGetCourseVector";
  static final String BATCH_VECTOR_ON_COURSE_URL = "/1/APIGetBatchVectorOnCourse";
  static final String BILL_STUDENT_DETAILS_URL = "/1/APIGetStudentBillRpt";
  static final String MY_STUDENT_BILL_PRINT_URL = "/1/APIGetMyStudentBillRptPrint";
  static final String MY_STUDENT_BILL_ACCOUNT_PRINT_URL = "/1/APIGetMyStudentBillAccountRpt";
  static final String PAY_MESSAGE_URL = "/1/APIStudPayMessageTransNo";
  static final String Receipt_Url =
      "$_GREYCELL_SERVER_URL/IITBRestAPI/1/APIStudOnlinePayReport";
  static final String Receipt_List_Url =
      "$_GREYCELL_SERVER_URL/IITBRestAPI/1/APIStudPaymentDtlList";
  static final String Fee_Receipt_To_View =
      "$_GREYCELL_SERVER_URL/IITBRestAPI/1/APIStudFeeReceiptToView";
  static final String STAFF_TIMETABLE_URL = "/1/APIgetStaffTimeTbl";
  static final String SCHOOL_LOGO_URL = "/images/logos/Logo.jpg";
  static final String STAFF_LEAVE_BALANCE_URL = "/1/APIgetStaffLeaveBlnc";
  static final String SALARY_SLIP_REPORT_URL = "/1/APIGetSalarySlipPrint";

  // HELP DESK / QUERY RESOLUTION URLs
  static final String QUERY_NATURE_VECTOR_URL = "/1/APIGetQueryNatureVector";
  static final String CATEGORY_HELPDESK_URL = "/1/APIGetCategoryHelpdesk";
  static final String INITIATE_QUERY_LIST_URL = "/1/APIGetInitiateQueryList";
  static final String INITIATE_QUERY_DETAILS_URL = "/1/APIGetInitiateQueryDtls";
  static final String QUERY_STATUS_VECTOR_URL = "/1/APIGetQueryStatusVector";
  static final String INITIATE_QUERY_ADD_URL = "/1/APIAddInitiateQuery";
  static final String INITIATE_QUERY_UPDATE_URL = "/1/APIUpdateInitiateQuery";
  static final String INITIATE_QUERY_REMARKS_ADD_URL = "/1/APIAddInitiateQueryRemarks";
  static final String INITIATE_QUERY_REMARKS_LIST_URL = "/1/APIGetInitiateQueryRemarksList";
  static final String QUERY_PRIORITY_HELPDESK_URL = "/1/APIGetQueryPriorityHelpdesk";

  // HELP DESK / QUERY RESOLUTION – ASSIGN & RESOLUTION FLOW URLs
  static final String ASSIGNED_TO_ACTION_URL = "/1/APIGetAssignedToAction";
  static final String QUERY_RESOLUTION_LIST_LOAD_URL =
      "/1/APIGetQueryResolutionListLoadAction";
  static final String QUERY_DETAILS_LOAD_URL = "/1/APIGetQueryDetailsLoadAction";
  static final String QUERY_RESOLUTION_SAVE_UPDATE_URL =
      "/1/APIQueryResolutionSaveUpdateAction";
  static final String REMARKS_DETAILS_URL = "/1/APIGetRemarksDetailsAction";
  static final String REMARKS_DETAILS_SAVE_URL =
      "/1/APIGetRemarksDetailsSaveAction";
  static final String QUERY_ASSIGN_SAVE_URL = "/1/APIQueryAssignSaveAction";
  static final String QUERY_ASSIGN_REMARKS_SAVE_URL =
      "/1/APIQueryAssignRemarksSaveAction";
  static final String DAYS_NOT_RESOLVED_REPORT_URL = "/1/APIDaysNotResolvedReportAction";
}

enum ResponseStatus { INITIAL, SUCCESS, FAILURE, ERROR }

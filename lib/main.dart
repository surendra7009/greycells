import 'package:flutter/material.dart';
import 'package:greycell_app/src/app/my_app.dart';
import 'package:greycell_app/src/config/system_config.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize status bar immediately
  SystemConfig.makeStatusBarHide();
  
  final MainModel _model = MainModel();

  // Handle version with timeout (non-blocking)
  _model.handleVersion().timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      print('Version handling timed out, continuing...');
    },
  ).catchError((error) {
    print('Version handling error: $error');
  });
  
  // Initialize date formatting in background (non-blocking)
  initializeDateFormatting().timeout(
    const Duration(seconds: 5),
    onTimeout: () {
      print('Date formatting initialization timed out, continuing...');
    },
  ).catchError((error) {
    print('Date formatting error: $error');
  });
  
  // Run auto methods in background (don't block app launch)
  _model.autoSchoolValidate();
  _model.autoAuthenticateUser();

  // Launch app immediately without waiting for background tasks
  runApp(MyApp(
    model: _model,
  ));
}








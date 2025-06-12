import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_management_system/services/task_management_system_services.dart';

class AdminDashboardProvider extends ChangeNotifier {
  int _totalUsers = 0;
  int _totalCompanies = 0;
  int _totalIssues = 0;
  int _totalPendingIssues = 0;
  int _totalSolvedIssues = 0;

  int get totalUsers => _totalUsers;
  int get totalCompanies => _totalCompanies;
  int get totalIssues => _totalIssues;
  int get totalPendingIssues => _totalPendingIssues;
  int get totalSolvedIssues => _totalSolvedIssues;

  void getAllCompanies() async {
    TMSResponse response = await TMSServices.getRequest('company/all/6820859b50f308dd5d8eb189');
    final body = jsonDecode(response.body);
    if(response.statusCode == 200){

    }
  }
}
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/services/task_management_system_services.dart';

class SuperAdminDashboardProvider extends ChangeNotifier{
  List<dynamic> _adminList = [];
  List<dynamic> _subscriptionList = [];
  int _totalAdmin = 0;
  int _totalSubscription = 0;

  List<dynamic> get adminList => _adminList;
  List<dynamic> get subscriptionList => _subscriptionList;
  int get totalAdmin => _totalAdmin;
  int get totalSubscription => _totalSubscription;

  void getAdmins() async {
    TMSResponse response = await TMSServices.getRequest('admin/all');
    final body = jsonDecode(response.body);
    if(response.statusCode == 200){
      _adminList = body['admins'];
      _totalAdmin = _adminList.length;
    }else{
      NotiService().showNotification(title: 'Failed to fetch!', body: body['message']);
    }
    notifyListeners();
  }

  void getSubscriptions() async {
    TMSResponse response = await TMSServices.getRequest('subscription/all');
    final body = jsonDecode(response.body);
    if(response.statusCode == 200){
      _subscriptionList = body['subscriptions'];
      _totalSubscription = _subscriptionList.length;
      print('Subscriptions = $_subscriptionList');
    }else{
      NotiService().showNotification(title: 'Failed to fetch!', body: body['message']);
    }
    notifyListeners();
  }
}
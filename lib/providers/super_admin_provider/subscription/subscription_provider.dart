import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/services/task_management_system_services.dart';

class SubscriptionProvider extends ChangeNotifier{
  // List<String> _subscriptionName = ['Basic', 'Premium'];
  // String _selectedSubscriptionName = 'Basic';
  String _selectedSubscriptionId = '';
  List<dynamic> _subscriptionsList = [];
  Map<String,dynamic> _body = {};
  final _subscriptionFormKey = GlobalKey<FormState>();
  bool _isEditSubscription = false;
  bool _subscriptionStatus = false;
  final _subscriptionNameTextController = TextEditingController();
  final _maxCompaniesTextController = TextEditingController();
  final _maxUsersTextController = TextEditingController();
  final _maxUploadPhotoAllowedTextController = TextEditingController();
  final _durationTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _messageTextController = TextEditingController();

  // List<String> get subscriptionName => _subscriptionName;
  // String get selectedSubscriptionName => _selectedSubscriptionName;
  List<dynamic> get subscriptionsList => _subscriptionsList;
  GlobalKey<FormState> get subscriptionFormKey => _subscriptionFormKey;
  bool get isEditSubscription => _isEditSubscription;
  bool get subscriptionStatus => _subscriptionStatus;
  TextEditingController get subscriptionNameTextController => _subscriptionNameTextController;
  TextEditingController get maxCompaniesTextController => _maxCompaniesTextController;
  TextEditingController get maxUsersTextController => _maxUsersTextController;
  TextEditingController get maxUploadPhotoAllowedTextController => _maxUploadPhotoAllowedTextController;
  TextEditingController get durationTextController => _durationTextController;
  TextEditingController get priceTextController => _priceTextController;
  TextEditingController get messageTextController => _messageTextController;

  void setIsEditSubscription(bool value){
    _isEditSubscription = value;
    notifyListeners();
  }

  void toggleSubscriptionStatus(int index, bool value){
    _subscriptionStatus = value;
    _subscriptionsList[index]['status'] = value;
    notifyListeners();
  }

  void resetForm(){
    _subscriptionNameTextController.clear();
    _maxCompaniesTextController.clear();
    _maxUsersTextController.clear();
    _maxUploadPhotoAllowedTextController.clear();
    _durationTextController.clear();
    _priceTextController.clear();
    _messageTextController.clear();
  }

  void getSubscriptions() async {
    TMSResponse response = await TMSServices.getRequest('subscription/all');
    final decodedBody = jsonDecode(response.body);
    if(response.statusCode == 200){
      _subscriptionsList = decodedBody['subscriptions'];
      print('Subscriptions = $_subscriptionsList');
    }else{
      NotiService().showNotification(title: 'Failed to fetch!', body: decodedBody['message']);
    }
    notifyListeners();
  }

  void onTapCreateSubscription(context) async {
    _body['name'] = _subscriptionNameTextController.value.text;
    _body['maxCompanies'] = _maxCompaniesTextController.value.text;
    _body['maxUsers'] = _maxUsersTextController.value.text;
    _body['maxPhotoUploads'] = _maxUploadPhotoAllowedTextController.value.text;
    _body['duration'] = _durationTextController.value.text;
    _body['price'] = _priceTextController.value.text;
    _body['message'] = _messageTextController.value.text;
    if (_subscriptionFormKey.currentState != null && _subscriptionFormKey.currentState!.validate()) {
      TMSResponse response = await TMSServices.postRequest('subscription/create', _body);
      final decodedBody = jsonDecode(response.body);
      if(response.statusCode == 201){
        NotiService().showNotification(title: 'Task Management System', body: decodedBody['message']);
        GoRouter.of(context).pushReplacementNamed(AppRouteName.superAdminDashboardRouteName);
        resetForm();
      }else{
        NotiService().showNotification(title: 'Task Management System', body: decodedBody['message']);
      }
    } else {
      NotiService().showNotification(title: 'Task Management System', body: 'Please fill all the required fields!');
    }
  }

  void onTapUpdateSubscription(context) async {
    _body['name'] = _subscriptionNameTextController.value.text;
    _body['maxCompanies'] = _maxCompaniesTextController.value.text;
    _body['maxUsers'] = _maxUsersTextController.value.text;
    _body['maxPhotoUploads'] = _maxUploadPhotoAllowedTextController.value.text;
    _body['duration'] = _durationTextController.value.text;
    _body['price'] = _priceTextController.value.text;
    _body['message'] = _messageTextController.value.text;
    if (_subscriptionFormKey.currentState != null && _subscriptionFormKey.currentState!.validate()) {
      TMSResponse response = await TMSServices.putRequest('subscription/update?id=$_selectedSubscriptionId', _body);
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      if(response.statusCode == 200){
        NotiService().showNotification(title: 'Task Management System', body: decodedBody['message']);
        GoRouter.of(context).pushReplacementNamed(AppRouteName.superAdminDashboardRouteName);
        resetForm();
      }else{
        NotiService().showNotification(title: 'Task Management System', body: decodedBody['message']);
      }
    } else {
      NotiService().showNotification(title: 'Task Management System', body: 'Please fill all the required fields!');
    }
  }


  void setControllerValue(int index){
    print(_subscriptionsList);
    _selectedSubscriptionId = _subscriptionsList[index]['_id'];
    _subscriptionNameTextController.text = _subscriptionsList[index]['name'];
    _maxCompaniesTextController.text = _subscriptionsList[index]['maxCompanies'].toString();
    _maxUsersTextController.text = _subscriptionsList[index]['maxUsers'].toString();
    _maxUploadPhotoAllowedTextController.text = _subscriptionsList[index]['maxPhotoUploads'].toString();
    _durationTextController.text = _subscriptionsList[index]['duration'].toString();
    _priceTextController.text = _subscriptionsList[index]['price'].toString();
    _messageTextController.text = _subscriptionsList[index]['message'];
    notifyListeners();
  }
}
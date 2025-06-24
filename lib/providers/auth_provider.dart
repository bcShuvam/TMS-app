import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/themes/custom_colors.dart';

import '../notification/noti_service.dart';
import '../routes/app_route_name.dart';
import '../services/task_management_system_services.dart';

class AuthProvider extends ChangeNotifier {
  final _loginFormKey = GlobalKey<FormState>();
  bool _obscure = true;
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  Map<String, dynamic> _body = {};

  // Super Admin, Admin, User
  String _name = '';
  String _email = '';
  String _userId = '';
  String _adminId = '';
  String _role = '';
  String _phone = '';
  String _gender = '';
  String _address = '';

  // Super Admin, Admin, User Getters
  String get name => _name;
  String get email => _email;
  String get userId => _userId;
  String get adminId => _adminId;
  String get role => _role;
  String get phone => _phone;
  String get gender => _gender;
  String get address => _address;

  // Super Admin
  String _totalEarnings = '';
  String _totalSales = '';
  String _totalActiveSales = '';
  bool _isMainAdmin = false;
  String _mainAdminId = '';

  // Super Admin Getters
  String get totalEarnings => _totalEarnings;
  String get totalSales => _totalSales;
  String get totalActiveSales => _totalActiveSales;
  bool get isMainAdmin => _isMainAdmin;
  String get mainAdminId => _mainAdminId;

  // Super Admin Setters
  void setEarningsAndSubscriptions(String earnings, String sales) {
    _totalEarnings = earnings;
    _totalSales = sales;
    notifyListeners();
  }

  // Admin
  String _subscription = '';
  String _subscriptionId = '';
  bool _subscriptionStatus = false;
  String _companyId = '';
  String _department = '';
  String _designation = '';
  int _totalAdminUser = 0;
  int _totalUser = 0;
  int _totalCompany = 0;
  int _totalPost = 0;
  bool _isVerified = false;

  String get companyId => _companyId;
  String get department => _department;
  String get designation => _designation;
  String get subscriptionId => _subscriptionId;
  String get subscription => _subscription;
  bool get subscriptionStatus => _subscriptionStatus;
  int get totalAdminUser => _totalAdminUser;
  int get totalUser => _totalUser;
  int get totalCompany => _totalCompany;
  int get totalPost => _totalPost;
  bool get isVerified => _isVerified;

  // Admin Setters
  void setTotalValues(int totAdminUser, int totUser, int totCompany, int totPost) {
    _totalAdminUser = totAdminUser;
    _totalUser = totUser;
    _totalCompany = totCompany;
    _totalPost = totPost;
  }

  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  TextEditingController get userEmailController => _userEmailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get otpController => _otpController;
  bool get obscure => _obscure;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  void clearForm() {
    _userEmailController.clear();
    _passwordController.clear();
    _body.clear();
    _obscure = true;
    notifyListeners();
  }

  void clearOtpForm() {
    _otpController.clear();
    notifyListeners();
  }

  void printUserInfo() {
    print('User ID: $_userId');
    print('Name: $_name');
    print('Email: $_email');
    print('Role: $_role');
    print('Phone: $_phone');
    print('Company ID: $_companyId');
    print('Department: $_department');
    print('Designation: $_designation');
    print('Subscription ID: $_subscriptionId');
    print('Subscription Status: $_subscriptionStatus');
    print('Is Verified: $_isVerified');
    print('Admin ID: $_adminId');
    print('Main Admin ID: $_mainAdminId');
    print('Total Earnings: $_totalEarnings');
    print('Total Sales: $_totalSales');
    print('Total Active Sales: $_totalActiveSales');
    print('Is Main Admin: $_isMainAdmin');
    notifyListeners();
  }

  void clearUserInfo() {
    _userId = '';
    _name = '';
    _email = '';
    _role = '';
    _phone = '';
    _companyId = '';
    _department = '';
    _designation = '';
    _subscriptionId = '';
    _subscriptionStatus = false;
    _isVerified = false;
    _adminId = '';
    notifyListeners();
  }

  void logout() async {
    TMSResponse response = await TMSServices.postRequest('user/logout', {});
  }

  void setTotalAdminAndUser(int totalAdmin, int totalUser) {
    _totalAdminUser = totalAdmin;
    _totalUser = totalUser;
    notifyListeners();
  }

  void setTotalCompanies(int totalCompany) {
    _totalCompany = totalCompany;
    notifyListeners();
  }

  void login(context) async {
    _body['email'] = _userEmailController.text.toLowerCase().trim();
    _body['password'] = _passwordController.text.trim();

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );

    TMSResponse response = await TMSServices.postRequest('auth/login', _body, isLogin: true);
    print(response.body);
    Map<String, dynamic> decodedBody = jsonDecode(response.body);
    print('decodedBody = $decodedBody');
    if (response.statusCode == 200) {
      NotiService().showNotification(
        id: 0,
        title: 'Login Successful',
        body: decodedBody['message'],
      );

      final role = decodedBody['user']['role'];
      _userId = decodedBody['user']['_id'];
      _name = decodedBody['user']['name'];
      _email = decodedBody['user']['email'];
      _role = role;
      _phone = decodedBody['user']['phone'];
      _isVerified = decodedBody['user']['isVerified'];
      _gender = decodedBody['user']['gender'];
      _address = decodedBody['user']['address'];
      _subscriptionId =
          decodedBody['user'].containsKey('subscriptionId')
              ? decodedBody['user']['subscriptionId']
              : '';
      _subscriptionStatus =
          decodedBody['user'].containsKey('subscriptionStatus')
              ? decodedBody['user']['subscriptionStatus']
              : false;

      if (role == 'Super Admin') {
        _isVerified = decodedBody['user']['isVerified'];
        _totalEarnings = decodedBody['user']['totalEarnings'].toString();
        _totalSales = decodedBody['user']['totalSales'].toString();
        GoRouter.of(
          context,
        ).pushNamed(AppRouteName.superAdminDashboardRouteName);
      } else if (role == 'Admin') {
        _isMainAdmin = decodedBody['user']['isMainAdmin'] ?? false;
        _totalAdminUser = decodedBody['user']['totalAdmins'] ?? 0;
        _totalUser = decodedBody['user']['totalUsers'] ?? 0;
        _totalCompany = decodedBody['user']['totalCompanies'] ?? 0;
        _totalPost = decodedBody['user']['totalPost'] ?? 0;
        if(_isMainAdmin){
          _mainAdminId = userId;
          _adminId = '';
        }else{
          _mainAdminId = decodedBody['user']['mainAdminId'] ?? '';
          _adminId = _userId;
        }
        GoRouter.of(context).pushNamed(AppRouteName.adminDashboardRouteName);
      } else {
        _companyId = decodedBody['user']['companyId'];
        _mainAdminId = decodedBody['user']['mainAdminId'] ?? '';
        _department = decodedBody['user']['department'];
        _designation = decodedBody['user']['designation'];
        _adminId = decodedBody['user']['adminId'] == null ? '' : decodedBody['user']['adminId'];
        GoRouter.of(context).pushNamed(AppRouteName.userDashboardRouteName);
      }
      printUserInfo();
      clearForm();
      Navigator.of(context).pop();
    }else {
      _isVerified = decodedBody.containsKey('isVerified') ? decodedBody['isVerified'] : false;
      if(decodedBody.containsKey('isVerified') && !_isVerified) {
        NotiService().showNotification(
          id: 0,
          title: 'User Not Verified',
          body: decodedBody['message'],
        );
        Navigator.of(context).pop();
        GoRouter.of(context).pushNamed(AppRouteName.otpVerificationRouteName);
        return;
      }
      NotiService().showNotification(
        id: 0,
        title: 'Login Failed',
        body: decodedBody['message'],
      );
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  void verifyOTP(context) async {
    _body.clear();
    _body['email'] = _userEmailController.value.text.toLowerCase().trim();
    _body['otp'] = _otpController.value.text.trim();

    print(_body);

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );

    TMSResponse response = await TMSServices.postRequest('auth/verify-otp', _body);
    Map<String, dynamic> decodedBody = jsonDecode(response.body);
    print(decodedBody);

    if (response.statusCode == 200) {
      NotiService().showNotification(
        id: 0,
        title: 'OTP Verified',
        body: decodedBody['message'],
      );
      clearOtpForm();
      GoRouter.of(
        context,
      ).pushReplacementNamed(AppRouteName.loginRouteName);
    } else {
      NotiService().showNotification(
        id: 0,
        title: 'OTP Verification Failed',
        body: decodedBody['message'],
      );
    }
    Navigator.pop(context);
    notifyListeners();
  }

  void getUpdatedValues() async {
    print('Updated Values');
  }
}

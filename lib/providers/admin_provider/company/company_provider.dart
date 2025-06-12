import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/services/task_management_system_services.dart';

import '../../../notification/noti_service.dart';
import '../../../themes/custom_colors.dart';

class CompanyProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  CompanyProvider(this.authProvider);

  final _formKey = GlobalKey<FormState>();
  TextEditingController _companyNameTextController = TextEditingController();
  TextEditingController _companyLogoTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _contactTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _websiteTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  TextEditingController _industryTypeTextController = TextEditingController();
  List<String> _industryList = ['IT', 'FMCG', 'Others'];
  String _industryType = 'IT';
  List<dynamic> _companies = [];
  String _selectedIndustry = 'IT';
  String _industry = '';
  Map<String, dynamic> _body = {};
  bool _isEdit = false;
  Map<String, dynamic> _selectedCompany = {};

  GlobalKey get formKey => _formKey;
  TextEditingController get companyNameTextController =>
      _companyNameTextController;
  TextEditingController get companyLogoTextController =>
      _companyLogoTextController;
  TextEditingController get emailTextController => _emailTextController;
  TextEditingController get contactTextController => _contactTextController;
  TextEditingController get addressTextController => _addressTextController;
  TextEditingController get websiteTextController => _websiteTextController;
  TextEditingController get descriptionTextController =>
      _descriptionTextController;
  TextEditingController get industryTypeTextController =>
      _industryTypeTextController;
  List<dynamic> get companies => _companies;
  List<String> get industryList => _industryList;
  String get selectedIndustry => _selectedIndustry;
  bool get isEdit => _isEdit;
  Map<String, dynamic> get selectedCompany => _selectedCompany;

  void setSelectedIndustry(String value) {
    _selectedIndustry = value;
    if (_selectedIndustry == 'Others') {
      _industryType = _industryTypeTextController.value.text;
    } else {
      _industryType = _selectedIndustry;
    }
    notifyListeners();
  }

  void getAllCompanies() async {
    TMSResponse response = await TMSServices.getRequest('company/all');
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
    print(decodedBody.runtimeType);
    _companies = decodedBody['companies'];
    print(_companies);
    print(response.statusCode);
    notifyListeners();
  }

  void onTapCreate(context) async {
    _body['title'] = _companyNameTextController.text.trim();
    _body['email'] = _emailTextController.text.trim();
    _body['phone'] = _contactTextController.text.trim();
    _body['address'] = _addressTextController.text.trim();
    _body['website'] = _websiteTextController.text.trim();
    _body['description'] = _descriptionTextController.text.trim();
    _body['industry'] = _industryType;
    _body['adminId'] = authProvider.adminId;
    _body['mainAdminId'] = authProvider.mainAdminId;
    _body['logo'] = _companyLogoTextController.value.text.trim();

    if (_selectedIndustry == 'Others') {
      _industry = _industryTypeTextController.text;
    } else {
      _industry = _selectedIndustry;
    }
    _body['industry'] = _industry;
    print(_body);

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.primaryColor),
          );
        },
      );

      TMSResponse response = await TMSServices.postRequest(
        'company/create',
        _body,
      );
      final decodedBody = jsonDecode(response.body);
      print(decodedBody);
      print(response.statusCode);

      if (response.statusCode == 201) {
        NotiService().showNotification(
          title: 'Task Management System',
          body: 'User Added successfully!',
        );
        Navigator.of(context).pop();
        authProvider.setTotalCompanies(decodedBody['totalCompanies']);
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.adminCompaniesRouteName);
        clearFrom();
      } else {
        Navigator.of(context).pop();
        NotiService().showNotification(
          title: 'Task Management System',
          body: 'Failed to add company!',
        );
        return;
      }
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: 'Please fill all the required fields!',
      );
    }
    notifyListeners();
  }

  void clearFrom() {
    _companyNameTextController.clear();
    _companyLogoTextController.clear();
    _emailTextController.clear();
    _contactTextController.clear();
    _addressTextController.clear();
    _websiteTextController.clear();
    _descriptionTextController.clear();
    _industryTypeTextController.clear();
    _industryType = 'IT';
    _selectedIndustry = 'IT';
    notifyListeners();
  }

  void onTapEdit(context, Map<String, dynamic> company) {
    _isEdit = true;
    _selectedCompany = company;
    print(_selectedCompany);

    _companyNameTextController.text = selectedCompany['title'];
    _companyLogoTextController.text = selectedCompany['logo'] ?? '';
    _emailTextController.text = selectedCompany['email'] ?? '';
    _contactTextController.text = selectedCompany['phone'] ?? '';
    _addressTextController.text = selectedCompany['address'] ?? '';
    _websiteTextController.text = selectedCompany['website'] ?? '';
    _descriptionTextController.text = selectedCompany['description'] ?? '';
    for (String industry in _industryList) {
      if (industry == selectedCompany['industry']) {
        _selectedIndustry = industry;
        _industryType = industry;
        break;
      } else {
        _selectedIndustry = 'Others';
        _industryType = selectedCompany['industry'] ?? '';
      }
    }
    _industryTypeTextController.text = _industryType;
    notifyListeners();
  }

  void updateCompany(context) async {
    _body['title'] = _companyNameTextController.text;
    _body['email'] = _emailTextController.text.trim();
    _body['phone'] = _contactTextController.text.trim();
    _body['address'] = _addressTextController.text.trim();
    _body['website'] = _websiteTextController.text.trim();
    _body['description'] = _descriptionTextController.text.trim();
    _body['industry'] = _industryType;
    _body['adminId'] = authProvider.adminId;
    _body['mainAdminId'] = authProvider.mainAdminId;
    _body['logo'] = _companyLogoTextController.value.text.trim();

    if (_selectedIndustry == 'Others') {
      _industry = _industryTypeTextController.text;
    } else {
      _industry = _selectedIndustry;
    }
    _body['industry'] = _industry;

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.primaryColor),
          );
        },
      );

      TMSResponse response = await TMSServices.putRequest(
        'company/update/${_selectedCompany['_id']}',
        _body,
      );
      final decodedBody = jsonDecode(response.body);
      print(decodedBody);
      print(response.statusCode);

      if (response.statusCode == 200) {
        NotiService().showNotification(
          title: 'Task Management System',
          body: 'Company updated successfully!',
        );
        Navigator.of(context).pop();
        clearFrom();
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.adminCompaniesRouteName);
      } else {
        Navigator.of(context).pop();
        NotiService().showNotification(
          title: 'Task Management System',
          body: 'Failed to update company!',
        );
        return;
      }
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: 'Please fill all the required fields!',
      );
    }
    notifyListeners();
  }

  void deleteCompany(context, String id) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );
    TMSResponse response = await TMSServices.deleteRequest(
      'company/delete/$id',
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      getAllCompanies();
      Navigator.of(context).pop();
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      Navigator.of(context).pop();
    }
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import '../../../services/task_management_system_services.dart';
import '../../../themes/custom_colors.dart';

class UserProvider extends ChangeNotifier {
  AuthProvider authProvider;
  UserProvider(this.authProvider);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _designationTextController =
      TextEditingController();
  final TextEditingController _departmentTextController =
      TextEditingController();
  final TextEditingController _addressTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  List<String> _companyList = [];
  String _selectedCompany = '';
  List<String> _roleList = ['Admin User', 'User'];
  String _selectedRole = 'Admin User';
  List<String> _genderList = ['Male', 'Female', 'Other'];
  String _selectedGender = 'Male';
  bool _obscure = true;
  Map<String, dynamic> _body = {};
  List<dynamic> _companies = [];
  int _indexOfSelectedCompany = 0;
  String _selectedCompanyId = '';
  Map<String, bool> _companyRolesCheckbox = {
    'create': false,
    'read': false,
    'update': false,
    'delete': false,
  };
  Map<String, bool> _userRolesCheckbox = {
    'create': false,
    'read': false,
    'update': false,
    'delete': false,
  };
  Map<String, bool> _categoriesRolesCheckbox = {
    'create': false,
    'read': false,
    'update': false,
    'delete': false,
  };
  Map<String, bool> _issueRolesCheckbox = {
    'create': false,
    'read': false,
    'update': false,
    'delete': false,
  };

  GlobalKey get formKey => _formKey;
  TextEditingController get fullNameTextController => _fullNameTextController;
  TextEditingController get emailTextController => _emailTextController;
  TextEditingController get phoneTextController => _phoneTextController;
  TextEditingController get designationTextController =>
      _designationTextController;
  TextEditingController get departmentTextController =>
      _departmentTextController;
  TextEditingController get addressTextController => _addressTextController;
  TextEditingController get passwordTextController => _passwordTextController;
  List<String> get companyList => _companyList;
  String get selectedCompany => _selectedCompany;
  int get selectedCompanyIndex => _companyList.indexOf(_selectedCompany);

  List<String> get roleList => _roleList;
  String get selectedRole => _selectedRole;
  List<String> get genderList => _genderList;
  String get selectedGender => _selectedGender;
  bool get obscure => _obscure;
  List<dynamic> get companies => _companies;

  Map<String, bool> get companyRolesCheckbox => _companyRolesCheckbox;
  Map<String, bool> get userRolesCheckbox => _userRolesCheckbox;
  Map<String, bool> get categoriesRolesCheckbox => _categoriesRolesCheckbox;
  Map<String, bool> get issueRolesCheckbox => _issueRolesCheckbox;

  void toggleCompanyRoleCheckBox(key, value) {
    _companyRolesCheckbox['$key'] = value;
    notifyListeners();
  }

  void toggleUserRoleCheckBox(key, value) {
    _userRolesCheckbox['$key'] = value;
    notifyListeners();
  }

  void toggleCategoriesRoleCheckBox(key, value) {
    _categoriesRolesCheckbox['$key'] = value;
    notifyListeners();
  }

  void toggleIssueRoleCheckBox(key, value) {
    _issueRolesCheckbox['$key'] = value;
    notifyListeners();
  }

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  int getSelectedCompanyIndex() {
    return _companyList.indexOf(_selectedCompany);
  }

  void setSelectedCompany(String value) {
    _selectedCompany = value;
    _indexOfSelectedCompany = _companyList.indexOf(_selectedCompany);
    _selectedCompanyId = _companies[_indexOfSelectedCompany]['_id'];
    print(_selectedCompanyId);
    notifyListeners();
  }

  void setSelectedGender(String value) {
    _selectedGender = value;
    notifyListeners();
  }

  void setSelectedRole(String value, context, Widget roleBottomSheet) {
    _selectedRole = value;
    if (_selectedRole == 'User') {
      showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) => roleBottomSheet,
      );
    }
    notifyListeners();
  }

  void getAllCompanies() async {
    TMSResponse response = await TMSServices.getRequest('company/all');
    final decodedBody = jsonDecode(response.body);

    if (response.statusCode == 200 && decodedBody['companies'] != null) {
      _companies = decodedBody['companies'];
      _companyList =
          _companies
              .map<String>((company) => company['title'].toString())
              .toList();

      if (_companyList.isNotEmpty) {
        _selectedCompany = _companyList[0];
      } else {
        _selectedCompany = '';
      }

      notifyListeners();
    } else {
      print("Failed to fetch companies");
    }
  }

  void onTapAdd(context) async {
    _body['name'] = _fullNameTextController.text.trim();
    _body['email'] = _emailTextController.text.toLowerCase().trim();
    _body['address'] = _addressTextController.text.trim();
    _body['phone'] = _phoneTextController.text.trim();
    _body['gender'] = _selectedGender;
    _body['designation'] = _designationTextController.text.trim();
    _body['department'] = _departmentTextController.text.trim();
    _body['password'] = _passwordTextController.text.trim();
    _body['mainAdminId'] = authProvider.mainAdminId.trim();
    if (authProvider.adminId.trim().isNotEmpty) {
      _body['adminId'] = authProvider.adminId.trim();
    }
    _body['role'] = _selectedRole.trim();
    _body['companyAccess'] = companyRolesCheckbox;
    _body['userAccess'] = userRolesCheckbox;
    _body['categoriesAccess'] = categoriesRolesCheckbox;
    _body['issueAccess'] = issueRolesCheckbox;
    if (issueRolesCheckbox['read'] == true &&
        issueRolesCheckbox['read'] == true &&
        issueRolesCheckbox['update'] == true &&
        issueRolesCheckbox['delete'] == true) {
      _body['canAssignIssue'] = true;
    } else {
      _body['canAssignIssue'] = false;
    }

    print(_selectedCompanyId);
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

      if (_selectedCompanyId.isEmpty) {
        _selectedCompanyId = _companies[_indexOfSelectedCompany]['_id'];
      }

      TMSResponse response = await TMSServices.postRequest(
        'company/user/create/$_selectedCompanyId',
        _body,
      );
      print(response.body);
      final decodedBody = jsonDecode(response.body);
      print(decodedBody);
      if (response.statusCode == 201) {
        NotiService().showNotification(
          title: 'Task Management System',
          body: decodedBody['message'],
        );
        Navigator.pop(context);
        int totAdminUser = decodedBody['updatedUser']['mainTotalAdminUser'];
        int totUser = decodedBody['updatedUser']['mainTotalUser'];
        int totCompany = decodedBody['updatedUser']['mainTotalCompany'];
        int totPost = decodedBody['updatedUser']['mainTotalPost'];
        authProvider.setTotalValues(totAdminUser, totUser, totCompany, totPost);
        clearFrom();
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.adminDashboardRouteName);
      } else {
        Navigator.pop(context);
        NotiService().showNotification(
          title: 'Task Management System',
          body: decodedBody['message'],
        );
      }
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: 'Please fill all the required fields!',
      );
    }
    notifyListeners();
  }

  // Get All Users

  List<dynamic> _users = [];
  List<String> _getUserByRoleList = ['All', 'Admin User', 'User'];
  String _selectedGetUserByRole = 'All';

  List<dynamic> get users => _users;
  List<String> get getUserByRoleList => _getUserByRoleList;
  String get selectedGetUserByRole => _selectedGetUserByRole;

  void setSelectedGetUserByRole(String value) {
    _selectedGetUserByRole = value;
    getAllUsers();
    notifyListeners();
  }

  void getAllUsers() async {
    TMSResponse response = await TMSServices.getRequest(
      'company/user/${authProvider.mainAdminId}?role=${_selectedGetUserByRole.isEmpty ? 'All' : _selectedGetUserByRole}',
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      _users = decodedBody['users'];
    } else {
      _users.clear();
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
    }
    notifyListeners();
  }

  // Edit User

  String _selectedUserId = '';
  bool _isEdit = false;
  bool get isEdit => _isEdit;

  void setControllerValuesOnEdit(int index) {
    getAllCompanies();
    _isEdit = true;
    print('_isEdit = $_isEdit');
    Map<String, dynamic> selectedUser = _users[index];
    _selectedUserId = selectedUser['_id'];
    _fullNameTextController.text = selectedUser['name'];
    _emailTextController.text = selectedUser['email'];
    _phoneTextController.text = selectedUser['phone'];
    _addressTextController.text = selectedUser['address'];
    _designationTextController.text = selectedUser['designation'];
    _departmentTextController.text = selectedUser['department'];
    _selectedGender = selectedUser['gender'];
    _selectedRole = selectedUser['role'];
    _selectedCompany = selectedUser['companyId']['title'];
    notifyListeners();
  }

  void setIsEdit(bool value) {
    _isEdit = value;
    notifyListeners();
  }

  void updateUser(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );
    _body['name'] = _fullNameTextController.text.trim();
    _body['email'] = _emailTextController.text.toLowerCase().trim();
    _body['address'] = _addressTextController.text.trim();
    _body['phone'] = _phoneTextController.text.trim();
    _body['gender'] = _selectedGender;
    _body['companyId'] = _selectedCompanyId;
    _body['designation'] = _designationTextController.text.trim();
    _body['department'] = _departmentTextController.text.trim();
    _body['password'] = _passwordTextController.text.trim();
    _body['mainAdminId'] = authProvider.mainAdminId.trim();
    if (authProvider.adminId.trim().isNotEmpty) {
      _body['adminId'] = authProvider.adminId.trim();
    }
    _body['role'] = _selectedRole.trim();
    _body['companyAccess'] = companyRolesCheckbox;
    _body['userAccess'] = userRolesCheckbox;
    _body['categoriesAccess'] = categoriesRolesCheckbox;
    _body['issueAccess'] = issueRolesCheckbox;
    if (issueRolesCheckbox['read'] == true &&
        issueRolesCheckbox['read'] == true &&
        issueRolesCheckbox['update'] == true &&
        issueRolesCheckbox['delete'] == true) {
      _body['canAssignIssue'] = true;
    } else {
      _body['canAssignIssue'] = false;
    }
    print(_body);
    TMSResponse response = await TMSServices.putRequest(
      'company/user/update/$_selectedUserId',
      _body,
    );
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
    if(response.statusCode == 200){
      clearFrom();
      print('UpdatedUser');
      print(decodedBody);
      authProvider.setTotalAdminAndUser(decodedBody['totalAdmins'], decodedBody['totalUsers']);
      _isEdit = false;
      NotiService().showNotification(title: 'Task Management System', body: decodedBody['message'],);
      getAllUsers();
      Navigator.pop(context);
      GoRouter.of(context).pushReplacementNamed(AppRouteName.adminDashboardRouteName);
    }else{
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      Navigator.pop(context);
    }
    notifyListeners();
  }

  // Delete User
  String _deleteUserId = '';

  void setUserDeleteId(String userId) {
    _deleteUserId = userId;
    notifyListeners();
  }

  void deleteUser(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );
    TMSResponse response = await TMSServices.deleteRequest(
      'company/user/delete/$_deleteUserId',
    );
    final decodedBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      authProvider.setTotalAdminAndUser(decodedBody['totalAdmins'], decodedBody['totalUsers']);
      getAllUsers();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      Navigator.pop(context);
    }
    notifyListeners();
  }

  void clearFrom() {
    _fullNameTextController.clear();
    _emailTextController.clear();
    _addressTextController.clear();
    _designationTextController.clear();
    _departmentTextController.clear();
    _passwordTextController.clear();
    _selectedGender = 'Male';
    _selectedRole = 'Admin';
    _phoneTextController.clear();
    _selectedCompany = _companyList.isNotEmpty ? _companyList[0] : '';
    _indexOfSelectedCompany = 0;
    _selectedCompanyId = _companies.isNotEmpty ? _companies[0]['_id'] : '';
    _companyRolesCheckbox = {
      'create': false,
      'read': false,
      'update': false,
      'delete': false,
    };
    _userRolesCheckbox = {
      'create': false,
      'read': false,
      'update': false,
      'delete': false,
    };
    _categoriesRolesCheckbox = {
      'create': false,
      'read': false,
      'update': false,
      'delete': false,
    };
    _issueRolesCheckbox = {
      'create': false,
      'read': false,
      'update': false,
      'delete': false,
    };
    _obscure = true;
    _isEdit = false;
    _body.clear();
    _formKey.currentState?.reset();
    _formKey.currentState?.validate();
    _formKey.currentState?.save();
    notifyListeners();
  }
}

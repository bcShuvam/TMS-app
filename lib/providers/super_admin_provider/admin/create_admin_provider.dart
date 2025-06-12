import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/routes/app_route_name.dart';

import '../../../services/task_management_system_services.dart';
import '../../../themes/custom_colors.dart';
import '../../auth_provider.dart';

class CreateUpdateAdminProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  CreateUpdateAdminProvider(this.authProvider);

  final _createAdminFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _body = {};
  List<dynamic> _adminList = [];
  int _totalAdmin = 0;
  List<dynamic> _subscription = [];
  List<dynamic> _subscriptionList = [];
  List<String> _assignSubscription = [];
  String _selectedSubscription = '';
  String _selectedSubscriptionId = '';
  String _selectedAdminId = '';
  DateTime? _picked;
  int _durationInMonths = 0;
  List<String> _genderList = ['Male', 'Female', 'Others'];
  String _selectedGender = 'Male';
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _activationDateTextController = TextEditingController();
  TextEditingController _expirationDateTextController = TextEditingController();
  TextEditingController _assignSubscriptionTextController = TextEditingController();
  TextEditingController _imageTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  bool _isEditAdmin = false;
  bool _obscure = true;

  // Getters
  String get selectedAdminId => _selectedAdminId;
  List<dynamic> get adminList => _adminList;
  int get totalAdmin => _totalAdmin;
  GlobalKey<FormState> get createAdminFormKey => _createAdminFormKey;
  List<String> get assignSubscription => _assignSubscription;
  String get selectedSubscription => _selectedSubscription;
  List<String> get genderList => _genderList;
  String get selectedGender => _selectedGender;
  TextEditingController get addressTextController => _addressTextController;
  TextEditingController get usernameTextController => _usernameTextController;
  TextEditingController get emailTextController => _emailTextController;
  TextEditingController get phoneNumberTextController => _phoneNumberTextController;
  TextEditingController get assignSubscriptionTextController => _assignSubscriptionTextController;
  TextEditingController get imageTextController => _imageTextController;
  TextEditingController get passwordTextController => _passwordTextController;
  TextEditingController get activationDateTextController => _activationDateTextController;
  TextEditingController get expirationDateTextController => _expirationDateTextController;
  bool get isEditAdmin => _isEditAdmin;
  bool get obscure => _obscure;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  void setSelectedUserId(String userId) {
    _selectedAdminId = userId;
    notifyListeners();
  }

  void getSubscriptionsName() async {
    TMSResponse response = await TMSServices.getRequest('subscription/name');
    final body = jsonDecode(response.body);
    _subscriptionList = body['subscriptionName'];
    if (response.statusCode == 200) {
      _assignSubscription = _subscriptionList.map<String>((sub) => sub['name']).toList();
      _selectedSubscription = _subscriptionList.isNotEmpty ? _subscriptionList[0]['name'] : '';
    }
    notifyListeners();
  }

  void getEditSubscriptionName() async {
    TMSResponse response = await TMSServices.getRequest('subscription/name');
    final body = jsonDecode(response.body);
    _subscriptionList = body['subscriptionName'];
    if (response.statusCode == 200) {
      _assignSubscription = _subscriptionList.map<String>((sub) => sub['name']).toList();
    }
    notifyListeners();
  }

  int _editAdminIndex = 0;
  int get editAdminIndex => _editAdminIndex;

  void setEditAdminIndex(int index) {
    _editAdminIndex = index;
    notifyListeners();
  }

  void getAllSubscriptions() async {
    TMSResponse response = await TMSServices.getRequest('subscription/all');
    final body = jsonDecode(response.body);
    _subscription = body['subscriptions'];
    // _subscriptionList = body['subscriptionName'];
    if (response.statusCode == 200) {
      _assignSubscription = _subscription.map<String>((sub) => sub['name']).toList();
      for(int i = 0; i < _subscription.length; i++) {
        // print('${_subscription[i]['_id']} == ${_adminList[_editAdminIndex]['subscriptionId']['_id']} == ${_subscription[i]['_id'] == _adminList[_editAdminIndex]['subscriptionId']['_id']}');
        if(_subscription[i]['_id'] == _adminList[_editAdminIndex]['subscriptionId']['_id']){
          _selectedSubscriptionId = _adminList[_editAdminIndex]['subscriptionId']['_id'];
          _selectedSubscription = _adminList[_editAdminIndex]['subscriptionId']['name'];
          print('Subscription found: ${_subscription[i]}');
          break;
        }
      }
    } else {
      NotiService().showNotification(title: 'Task Management System', body: body['message']);
    }
    notifyListeners();
  }

  void getAdmins(context) async {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: CircularProgressIndicator(color: CustomColors.primaryColor),
      ),
    );
    TMSResponse response = await TMSServices.getRequest('admin/all');
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _adminList = body['admins'];
      _totalAdmin = _adminList.length;
      Navigator.pop(context);
      GoRouter.of(context).pushNamed(AppRouteName.superAdminManageAdminRouteName);
    } else {
      NotiService().showNotification(title: 'Failed to fetch!', body: body['message']);
      Navigator.pop(context);
    }
    notifyListeners();
  }

  void setControllerValue() {
    // getSubscriptionsName();
    // getAllSubscriptions(index);
    _selectedAdminId = _adminList[_editAdminIndex]['_id'];
    _usernameTextController.text = _adminList[_editAdminIndex]['name'];
    _emailTextController.text = _adminList[_editAdminIndex]['email'];
    _phoneNumberTextController.text = _adminList[_editAdminIndex]['phone'];
    // _selectedSubscription = _adminList[index]['subscriptionId']['name'];
    _addressTextController.text = _adminList[_editAdminIndex]['address'] ?? '';
    _activationDateTextController.text = _adminList[_editAdminIndex]['activationDate'];
    _expirationDateTextController.text = _adminList[_editAdminIndex]['expirationDate'];
    _selectedGender = _adminList[_editAdminIndex]['gender'];

    // if (_isEditAdmin) {
    //   for (int i = 0; i < _subscriptionList.length; i++) {
    //     if (_subscriptionList[i]['name'] == _selectedSubscription) {
    //       _selectedSubscriptionId = _subscriptionList[i]['_id'];
    //       _durationInMonths = _subscriptionList[i]['duration'];
    //       break;
    //     }
    //   }
    // }
    notifyListeners();
  }

  void setIsEditAdmin(bool value) {
    _isEditAdmin = value;
    notifyListeners();
  }

  void setSelectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setSelectedSubscription(String subName) {
    _selectedSubscription = subName;
    final selectedSub = _subscriptionList.firstWhere(
          (sub) => sub['name'] == subName,
      orElse: () => null,
    );
    print(_selectedSubscription);
    print(selectedSub);

    if (selectedSub != null) {
      _selectedSubscriptionId = selectedSub['_id'];
      _durationInMonths = selectedSub['duration'];

      if (_picked != null) {
        final expirationDate = DateTime(_picked!.year, _picked!.month + _durationInMonths, _picked!.day);
        _expirationDateTextController.text =
        '${expirationDate.year}-${expirationDate.month}-${expirationDate.day}';
      }
    } else {
      _selectedSubscriptionId = '';
      _durationInMonths = 0;
    }
    notifyListeners();
  }

  void resetForm() {
    _usernameTextController.clear();
    _emailTextController.clear();
    _phoneNumberTextController.clear();
    _assignSubscriptionTextController.clear();
    _imageTextController.clear();
    _passwordTextController.clear();
    _assignSubscription.clear();
    _subscriptionList.clear();
    _activationDateTextController.clear();
    _expirationDateTextController.clear();
    _addressTextController.clear();
    _selectedGender = 'Male';
    _durationInMonths = 0;
    _selectedSubscription = '';
    _body.clear();
  }

  @override
  void dispose() {
    _usernameTextController.dispose();
    _emailTextController.dispose();
    _phoneNumberTextController.dispose();
    _assignSubscriptionTextController.dispose();
    _imageTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2099),
    );

    if (_picked == null) return;

    _activationDateTextController.text =
    '${_picked!.year}-${_picked!.month}-${_picked!.day}';

    if (_durationInMonths == 0 && _subscriptionList.isNotEmpty) {
      _durationInMonths = _subscriptionList[0]['duration'];
      _selectedSubscriptionId = _subscriptionList[0]['_id'];
    }

    final expirationDate = DateTime(_picked!.year, _picked!.month + _durationInMonths, _picked!.day);
    _expirationDateTextController.text =
    '${expirationDate.year}-${expirationDate.month}-${expirationDate.day}';

    notifyListeners();
  }

  void onTapCreateAdmin(context) async {
    if (_createAdminFormKey.currentState?.validate() ?? false) {
      _body['name'] = _usernameTextController.text.trim();
      _body['email'] = _emailTextController.text.toLowerCase();
      _body['phone'] = _phoneNumberTextController.text.trim();
      _body['address'] = _addressTextController.text.trim();
      _body['gender'] = _selectedGender;
      _body['password'] = _passwordTextController.text.trim();
      _body['subscriptionId'] = _selectedSubscriptionId.trim();
      _body['role'] = 'Admin';
      _body['isMainAdmin'] = true;
      _body['activationDate'] = _activationDateTextController.text.trim();
      _body['expirationDate'] = _expirationDateTextController.text.trim();

      showDialog(
        context: context,
        builder: (_) => Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        ),
      );

      TMSResponse response =
      await TMSServices.postRequest('auth/register/admin', _body);
      Navigator.pop(context);
      final decodedBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        authProvider.setEarningsAndSubscriptions(
          decodedBody['superAdmin']['totalEarnings'].toString(),
          decodedBody['superAdmin']['totalSales'].toString(),
        );
        NotiService().showNotification(
            title: 'Task Management System',
            body: 'New Admin Created Successfully!');
        GoRouter.of(context).pushReplacementNamed(
            AppRouteName.superAdminDashboardRouteName);
        resetForm();
      } else {
        NotiService().showNotification(
            title: 'Task Management System', body: decodedBody['message']);
      }
    } else {
      NotiService().showNotification(
          title: 'Task Management System',
          body: 'Please fill all the required fields!');
    }
  }

  void onTapUpdateAdmin(context) async {
    getEditSubscriptionName();
    if (_createAdminFormKey.currentState?.validate() ?? false) {
      _body['name'] = _usernameTextController.text.trim();
      _body['email'] = _emailTextController.text.toLowerCase();
      _body['phone'] = _phoneNumberTextController.text.trim();
      _body['password'] = _passwordTextController.text.trim();
      _body['subscriptionId'] = _selectedSubscriptionId;
      _body['role'] = 'Admin';
      _body['activationDate'] = _activationDateTextController.text.trim();
      _body['expirationDate'] = _expirationDateTextController.text.trim();

      TMSResponse response = await TMSServices.putRequest(
        'admin/update?id=$_selectedAdminId',
        _body,
      );
      final decodedBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        NotiService().showNotification(
            title: 'Task Management System', body: decodedBody['message']);
        GoRouter.of(context)
            .pushReplacementNamed(AppRouteName.superAdminDashboardRouteName);
        resetForm();
      } else {
        NotiService().showNotification(
            title: 'Task Management System', body: decodedBody['message']);
      }
    } else {
      NotiService().showNotification(
          title: 'Task Management System', body: 'Something went wrong!');
    }
  }

  String _selectedDeleteAdminId = '';

  void setSelectedDeleteAdminId(String id) {
    _selectedDeleteAdminId = id;
    notifyListeners();
  }

  void deleteAdmin(context) async {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: CircularProgressIndicator(color: CustomColors.primaryColor),
      ),
    );

    TMSResponse response =
    await TMSServices.deleteRequest('admin/delete/$_selectedDeleteAdminId');
    final decodedBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      NotiService().showNotification(
          title: 'Task Management System', body: decodedBody['message']);
      _selectedDeleteAdminId = '';
      Navigator.pop(context);
      Navigator.pop(context);
      getAdmins(context);
    } else {
      NotiService().showNotification(
          title: 'Task Management System', body: decodedBody['message']);
      Navigator.pop(context);
    }
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/services/task_management_system_services.dart';
import 'package:flutter/material.dart';
import 'package:task_management_system/providers/auth_provider.dart';

import '../../../themes/custom_colors.dart';

class IssueProvider extends ChangeNotifier {
  final AuthProvider authProvider;

  IssueProvider(this.authProvider);

  void testCallAuthInfo() {
    authProvider.printUserInfo(); // ✅ This works!
  }

  Map<String,dynamic> _body = {};
  List<String> _assignIssueList = ['Unassigned', 'Individual', 'Self'];

  ////////////////////// Post Feed //////////////////////
  List<dynamic> _postFeeds = [];

  // Post Feed Getters
  List<dynamic> get postFeeds => _postFeeds;

  // Post Feed Setters

  ////////////////////// Post Feed //////////////////////
  List<dynamic> _myIssues = [];

  // Post Feed Getters
  List<dynamic> get myIssues => _myIssues;

  // Post Feed Setters


  // Post Feed Functions

  void getIssues() async {
    TMSResponse response = await TMSServices.getRequest('issue/company/${authProvider.companyId}');
    final decodedBody = jsonDecode(response.body)['issues'];
    _postFeeds = decodedBody;
    notifyListeners();
  }

  void getMyIssues() async {
    TMSResponse response = await TMSServices.getRequest('issue/my/${authProvider.userId}');
    final decodedBody = jsonDecode(response.body)['issues'];
    _myIssues = decodedBody;
    print(_myIssues);
    notifyListeners();
  }

  ////////////////////// Issue Detail //////////////////////
  Map<String, dynamic> _selectedIssue = {};
  TextEditingController _commentTextController = TextEditingController();
  final _applyIssueFormKey = GlobalKey<FormState>();

  Map<String,dynamic> get selectedIssue => _selectedIssue;
  TextEditingController get commentTextController => _commentTextController;
  GlobalKey get applyIssueFormKey => _applyIssueFormKey;

  ////////////////////// Issue Create //////////////////////
  final _createFormKey = GlobalKey<FormState>();
  List<dynamic> _categories = [];
  List<String> _categoriesList = [];
  String _selectedCategoryName = '';
  List<dynamic> _subCategories = [];
  List<String> _subCategoriesList = [];
  String _selectedSubCategoryName = '';
  String _assignedToValue = 'Unassigned';
  List<dynamic> _userSearchResult = [];
  List<dynamic> _userList = [];
  TextEditingController _descriptionTextController = TextEditingController();
  TextEditingController _assignedToUserNameTextController = TextEditingController();
  TextEditingController _imageFileTextController = TextEditingController();
  TextEditingController _audioFileTextController = TextEditingController();
  TextEditingController _deadLineDateTimeTextController = TextEditingController();
  String _selectedAssignedToUserId = '';
  String _deadLineDate = '';
  String _deadLineTime = '';
  TextEditingController _searchByNameController = TextEditingController();

  GlobalKey get createFormKey => _createFormKey;
  List<String> get categoriesList => _categoriesList;
  String get selectedCategoryName => _selectedCategoryName;
  List<String> get subCategoriesList => _subCategoriesList;
  String get selectedSubCategoryName => _selectedSubCategoryName;
  List<String> get assignIssueList => _assignIssueList;
  String get assignedToValue => _assignedToValue;
  List<dynamic> get userSearchResult => _userSearchResult;
  List<dynamic> get userList => _userList;
  TextEditingController get descriptionTextController => _descriptionTextController;
  TextEditingController get assignedToUserNameTextController => _assignedToUserNameTextController;
  TextEditingController get imageFileTextController => _imageFileTextController;
  TextEditingController get audioFileTextController => _audioFileTextController;
  TextEditingController get deadLineDateTimeTextController => _deadLineDateTimeTextController;
  TextEditingController get searchByNameController => _searchByNameController;

  int get selectedCategoryIndex =>
      _categoriesList.indexOf(_selectedCategoryName);

  int get selectedSubCategoryIndex =>
      _subCategoriesList.indexOf(_selectedSubCategoryName);

  String get _selectedCategoryId =>
      selectedCategoryIndex >= 0 ? _categories[selectedCategoryIndex]['_id'] : '';

  String get _selectedSubCategoryId =>
      selectedSubCategoryIndex >= 0 ? _subCategories[selectedSubCategoryIndex]['_id'] : '';

  void setSelectedAssignedToUserId(String userId, String userName) {
    _selectedAssignedToUserId = userId;
    _assignedToUserNameTextController.text = userName;
    print(_assignedToUserNameTextController.value.text + ' ' + _selectedAssignedToUserId);
    notifyListeners();
  }

  void setImage(String imageName){
    _imageFileTextController.text = imageName;
    print(_imageFileTextController);
    notifyListeners();
  }

  void setAudio(String audioName){
    _audioFileTextController.text = audioName;
    print(_imageFileTextController);
    notifyListeners();
  }

  void clearIssueForm(){
    _descriptionTextController.clear();
    _assignedToUserNameTextController.clear();
    _imageFileTextController.clear();
    _audioFileTextController.clear();
    _deadLineDateTimeTextController.clear();
    _deadLineDate = '';
    _deadLineTime = '';
  }

  void getCategories() async {
    TMSResponse response = await TMSServices.getRequest('category/${authProvider.mainAdminId}');
    print(response.body);
    final decodedBody = jsonDecode(response.body);
    _categories = decodedBody['categories'];
    _categoriesList = _categories.map((cat) => cat['categoryName'].toString()).toList();

    if (_categoriesList.isNotEmpty) {
      _selectedCategoryName = _categoriesList[0];
      getSubCategories(_categories[0]['_id']);
    }
    notifyListeners();
  }

  void applyForIssue(context) async {
    _body.clear();
    _body['assignedUserId'] = authProvider.userId;
    _body['comment'] = _commentTextController.value.text.trim();
    if(_applyIssueFormKey.currentState != null && _applyIssueFormKey.currentState!.validate()){
    TMSResponse response = await TMSServices.putRequest('issue/apply/${_selectedIssue['_id']}', _body);
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
    if (response.statusCode == 200) {
      NotiService().showNotification(title: 'Apply Issue Successful', body: decodedBody['message']);
      Navigator.pop(context);
      GoRouter.of(context).pushReplacementNamed(AppRouteName.userDashboardRouteName);
    } else {
      NotiService().showNotification(title: 'Apply Issue Failed', body: decodedBody['message']);
    }
  }else{
      NotiService().showNotification(title: 'Apply Issue Failed', body: 'Comment is required.');
    }
    notifyListeners();
  }

  void getSubCategories(String id) async {
    TMSResponse response = await TMSServices.getRequest('subcategory/$id');
    final decodedBody = jsonDecode(response.body);
    _subCategories = decodedBody['subcategories'];
    _subCategoriesList =
        _subCategories.map((subCat) => subCat['subCategoryName'].toString()).toList();

    if (_subCategoriesList.isNotEmpty) {
      _selectedSubCategoryName = _subCategoriesList[0];
    }

    print(_subCategoriesList);

    notifyListeners();
  }

  void deleteIssue(context) async {
    TMSResponse response = await TMSServices.deleteRequest('issue/delete/${_selectedIssue['_id']}');
    print(response.body);
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      GoRouter.of(context).pushReplacementNamed(AppRouteName.userDashboardRouteName);
      NotiService().showNotification(title: 'Delete Issue Successful', body: decodedBody['message']);
      getMyIssues();
    } else {
      Navigator.pop(context);
      NotiService().showNotification(title: 'Delete Issue Failed', body: decodedBody['message']);
    }
    notifyListeners();
  }

  void createIssue(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );

    _body['companyId'] = authProvider.companyId;
    _body['mainAdminId'] = authProvider.mainAdminId;
    _body['categoryId'] = _selectedCategoryId;
    _body['subCategoryId'] = _selectedSubCategoryId;
    _body['createdById'] = authProvider.userId;
    _body['issueDetails'] = _descriptionTextController.value.text.trim();
    _body['assignedUserId'] = _selectedAssignedToUserId;
    _body['issueDeadlineDateTime'] = _deadLineDateTimeTextController.value.text.trim();
    print(_body);
    if(_createFormKey.currentState != null && _createFormKey.currentState!.validate()){
      TMSResponse response = await TMSServices.postRequest('issue/create/${authProvider.userId}', _body);
      final decodedBody = jsonDecode(response.body);
      if(response.statusCode == 201){
        print(response.statusCode);
        print(response.body);
        clearIssueForm();
        GoRouter.of(context).pushReplacementNamed(AppRouteName.userDashboardRouteName);
        Navigator.pop(context);
        NotiService().showNotification(title: 'Create Issue Successful', body: decodedBody['message']);
      }else{
        print(response.statusCode);
        print(response.body);
        Navigator.pop(context);
        NotiService().showNotification(title: 'Create Issue Failed', body: decodedBody['message']);
      }
    }else{
      Navigator.pop(context);
      NotiService().showNotification(title: 'Create Issue Failed', body: 'Please fill all the required fields.');
    }
    Navigator.pop(context);
    notifyListeners();
  }

  void getAllCompanyUsers() async {
    TMSResponse response = await TMSServices.getRequest('company/usernames/${authProvider.companyId}');
    final decodedBody = jsonDecode(response.body);
    _userList = decodedBody;
    _userSearchResult = _userList;
    print(_userList);
    notifyListeners();
  }

  void updateSelectedCategoryName(String value) {
    _selectedCategoryName = value;
    getSubCategories(_selectedCategoryId);
    // print(selectedCategoryIndex);
    notifyListeners();
  }

  void updateSelectedSubCategoryName(String value) {
    _selectedSubCategoryName = value;
    print(_selectedSubCategoryId);
    notifyListeners();
  }

  void updateAssignedTo(String value) {
    _assignedToValue = value;
    notifyListeners();
  }

  Future<void> selectDate(context) async {
    print('Select date from');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2099),
    );
    if (picked == null) {
      return;
    } else {
      _deadLineDate = '${picked.year}-${picked.month}-${picked.day}';
      selectTime(context);
    }
    print(_deadLineDateTimeTextController.value.text);
    notifyListeners();
  }

  Future<void> selectTime(context) async {
    print('Select date from');
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked == null) {
      return;
    } else {
      _deadLineTime = '${picked.hour}:${picked.minute}';
    }
    _deadLineDateTimeTextController.text = '$_deadLineDate $_deadLineTime';
    print(_deadLineTime);
    notifyListeners();
  }

  Map<String, dynamic> get selectedCategory =>
      selectedCategoryIndex >= 0 ? _categories[selectedCategoryIndex] : {};

  void searchUserName(String enteredKeyWord, List<dynamic> pocNames) {
    _userSearchResult = pocNames;
    if (enteredKeyWord.isEmpty) {
      _userSearchResult = pocNames;
    } else {
      _userSearchResult = pocNames
          .where((poc) => poc['username']
          .toString()
          .toLowerCase()
          .contains(enteredKeyWord.toLowerCase()))
          .toList();
    }
    print('Search Result = $_userSearchResult');
    notifyListeners();
  }

  void setSelectedIssue(int index, context){
    _selectedIssue = _postFeeds[index];
    print(_selectedIssue);
    GoRouter.of(context).pushNamed(AppRouteName.userIssueDetailRouteName);
    notifyListeners();
  }
}

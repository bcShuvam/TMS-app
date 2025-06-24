import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/providers/auth_provider.dart';

import '../../../services/task_management_system_services.dart';
import '../../../themes/custom_colors.dart';

class CategoryProvider extends ChangeNotifier {
  AuthProvider authProvider;
  CategoryProvider(this.authProvider);

  bool _isEditCat = false;
  bool _isEditSubCat = false;
  bool get isEditCat => _isEditCat;
  bool get isEditSubCat => _isEditSubCat;

  final _formKey = GlobalKey<FormState>();
  final _subCatFormKey = GlobalKey<FormState>();
  TextEditingController _categoryNameTextController = TextEditingController();
  TextEditingController _categoryDescriptionTextController =
      TextEditingController();
  TextEditingController _subCategoryNameTextController = TextEditingController();
  TextEditingController _subCategoryDescriptionTextController =
      TextEditingController();
  Map<String, dynamic> _body = {};

  GlobalKey get formKey => _formKey;
  GlobalKey get subCatFormKey => _subCatFormKey;
  TextEditingController get categoryNameTextController =>
      _categoryNameTextController;
  TextEditingController get categoryDescriptionTextController =>
      _categoryDescriptionTextController;
  TextEditingController get subCategoryNameTextController =>
      _subCategoryNameTextController;
  TextEditingController get subCategoryDescriptionTextController =>
      _subCategoryDescriptionTextController;

  //// Companies
  List<String> _companyList = [];
  String _selectedCompany = '';
  List<dynamic> _companies = [];
  int _indexOfSelectedCompany = 0;
  String _selectedCompanyId = '';

  List<dynamic> get companies => _companies;
  List<String> get companyList => _companyList;
  String get selectedCompany => _selectedCompany;
  int get selectedCompanyIndex => _companyList.indexOf(_selectedCompany);

  ///// Categories
  List<dynamic> _category = [];
  List<String> _categoryNames = [];
  String _selectedCategoryName = '';

  List<dynamic> get category => _category;
  List<String> get categoryNames => _categoryNames;
  String get selectedCategoryName => _selectedCategoryName;

  ///// Sub Categories
  List<dynamic> _subCategories = [];
  List<String> _subCategoriesList = [];

  List<dynamic> get subCategories => _subCategories;
  List<String> get subCategoriesList => _subCategoriesList;

  void setSelectedCompany(String value) {
    _selectedCompany = value;
    _indexOfSelectedCompany = _companyList.indexOf(_selectedCompany);
    _selectedCompanyId = _companies[_indexOfSelectedCompany]['_id'];
    print(_selectedCompanyId);
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

  int get selectedCategoryIndex =>
      _categoryNames.indexOf(_selectedCategoryName);

  String get _selectedCategoryId =>
      selectedCategoryIndex >= 0 ? _category[selectedCategoryIndex]['_id'] : '';

  void updateSelectedCategoryName(String value) {
    _selectedCategoryName = value;
    getSubCategories(_selectedCategoryId);
    // print(selectedCategoryIndex);
    notifyListeners();
  }

  void getAllCategories() async {
    TMSResponse response = await TMSServices.getRequest(
      'category/${authProvider.mainAdminId}',
    );
    final decodedBody = jsonDecode(response.body);
    _category = decodedBody['categories'];
    print(decodedBody);
    print(decodedBody.runtimeType);
    _categoryNames =
        _category.map<String>((cat) => cat['categoryName'].toString()).toList();
    if (_categoryNames.isNotEmpty) {
      _selectedCategoryName = _categoryNames[0];
      getSubCategories(_category[0]['_id']);
    }
    notifyListeners();
  }

  Map<String, dynamic> get selectedCategory =>
      selectedCategoryIndex >= 0 ? _category[selectedCategoryIndex] : {};

  void getSubCategories(String id) async {
    TMSResponse response = await TMSServices.getRequest('subcategory/$id');
    final decodedBody = jsonDecode(response.body);
    _subCategories = decodedBody['subcategories'];
    _subCategoriesList =
        _subCategories
            .map((subCat) => subCat['subCategoryName'].toString())
            .toList();

    print(_subCategoriesList);

    notifyListeners();
  }

  void setSelectedCategory(String value) {
    _selectedCategoryName = value;
    notifyListeners();
  }

  ////// category

  void onTapCreate(context) async {
    _body['categoryName'] = _categoryNameTextController.text.trim();
    _body['description'] = _categoryDescriptionTextController.text.trim();
    if (_selectedCompanyId.isEmpty) {
      _selectedCompanyId = _companies[_indexOfSelectedCompany]['_id'];
    }
    _body['companyId'] = _selectedCompanyId;
    _body['adminId'] = authProvider.mainAdminId;
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
        'category/create',
        _body,
      );
      final decodedBody = jsonDecode(response.body);
      print(decodedBody);
      if (response.statusCode == 201) {
        NotiService().showNotification(
          title: 'Task Management System',
          body: decodedBody['message'],
        );
        Navigator.pop(context);
        Navigator.pop(context);
        clearForm();
        getAllCategories();
      } else {
        NotiService().showNotification(
          title: 'Task Management System',
          body: decodedBody['message'],
        );
        Navigator.pop(context);
      }
    } else {
      NotiService().showNotification(
        title: 'Create Category',
        body: 'Please fill all the required fields!',
      );
    }
    notifyListeners();
  }

  void clearForm() {
    _categoryNameTextController.clear();
    _categoryDescriptionTextController.clear();
    _isEditCat = false;
    _isEditSubCat = false;
    notifyListeners();
  }

  void setEditCatIndex(int index, bool value) {
    _isEditCat = value;
    _categoryNameTextController.text = _category[index]['categoryName'];
    _categoryDescriptionTextController.text = _category[index]['description'];
    _selectedCompanyId = _category[index]['companyId'];
    notifyListeners();
  }

  void getCategories() async {
    TMSResponse response = await TMSServices.getRequest(
      'category/${authProvider.mainAdminId}',
    );
    print(response.body);
    final decodedBody = jsonDecode(response.body);
    _category = decodedBody['categories'];
    _categoryNames =
        _category.map((cat) => cat['categoryName'].toString()).toList();

    if (_categoryNames.isNotEmpty) {
      _selectedCategoryName = _category[0];
      getSubCategories(_category[0]['_id']);
    }
    notifyListeners();
  }

  void deleteCategory(String categoryId, context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );
    TMSResponse response = await TMSServices.deleteRequest(
      'category/delete/$categoryId',
    );
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
    if (response.statusCode == 200) {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      getAllCategories();
      Navigator.pop(context);
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
    }
    notifyListeners();
  }

  String _selectedCatId = '';

  void setCatControllerValues(Map<String, dynamic> cat, bool isEditCat) {
    _isEditCat = isEditCat;
    _selectedCatId = cat['_id'];
    _categoryNameTextController.text = cat['categoryName'];
    _categoryDescriptionTextController.text = cat['description'];
    notifyListeners();
  }

  void updateCategory(context) async {
    _body['categoryName'] = _categoryNameTextController.text.trim();
    _body['description'] = _categoryDescriptionTextController.text.trim();
    _body['companyId'] = _selectedCompanyId;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );

    TMSResponse response = await TMSServices.putRequest(
      'category/update/$_selectedCatId',
      _body,
    );
    final decodedBody = jsonDecode(response.body);
    if( response.statusCode == 200) {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      Navigator.pop(context);
      Navigator.pop(context);
      clearForm();
      getAllCategories();
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      Navigator.pop(context);
    }
  }

  ///// Sub Categories
  void createSubCategory(context) async {
    _body['subCategoryName'] = _subCategoryNameTextController.text.trim();
    _body['description'] = _subCategoryNameTextController.text.trim();
    _body['categoryId'] = _selectedCategoryId;
    _body['adminId'] = authProvider.mainAdminId;
    _body['companyId'] = _category[selectedCategoryIndex]['companyId'];
    print(_body);

    if (_subCatFormKey.currentState != null &&
        _subCatFormKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.primaryColor),
          );
        },
      );
      TMSResponse response = await TMSServices.postRequest(
        'subcategory/create',
        _body,
      );
      final decodedBody = jsonDecode(response.body);
      print(decodedBody);
      if (response.statusCode == 201) {
        NotiService().showNotification(
          title: 'Task Management System',
          body: decodedBody['message'],
        );
        Navigator.pop(context);
        Navigator.pop(context);
        clearForm();
        getSubCategories(_selectedCategoryId);
      } else {
        NotiService().showNotification(
          title: 'Task Management System',
          body: decodedBody['message'],
        );
        Navigator.pop(context);
      }
    } else {
      NotiService().showNotification(
        title: 'Create Sub Category',
        body: 'Please fill all the required fields!',
      );
    }
    notifyListeners();
  }

  String _selectedSubCatId = '';

  void setSubCatControllerValues(Map<String, dynamic> subCat, bool isEditSubCat) {
    _isEditSubCat = isEditSubCat;
    print(_isEditSubCat);
    print(subCat);
    _selectedSubCatId = subCat['_id'];
    _subCategoryNameTextController.text = subCat['subCategoryName'];
    _subCategoryDescriptionTextController.text = subCat['description'];
    notifyListeners();
  }

  void updateSubCategory(context) async {
    _body['subCategoryName'] = _subCategoryNameTextController.text.trim();
    _body['description'] = _subCategoryDescriptionTextController.text.trim();
    _body['companyId'] = _selectedCompanyId;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );

    TMSResponse response = await TMSServices.putRequest(
      'subcategory/update/$_selectedSubCatId',
      _body,
    );
    final decodedBody = jsonDecode(response.body);
    if( response.statusCode == 200) {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      Navigator.pop(context);
      Navigator.pop(context);
      clearForm();
      getSubCategories(_selectedCategoryId);
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      Navigator.pop(context);
    }
  }

  void deleteSubCategory(String subCategoryId, context) async {
    print(subCategoryId);
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        );
      },
    );
    TMSResponse response = await TMSServices.deleteRequest(
      'subcategory/delete/$subCategoryId',
    );
    final decodedBody = jsonDecode(response.body);
    print(decodedBody);
    if (response.statusCode == 200) {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
      getSubCategories(_selectedCategoryId);
      Navigator.pop(context);
    } else {
      NotiService().showNotification(
        title: 'Task Management System',
        body: decodedBody['message'],
      );
    }
    notifyListeners();
  }
}

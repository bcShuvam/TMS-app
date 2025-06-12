import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/admin_provider/user/user_provider.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/button/custom_elevated_button.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/dropdown/custom_dropdown.dart';
import 'package:task_management_system/widgets/text_from_field/custom_text_form_field.dart';

import '../../../routes/app_route_name.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/texts/custom_text.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  UserProvider? _userProvider;
  
  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'User',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        _userProvider!.setIsEdit(false);
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.adminDashboardRouteName);
      },
    );
  }

  Widget _body() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Center(
          child: SingleChildScrollView(
            child: CustomContainer(
              verticalMargin: 32,
              child: Form(
                key: userProvider.formKey,
                child: Column(
                  children: [
                    CustomText(text: 'Add new user', isHeading: true),
                    const SizedBox(height: 24),
                    CustomTextFromField(
                      controller: userProvider.fullNameTextController,
                      labelText: 'Full Name *',
                      validator: (value) {
                        return value!.isEmpty ? 'Full Name is required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: userProvider.emailTextController,
                      labelText: 'Email *',
                      validator: (value) {
                        return value!.isEmpty ? 'Email is required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: userProvider.phoneTextController,
                      labelText: 'Phone *',
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Phone is required'
                            : value.length < 10
                            ? 'Contact number must be 10 character long'
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: userProvider.addressTextController,
                      labelText: 'Address *',
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Address is required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      labelText: 'Gender *',
                      items: userProvider.genderList,
                      value: userProvider.selectedGender,
                      onChanged:
                          (newValue) => userProvider.setSelectedGender(newValue!),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: userProvider.departmentTextController,
                      labelText: 'Department *',
                      validator: (value) {
                        return value!.isEmpty ? 'Department is required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: userProvider.designationTextController,
                      labelText: 'Designation *',
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Designation is required'
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      labelText: 'Company *',
                      items: userProvider.companyList,
                      value: userProvider.selectedCompany,
                      onChanged:
                          (newValue) =>
                              userProvider.setSelectedCompany(newValue!),
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      labelText: 'Role *',
                      items: userProvider.roleList,
                      value: userProvider.selectedRole,
                      onChanged:
                          (newValue) => userProvider.setSelectedRole(
                            newValue!,
                            context,
                            _rolesBottomSheet(),
                          ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      obscure: userProvider.obscure,
                      controller: userProvider.passwordTextController,
                      labelText: 'Password *',
                      applySuffixIcon: true,
                      suffixIcon: InkWell(
                        onTap: () {
                          userProvider.toggleObscure();
                        },
                        child: Icon(
                          userProvider.obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Password is required'
                            : value.length < 8
                            ? 'Password length must be greater than 8'
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      onPressed: () {
                        if(userProvider.isEdit){
                          userProvider.updateUser(context);
                        }else{
                          userProvider.onTapAdd(context);
                        }
                      },
                      width: 1,
                      height: 50,
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(text: userProvider.isEdit == false ? 'Add' : 'Update', isSubHeading: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _rolesBottomSheet() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: ColoredBox(
            color: CustomColors.primaryWhite,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 12.0,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(color: CustomColors.primaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(FontAwesomeIcons.arrowLeft),
                          ),
                        ),
                        // ),
                        Expanded(
                          flex: 7,
                          child: Center(
                            child: CustomText(
                              text: 'Manage Access',
                              isHeading: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: CustomContainer(
                      applyShadow: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomText(text: 'Company', isSubHeading: true,),
                          ),
                          const SizedBox(height: 12,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomText(text: 'Create', isContent: true,),
                                    Checkbox(value: userProvider.companyRolesCheckbox['create'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCompanyRoleCheckBox('create', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Read', isContent: true,),
                                    Checkbox(value: userProvider.companyRolesCheckbox['read'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCompanyRoleCheckBox('read', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Update', isContent: true,),
                                    Checkbox(value: userProvider.companyRolesCheckbox['update'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCompanyRoleCheckBox('update', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Delete', isContent: true,),
                                    Checkbox(value: userProvider.companyRolesCheckbox['delete'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCompanyRoleCheckBox('delete', value!);
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Center(
                    child: CustomContainer(
                      applyShadow: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomText(text: 'User', isSubHeading: true,),
                          ),
                          const SizedBox(height: 12,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomText(text: 'Create', isContent: true,),
                                    Checkbox(value: userProvider.userRolesCheckbox['create'], activeColor: CustomColors.primaryColor,onChanged: (value){
                                      userProvider.toggleUserRoleCheckBox('create', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Read', isContent: true,),
                                    Checkbox(value: userProvider.userRolesCheckbox['read'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleUserRoleCheckBox('read', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Update', isContent: true,),
                                    Checkbox(value: userProvider.userRolesCheckbox['update'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleUserRoleCheckBox('update', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Delete', isContent: true,),
                                    Checkbox(value: userProvider.userRolesCheckbox['delete'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleUserRoleCheckBox('delete', value!);
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Center(
                    child: CustomContainer(
                      applyShadow: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomText(text: 'Categories', isSubHeading: true,),
                          ),
                          const SizedBox(height: 12,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomText(text: 'Create', isContent: true,),
                                    Checkbox(value: userProvider.categoriesRolesCheckbox['create'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCategoriesRoleCheckBox('create', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Read', isContent: true,),
                                    Checkbox(value: userProvider.categoriesRolesCheckbox['read'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCategoriesRoleCheckBox('read', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Update', isContent: true,),
                                    Checkbox(value: userProvider.categoriesRolesCheckbox['update'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCategoriesRoleCheckBox('update', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Delete', isContent: true,),
                                    Checkbox(value: userProvider.categoriesRolesCheckbox['delete'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleCategoriesRoleCheckBox('delete', value!);
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Center(
                    child: CustomContainer(
                      applyShadow: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomText(text: 'Issue', isSubHeading: true,),
                          ),
                          const SizedBox(height: 12,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomText(text: 'Create', isContent: true,),
                                    Checkbox(value: userProvider.issueRolesCheckbox['create'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleIssueRoleCheckBox('create', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Read', isContent: true,),
                                    Checkbox(value: userProvider.issueRolesCheckbox['read'], activeColor: CustomColors.primaryColor,onChanged: (value){
                                      userProvider.toggleIssueRoleCheckBox('read', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Update', isContent: true,),
                                    Checkbox(value: userProvider.issueRolesCheckbox['update'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleIssueRoleCheckBox('update', value!);
                                    })
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomText(text: 'Delete', isContent: true,),
                                    Checkbox(value: userProvider.issueRolesCheckbox['delete'], activeColor: CustomColors.primaryColor, onChanged: (value){
                                      userProvider.toggleIssueRoleCheckBox('delete', value!);
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/admin_provider/category/category_provider.dart';
import 'package:task_management_system/providers/admin_provider/user/user_provider.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/text_from_field/custom_text_form_field.dart';

import '../../../providers/admin_provider/company/company_provider.dart';
import '../../../routes/app_route_name.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/container/custom_container.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../../widgets/texts/custom_text.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, _) {
          return FloatingActionButton.extended(
            onPressed: () {
              if(categoryProvider.companyList.isEmpty){
                categoryProvider.getAllCompanies();
              }
              openAlertDialog(context);
              // GoRouter.of(context).pushNamed(AppRouteName.admin)
            },
            backgroundColor: CustomColors.primaryColor,
            icon: Icon(FontAwesomeIcons.plus, color: Colors.black),
            label: CustomText(text: 'Add Category', isContent: true),
          );
        }
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Categories',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.adminDashboardRouteName);
      },
    );
  }

  Widget _body() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomContainer(
                  applyShadow: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'S.N', isSubHeading: true),
                          CustomText(text: 'Category', isSubHeading: true),
                          CustomText(text: 'Action', isSubHeading: true),
                        ],
                      ),
                      Divider(),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            categoryProvider.category.length, // Replace with createUpdateAdminProvider.admins.length when data is dynamic
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: '${index + 1}',
                                      isContent: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: categoryProvider.category[index]['categoryName'] ?? 'N/A',
                                      isContent: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            openAlertDialog(context);
                                            categoryProvider.setCatControllerValues(categoryProvider.category[index], true);
                                            if(categoryProvider.companyList.isEmpty){
                                              categoryProvider.getAllCompanies();
                                              openAlertDialog(context);
                                            }
                                          },
                                          child: Icon(Icons.edit),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            categoryProvider.deleteCategory(categoryProvider.category[index]['_id'], context);
                                            // print(
                                            //   'Pressed on delete ${index + 1}',
                                            // );
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              const SizedBox(height: 12),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openAlertDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.primaryWhite,
          elevation: 10,
          title: Center(
            child: CustomText(
              text: 'Create Category',
              size: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Consumer<CategoryProvider>(
                builder: (context, categoryProvider, _) {
                  return Form(
                    key: categoryProvider.formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        CustomDropdown(
                          labelText: 'Company *',
                          items: categoryProvider.companyList,
                          value: categoryProvider.selectedCompany,
                          onChanged:
                              (newValue) =>
                              categoryProvider.setSelectedCompany(newValue!),
                        ),
                        const SizedBox(height: 16,),
                        CustomTextFromField(
                          controller:
                              categoryProvider.categoryNameTextController,
                          autoFocus: false,
                          hintText: 'Name',
                          labelText: 'Category Name *',
                          maxLines: 2,
                          validator: (value) {
                            // print(visitScreenProvider.followUpNote);
                            return value!.isEmpty
                                ? 'Category Name is required'
                                : value.length < 3
                                ? 'Enter at least 3 characters'
                                : null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextFromField(
                          controller:
                              categoryProvider.categoryDescriptionTextController,
                          autoFocus: false,
                          hintText: 'Description',
                          labelText: 'Description *',
                          maxLines: 2,
                          minLine: 2,
                          validator: (value) {
                            // print(visitScreenProvider.followUpNote);
                            return null;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: CustomColors.lightRed,
                      widget: CustomText(text: 'Cancel',isContent: true,),
                    ),
                    const SizedBox(width: 24,),
                    CustomElevatedButton(
                      onPressed: () {
                        if(categoryProvider.isEditCat == true){
                          categoryProvider.updateCategory(context);
                        }else{
                          categoryProvider.onTapCreate(context);
                        }
                      },
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(text: 'Submit', isContent: true,),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
    // DateFormat('dd MMM y, EE').format(DateTime.now())
  }
}

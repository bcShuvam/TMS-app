import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/admin_provider/category/category_provider.dart';
import '../../../routes/app_route_name.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/container/custom_container.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../../widgets/text_from_field/custom_text_form_field.dart';
import '../../../widgets/texts/custom_text.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(), body: _body(),
      floatingActionButton:_floatingButton(),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Sub Categories',
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

  Widget _floatingButton() {
    return Consumer<CategoryProvider>(
      builder: (context,categoryProvider, _) {
        return FloatingActionButton.extended(
          onPressed: () {
            print('pressed');
            openAlertDialog(context);
            // GoRouter.of(context).pushNamed(AppRouteName.adminCreateCompanyRouteName);
          },
          icon: const Icon(FontAwesomeIcons.plus, color: Colors.black),
          label: CustomText(text: "Add Sub Category", isContent: true,),
          backgroundColor: CustomColors.primaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      }
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
                  verticalPad: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      CustomText(text: 'Select a category', isSubHeading: true,),
                      const SizedBox(height: 8,),
                      CustomDropdown(
                        labelText: '',
                        items: categoryProvider.categoryNames,
                        value: categoryProvider.selectedCategoryName,
                        onChanged: (value) {
                          categoryProvider.updateSelectedCategoryName(value!);
                          final selectedIndex =
                              categoryProvider.selectedCategoryIndex;
                          final selectedCategoryId = categoryProvider.selectedCategory['_id'];
                          // issueProvider.getSubCategories(selectedCategoryId);
                        },
                      ),
                      const SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'S.N', isSubHeading: true),
                          CustomText(text: 'Sub Category', isSubHeading: true),
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
                            categoryProvider
                                .subCategories
                                .length, // Replace with createUpdateAdminProvider.admins.length when data is dynamic
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
                                      text:
                                          categoryProvider
                                              .subCategories[index]['subCategoryName'] ??
                                          'N/A',
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
                                            if (categoryProvider
                                                .companyList
                                                .isEmpty) {
                                              categoryProvider
                                                  .getAllCompanies();
                                            }
                                            categoryProvider.setSubCatControllerValues(
                                              categoryProvider.subCategories[index], true
                                            );
                                            // if(categoryProvider.isEditSubCat){
                                            //
                                            // }
                                            openAlertDialog(context);
                                          },
                                          child: Icon(Icons.edit),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            categoryProvider.deleteSubCategory(
                                              categoryProvider
                                                  .subCategories[index]['_id'],
                                              context,
                                            );
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
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                return Column(
                  children: [
                    CustomText(
                      text: 'Create Sub Category',
                      size: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      text: categoryProvider.selectedCategoryName,
                      isSubHeading: true,
                    ),
                  ],
                );
              }
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Consumer<CategoryProvider>(
                builder: (context, categoryProvider, _) {
                  return Form(
                    key: categoryProvider.subCatFormKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12,),
                        CustomTextFromField(
                          controller:
                          categoryProvider.subCategoryNameTextController,
                          autoFocus: false,
                          hintText: 'Name',
                          labelText: 'Sub Category Name *',
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
                          categoryProvider.subCategoryDescriptionTextController,
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
                        if(categoryProvider.isEditSubCat == true){
                          categoryProvider.updateSubCategory(context);
                        }else{
                          categoryProvider.createSubCategory(context);
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

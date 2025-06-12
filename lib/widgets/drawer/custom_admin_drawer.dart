import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/admin_provider/category/category_provider.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/list_tile/custom_list_tile.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../providers/admin_provider/user/user_provider.dart';
import '../../routes/app_route_name.dart';
import '../button/custom_elevated_button.dart';

class CustomAdminDrawer extends StatelessWidget {
  const CustomAdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColors.primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                context.pushReplacementNamed(
                  AppRouteName.adminDashboardRouteName,
                );
              },
              child: CustomContainer(
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.house),
                    const SizedBox(width: 16),
                    CustomText(text: 'Dashboard', isSubHeading: true),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              leading: Image.asset(
                'assets/images/company.png',
                height: 32,
                width: 32,
              ),
              title: CustomText(text: 'Company', isSubHeading: true),
              childrenPadding: EdgeInsets.only(left: 68),
              children: [
                CustomListTile(
                  title: CustomText(text: 'View Company', isContent: true),
                  onTap: () {
                    context.pushNamed(
                      AppRouteName.adminCompaniesRouteName,
                    );
                  },
                ),
              ],
            ),
             Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                return ExpansionTile(
                  leading: Image.asset(
                    'assets/images/category.png',
                    height: 32,
                    width: 32,
                  ),
                  title: CustomText(text: 'Category', isSubHeading: true),
                  childrenPadding: EdgeInsets.only(left: 68),
                  children: [
                    CustomListTile(
                      title: CustomText(text: 'Category', isContent: true),
                      onTap: () {
                        categoryProvider.getAllCategories();
                        categoryProvider.getAllCompanies();
                        context.pushNamed(
                          AppRouteName.adminCategoryRouteName,
                        );
                      },
                    ),
                    CustomListTile(
                      title: CustomText(text: 'Sub-Category', isContent: true),
                      onTap: () {
                        categoryProvider.getAllCategories();
                        context.pushNamed(
                          AppRouteName.adminSubCategoryRouteName,
                        );
                      },
                    ),
                  ],
                );
              }
            ),
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return ExpansionTile(
                  leading: Image.asset(
                    'assets/images/users.png',
                    height: 32,
                    width: 32,
                  ),
                  title: CustomText(text: 'User', isSubHeading: true),
                  childrenPadding: EdgeInsets.only(left: 68),
                  children: [
                    CustomListTile(
                      title: CustomText(text: 'New User', isContent: true),
                      onTap: () {
                        userProvider.getAllCompanies();
                        context.pushNamed(
                          AppRouteName.adminCreateUserRouteName,
                        );
                      },
                    ),
                    CustomListTile(
                      title: CustomText(text: 'Users List', isContent: true),
                      onTap: () {
                        userProvider.getAllUsers();
                        context.pushNamed(
                          AppRouteName.adminUsersListRouteName,
                        );
                      },
                    ),
                  ],
                );
              }
            ),
            // ExpansionTile(
            //   leading: Image.asset(
            //     'assets/images/post.png',
            //     height: 32,
            //     width: 32,
            //   ),
            //   title: CustomText(text: 'Post', isSubHeading: true),
            //   childrenPadding: EdgeInsets.only(left: 68),
            //   children: [
            //     CustomListTile(
            //       title: CustomText(text: 'Issue Post', isContent: true),
            //       onTap: () {
            //         context.pop();
            //         // context.pushNamed(
            //         //   AppRouteName.superAdminCreateUpdateAdminRouteName,
            //         // );
            //       },
            //     ),
            //     CustomListTile(
            //       title: CustomText(text: 'Solved Post', isContent: true),
            //       onTap: () {
            //         context.pop();
            //         // context.pushNamed(
            //         //   AppRouteName.superAdminManageAdminRouteName,
            //         // );
            //       },
            //     ),
            //   ],
            // ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          elevation: 10,
                          backgroundColor: CustomColors.primaryWhite,
                          title: CustomText(
                            text: 'Logout',
                            fontWeight: FontWeight.bold,
                            size: 24.0,
                            color: Colors.red,
                          ),
                          content: CustomText(
                            text: 'Are you sure you want to Logout ?',
                            fontWeight: FontWeight.w500,
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  // backgroundColor: Colors.green,
                                  borderColor: CustomColors.primaryBlack,
                                  widget: CustomText(
                                    text: 'No',
                                    isContent: true,
                                    color: CustomColors.primaryBlack,
                                  ),
                                ),
                                CustomElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                    authProvider.clearUserInfo();
                                    context.pushReplacementNamed(
                                      AppRouteName.loginRouteName,
                                    );
                                    // exit(0);
                                  },
                                  // backgroundColor: Colors.red,
                                  borderColor: Colors.red,
                                  widget: CustomText(
                                    text: 'Yes',
                                    isContent: true,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CustomContainer(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/logout.png',
                          height: 32,
                          width: 32,
                        ),
                        const SizedBox(width: 16),
                        CustomText(text: 'Logout', isSubHeading: true),
                      ],
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

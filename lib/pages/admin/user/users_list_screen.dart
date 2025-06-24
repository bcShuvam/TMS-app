import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/admin_provider/user/user_provider.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:flutter/services.dart';
import 'package:task_management_system/widgets/dropdown/custom_dropdown.dart';

import '../../../routes/app_route_name.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/texts/custom_text.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  _copy(String data) {
    final value = ClipboardData(text: data);
    Clipboard.setData(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(),
      body: _body(context),
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
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.adminDashboardRouteName);
      },
    );
  }

  Widget _body(context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return RefreshIndicator(
          color: CustomColors.primaryColor,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            userProvider.getAllUsers();
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 16,),
                  CustomContainer(
                    child: CustomDropdown(
                      labelText: 'Select Role',
                      items: userProvider.getUserByRoleList,
                      value: userProvider.selectedGetUserByRole,
                      onChanged: (value) {
                        userProvider.setSelectedGetUserByRole(value!);
                      },
                    ),
                  ),
                  userProvider.users.isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const BouncingScrollPhysics(),
                    itemCount: userProvider.users.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.users[index];
                      final company = user['companyId'];
                      final companyTitle = company['title'];
                      final name = user['name'];
                      final email = user['email'];
                      final gender = user['gender'];
                      final phone = user['phone'];
                      final address = user['address'];
                      final role = user['role'];
                      double sizedBoxHeight = 8;
                      return Center(
                        child: CustomContainer(
                          verticalMargin: 16,
                          horizontalPad: 8,
                          applyShadow: true,
                          child: ListTile(
                            onTap: () {
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: '${index + 1}.',
                                  isSubHeading: true,
                                ),
                                CustomText(
                                  text: name,
                                  isSubHeading: true,
                                  maxLines: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        userProvider.setControllerValuesOnEdit(index);
                                        GoRouter.of(context).pushNamed(AppRouteName.adminCreateUserRouteName);
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.penToSquare,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        userProvider.setUserDeleteId(user['_id']);
                                        openAlertDialog(context, name);
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.trash,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _userDetails('Company', companyTitle),
                                SizedBox(height: sizedBoxHeight),
                                _userDetails('Gender', gender),
                                SizedBox(height: sizedBoxHeight),
                                _userDetails('Role', role),
                                SizedBox(height: sizedBoxHeight),
                                _userDetails('Email', email, copyValue: true),
                                SizedBox(height: sizedBoxHeight),
                                _userDetails('Phone', phone, copyValue: true),
                                SizedBox(height: sizedBoxHeight),
                                _userDetails('Address', address),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ) : SizedBox(height: MediaQuery.of(context).size.height * 0.6,child: Center(child: CustomText(text: 'User not found', isSubHeading: true,),)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _userDetails(String key, String value, {bool copyValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: CustomText(text: key, isContent: true)),
        Expanded(
          flex: 2,
          child:
              copyValue != true
                  ? CustomText(maxLines: 2, text: value, isContent: true)
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomText(
                          maxLines: 2,
                          text: value,
                          isContent: true,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          _copy(value);
                        },
                        child: Icon(FontAwesomeIcons.copy, size: 20),
                      ),
                    ],
                  ),
        ),
      ],
    );
  }

  void openAlertDialog(context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.primaryWhite,
          elevation: 10,
          title: Center(
            child: CustomText(
              text: 'Delete User',
              color: Colors.red,
              size: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: CustomText(text: 'Are you sure you want to delete user $userName?', isContent: true, maxLines: 3,),
          actions: [
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(text: 'Cancel',isContent: true,),
                    ),
                    const SizedBox(width: 24,),
                    CustomElevatedButton(
                      onPressed: () {
                        userProvider.deleteUser(context);
                      },
                      backgroundColor: CustomColors.lightRed,
                      widget: CustomText(text: 'Delete', isContent: true,),
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

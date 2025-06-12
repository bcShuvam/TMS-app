import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/list_tile/custom_list_tile.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../routes/app_route_name.dart';
import '../button/custom_elevated_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
                  AppRouteName.superAdminDashboardRouteName,
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
              leading: Icon(FontAwesomeIcons.moneyBill),
              title: CustomText(text: 'Subscriptions', isSubHeading: true),
              childrenPadding: EdgeInsets.only(left: 60),
              children: [
                CustomListTile(
                  title: CustomText(text: 'New Subscription', isContent: true),
                  onTap: () {
                    context.pushNamed(
                      AppRouteName.superAdminNewSubscriptionRouteName,
                    );
                  },
                ),
                CustomListTile(
                  title: CustomText(text: 'Subscriptions', isContent: true),
                  onTap: () {
                    context.pushNamed(
                      AppRouteName.superAdminSubscriptionsRouteName,
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(FontAwesomeIcons.person),
              title: CustomText(text: 'Admin', isSubHeading: true),
              childrenPadding: EdgeInsets.only(left: 60),
              children: [
                CustomListTile(
                  title: CustomText(text: 'New Admin', isContent: true),
                  onTap: () {
                    context.pushNamed(
                      AppRouteName.superAdminCreateUpdateAdminRouteName,
                    );
                  },
                ),
                CustomListTile(
                  title: CustomText(text: 'Manage Admin', isContent: true),
                  onTap: () {
                    context.pushNamed(
                      AppRouteName.superAdminManageAdminRouteName,
                    );
                  },
                ),
              ],
            ),
            InkWell(
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
            ),
          ],
        ),
      ),
    );
  }
}

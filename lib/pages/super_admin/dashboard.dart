import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/providers/super_admin_provider/admin/create_admin_provider.dart';
import 'package:task_management_system/providers/super_admin_provider/dashboard/dashboard_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/appbar/custom_appbar.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/drawer/custom_drawer.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../widgets/button/custom_elevated_button.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SuperAdminDashboardProvider? supAdminDashProvider;

  @override
  void initState(){
    super.initState();
    supAdminDashProvider = Provider.of<SuperAdminDashboardProvider>(context, listen: false);
    supAdminDashProvider!.getAdmins();
    supAdminDashProvider!.getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              elevation: 10,
              backgroundColor: CustomColors.primaryWhite,
              title: CustomText(
                text: 'Exit',
                fontWeight: FontWeight.bold,
                size: 24.0,
                color: Colors.red,
              ),
              content: CustomText(
                text: 'Are you sure you want to exit ?',
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
                        SystemNavigator.pop();
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
      }),
      child: Scaffold(
        key: scaffoldKey,
        appBar: _appBar(),
        drawer: _drawer(),
        body: _body(),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Dashboard',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.bars,
      onTapLeadingIcon: () {
        scaffoldKey.currentState?.openDrawer(); // This now works
      },
    );
  }

  Widget _drawer() => const CustomDrawer();

  Widget _body() {
    return Consumer<SuperAdminDashboardProvider>(
      builder: (context, supAdminDashboardProvider, _) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 24),
                Consumer<CreateUpdateAdminProvider>(
                  builder: (context, createUpdateAdminProvider, _) {
                    return InkWell(
                      onTap: () {
                        createUpdateAdminProvider.getAdmins(context);
                        // context.pushNamed(AppRouteName.superAdminManageAdminRouteName);
                      },
                      child: CustomContainer(
                        applyShadow: true,
                        color: CustomColors.lightRed,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                child: Image.asset('assets/images/admin.png', scale: 14),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: 'Admins', isSubHeading: true),
                                CustomText(text: supAdminDashboardProvider.totalAdmin.toString(), isContent: true),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    context.pushNamed(AppRouteName.superAdminSubscriptionsRouteName);
                  },
                  child: CustomContainer(
                    applyShadow: true,
                    color: CustomColors.lightYellow,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/subscription.png',
                              scale: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: 'Subscription', isSubHeading: true),
                            CustomText(text: supAdminDashboardProvider.totalSubscription.toString(), isContent: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomContainer(
                      applyShadow: true,
                      color: CustomColors.lightGreen,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(8),
                              child: Image.asset('assets/images/earnings.png', scale: 14),
                            ),
                          ),
                          const SizedBox(width: 32),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: 'Earning', isSubHeading: true),
                              CustomText(text: authProvider.totalEarnings, isContent: true),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                ),
                SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomContainer(
                      applyShadow: true,
                      color: CustomColors.lightBlue,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/images/assigned_subscription.png',
                                scale: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Assigned Subscription',
                                isSubHeading: true,
                              ),
                              CustomText(text: authProvider.totalSales, isContent: true),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

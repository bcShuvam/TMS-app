import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/admin_provider/user/user_provider.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/widgets/drawer/custom_admin_drawer.dart';

import '../../routes/app_route_name.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/appbar/custom_appbar.dart';
import '../../widgets/button/custom_elevated_button.dart';
import '../../widgets/container/custom_container.dart';
import '../../widgets/texts/custom_text.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> adminScaffoldKey = GlobalKey<ScaffoldState>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // call the async method without await
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          // Remove: onDidReceiveLocalNotification (not supported in v15+)
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification tapped. Payload: ${response.payload}');
        // Handle notification tap here
      },
    );

    if (Platform.isAndroid) {
      final androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final granted =
          await androidImplementation?.requestNotificationsPermission();
      debugPrint("Android notification permission granted: $granted");
    }

    if (Platform.isIOS) {
      final iosImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();

      await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('iOS notification permissions requested');
    }
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
                        Navigator.pop(context, true);
                        SystemNavigator.pop();
                        exit(0);
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
        key: adminScaffoldKey,
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
        adminScaffoldKey.currentState?.openDrawer(); // This now works
      },
    );
  }

  Widget _drawer() => const CustomAdminDrawer();

  Widget _body() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            authProvider.getUpdatedValues();
          },
          child: SingleChildScrollView(
            child: Center(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  return Column(
                    children: [
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          userProvider.setSelectedGetUserByRole('Admin User');
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRouteName.adminUsersListRouteName);
                          print('tapped');
                        },
                        child: CustomContainer(
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
                                    'assets/images/admin.png',
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
                                    text: 'Admin User',
                                    isSubHeading: true,
                                  ),
                                  CustomText(
                                    text:
                                        authProvider.totalAdminUser.toString(),
                                    isContent: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          userProvider.setSelectedGetUserByRole('User');
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRouteName.adminUsersListRouteName);
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
                                  child: Image.asset(
                                    'assets/images/users.png',
                                    scale: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: 'Users', isSubHeading: true),
                                  CustomText(
                                    text: authProvider.totalUser.toString(),
                                    isContent: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomContainer(
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
                                child: Image.asset(
                                  'assets/images/company.png',
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
                                  text: 'Total Companies',
                                  isSubHeading: true,
                                ),
                                CustomText(
                                  text: authProvider.totalCompany.toString(),
                                  isContent: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          // context.pushNamed(AppRouteName.superAdminSubscriptionsRouteName);
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
                                    'assets/images/post.png',
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
                                    text: 'Total Post',
                                    isSubHeading: true,
                                  ),
                                  CustomText(
                                    text: authProvider.totalPost.toString(),
                                    isContent: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

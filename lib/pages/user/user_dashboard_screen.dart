import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/user_provider/issue/issue_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/drawer/custom_user_drawer.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../widgets/appbar/custom_appbar.dart';
import '../../widgets/button/custom_elevated_button.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  IssueProvider? _issueProvider;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() async {
    _issueProvider = Provider.of<IssueProvider>(context, listen: false);
    _issueProvider!.getIssues();
    _initializeNotifications();
    super.initState();
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
                        fontWeight: FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
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
        backgroundColor: CustomColors.primaryWhite,
        key: scaffoldKey,
        appBar: _appBar(),
        drawer: CustomUserDrawer(isDashboardActive: true),
        body: _body(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            GoRouter.of(context).pushNamed(AppRouteName.userCreateIssueRouteName);
          },
          icon: const Icon(FontAwesomeIcons.plus, color: Colors.black),
          label: CustomText(text: "Create Issue", isContent: true,),
          backgroundColor: CustomColors.primaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'User Dashboard',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.bars,
      onTapLeadingIcon: () => scaffoldKey.currentState?.openDrawer(),
    );
  }

  Widget _body() {
    return Consumer<IssueProvider>(
      builder: (context, issueProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            issueProvider.getIssues();
          },
          color: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          child: issueProvider.postFeeds.isNotEmpty
              ? ListView.builder(
            itemCount: issueProvider.postFeeds.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemBuilder: (context, index) {
              final issue = issueProvider.postFeeds[index];
              final category = issue['categoryName'];
              final subCategory = issue['subCategoryName'];
              final createdBy = issue['createdByName'];
              final issueStatus = issue['issueStatus'];
              final startDate =
                  issue['issueOpenDatetime'].toString().split('T')[0];
              final endDate =
                  issue['issueDeadlineDateTime'].toString().split('T')[0];
              return GestureDetector(
                onTap: () {
                  issueProvider.setSelectedIssue(index, context);
                },
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(Icons.category, 'Category', category),
                        _infoRow(
                          Icons.subdirectory_arrow_right,
                          'Subcategory',
                          subCategory,
                        ),
                        _infoRow(Icons.person, 'Created By', createdBy),
                        _infoRow(Icons.flag, 'Status', issueStatus),
                        _infoRow(Icons.calendar_today, 'Start Date', startDate),
                        _infoRow(
                          Icons.calendar_today_outlined,
                          'End Date',
                          endDate,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ) : Center(
        child: CustomText(
        text: 'No tasks found',
          isHeading: true,
          color: CustomColors.primaryBlack,
        ),
        ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? CustomColors.primaryBlack),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: CustomText(text: label, isContent: true)),
          Expanded(
            flex: 5,
            child: CustomText(text: value, maxLines: 2, isSubContent: true),
          ),
        ],
      ),
    );
  }
}

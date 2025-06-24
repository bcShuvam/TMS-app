import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/user_provider/issue/issue_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/drawer/custom_user_drawer.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../widgets/appbar/custom_appbar.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  IssueProvider? _issueProvider;

  @override
  void initState() {
    _issueProvider = Provider.of<IssueProvider>(context, listen: false);
    _issueProvider!.getIssues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

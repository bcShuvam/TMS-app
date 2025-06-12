import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/user_provider/issue/issue_provider.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../../routes/app_route_name.dart';
import '../../../widgets/appbar/custom_appbar.dart';

class PostFeedScreen extends StatefulWidget {
  PostFeedScreen({super.key});

  @override
  State<PostFeedScreen> createState() => _PostFeedScreenState();
}

class _PostFeedScreenState extends State<PostFeedScreen> {
  IssueProvider? issueProvider;

  @override
  void initState(){
    issueProvider = Provider.of<IssueProvider>(context, listen: false);
    issueProvider!.getIssues();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          issueProvider!.getCategories();
          GoRouter.of(context).pushNamed(AppRouteName.userCreateIssueRouteName);
        },
        backgroundColor: CustomColors.primaryColor,
        child: Icon(FontAwesomeIcons.plus, color: Colors.black,),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Post Feed',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.userDashboardRouteName);
        print('Tapped on Drawer');
      },
    );
  }

  Widget _body() {
    return Center(child: CustomText(text: 'Coming soon'));
  }
}

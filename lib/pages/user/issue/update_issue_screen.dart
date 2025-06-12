import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_route_name.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/texts/custom_text.dart';

class UpdateIssueScreen extends StatefulWidget {
  const UpdateIssueScreen({super.key});

  @override
  State<UpdateIssueScreen> createState() => _UpdateIssueScreenState();
}

class _UpdateIssueScreenState extends State<UpdateIssueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: FloatingActionButton.small(onPressed: (){}, child: Icon(FontAwesomeIcons.plus),),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Update Issue',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        GoRouter.of(context).pushReplacementNamed(AppRouteName.userDashboardRouteName);
        print('Tapped on Drawer');
      },
    );
  }

  Widget _body(){
    return Center(child: CustomText(text: 'Coming soon'),);
  }
}

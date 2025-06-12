import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/super_admin_provider/admin/create_admin_provider.dart';
import 'package:task_management_system/providers/super_admin_provider/dashboard/dashboard_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/widgets/button/custom_elevated_button.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../../themes/custom_colors.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/container/custom_container.dart';

class ManageAdminScreen extends StatefulWidget {
  const ManageAdminScreen({super.key});

  @override
  State<ManageAdminScreen> createState() => _ManageAdminScreenState();
}

class _ManageAdminScreenState extends State<ManageAdminScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CreateUpdateAdminProvider? _createUpdateAdminProvider;

  @override
  void initState(){
    super.initState();
    _createUpdateAdminProvider = Provider.of<CreateUpdateAdminProvider>(context,listen: false);
    // _createUpdateAdminProvider!.getAdmins(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Manage Admin',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        _createUpdateAdminProvider!.resetForm();
        GoRouter.of(scaffoldKey.currentContext!).pushReplacementNamed(AppRouteName.superAdminDashboardRouteName);
      },
    );
  }

  Widget _body() {
    return Consumer<CreateUpdateAdminProvider>(
      builder: (context, createUpdateAdminProvider, _) {
        return RefreshIndicator(
          color: CustomColors.primaryColor,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            createUpdateAdminProvider.getAdmins(context);
          },
          child: createUpdateAdminProvider.adminList.isNotEmpty ? ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(child: CustomText(text: 'Admins', isHeading: true)),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const BouncingScrollPhysics(),
                itemCount: createUpdateAdminProvider.totalAdmin, // Replace with createUpdateAdminProvider.admins.length when data is dynamic
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CustomContainer(
                        applyShadow: true,
                        color: CustomColors.primaryColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.person, size: 48),
                                // You can use: Image.asset('assets/images/admin.png', scale: 14),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                    text: createUpdateAdminProvider.adminList[index]['name'], isSubHeading: true),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    CustomElevatedButton(
                                      onPressed: () {
                                        createUpdateAdminProvider.setEditAdminIndex(index);
                                        createUpdateAdminProvider.getAllSubscriptions();
                                        createUpdateAdminProvider.setIsEditAdmin(true);
                                        createUpdateAdminProvider.setControllerValue();
                                        context.pushNamed(AppRouteName.superAdminCreateUpdateAdminRouteName);
                                      },
                                      backgroundColor: Colors.white,
                                      widget: CustomText(
                                          text: 'Edit', isContent: true),
                                    ),
                                    const SizedBox(width: 24),
                                    CustomElevatedButton(
                                      onPressed: () {
                                        createUpdateAdminProvider.setSelectedDeleteAdminId(createUpdateAdminProvider.adminList[index]['_id']);
                                        openAlertDialog(context, createUpdateAdminProvider.adminList[index]['name']);
                                      },
                                      backgroundColor: CustomColors.lightRed,
                                      widget: CustomText(
                                          text: 'Delete', isContent: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ],
          ) : Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(text: 'No Admins Found', isHeading: true,),
              const SizedBox(height: 16,),
              CustomElevatedButton(
                onPressed: (){
                createUpdateAdminProvider.getAdmins(context);
              },backgroundColor: CustomColors.primaryColor, widget: CustomText(text: 'Refresh',isSubHeading: true,),),
            ],
          ),),
        );
      },
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
            Consumer<CreateUpdateAdminProvider>(
              builder: (context, superAdminProvider, _) {
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
                        superAdminProvider.deleteAdmin(context);
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

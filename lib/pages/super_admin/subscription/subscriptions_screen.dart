import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/super_admin_provider/subscription/subscription_provider.dart';
import 'package:task_management_system/widgets/switch/CustomSwitch.dart';
import '../../../providers/super_admin_provider/admin/create_admin_provider.dart';
import '../../../routes/app_route_name.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/container/custom_container.dart';
import '../../../widgets/texts/custom_text.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SubscriptionProvider? subscriptionProvider;

  @override
  void initState(){
    super.initState();
    subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    subscriptionProvider!.getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey, appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Subscriptions',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        GoRouter.of(scaffoldKey.currentContext!).pop();
        subscriptionProvider!.setIsEditSubscription(false);
      },
    );
  }

  Widget _body() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Center(child: CustomText(text: '', isHeading: true)),
            // const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const BouncingScrollPhysics(),
              itemCount:
                  subscriptionProvider.subscriptionsList.length, // Replace with createUpdateAdminProvider.admins.length when data is dynamic
              itemBuilder: (context, index) {
                String planName = subscriptionProvider.subscriptionsList[index]['name'];
                int planPrice = subscriptionProvider.subscriptionsList[index]['price'];
                int planDuration = subscriptionProvider.subscriptionsList[index]['duration'];
                bool subscriptionStatus = subscriptionProvider.subscriptionsList[index]['status'];
                return Column(
                  children: [
                    CustomContainer(
                      applyShadow: true,
                      color: CustomColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: planName, isSubHeading: true),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  CustomElevatedButton(
                                    onPressed: () {
                                      subscriptionProvider
                                          .setIsEditSubscription(true);
                                      subscriptionProvider.setControllerValue(index);
                                      context.pushNamed(
                                        AppRouteName
                                            .superAdminNewSubscriptionRouteName,
                                      );
                                    },
                                    backgroundColor: Colors.white,
                                    widget: CustomText(
                                      text: 'Edit',
                                      isContent: true,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  CustomElevatedButton(
                                    onPressed: () {
                                      // TODO: Implement delete functionality
                                    },
                                    backgroundColor: CustomColors.lightRed,
                                    widget: CustomText(
                                      text: 'Delete',
                                      isContent: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CustomSwitch(
                            value: subscriptionStatus,
                            onChange: (newValue) {
                              subscriptionProvider.toggleSubscriptionStatus(
                                index,
                                newValue,
                              );
                            },
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
        );
      },
    );
  }
}

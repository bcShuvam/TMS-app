import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/super_admin_provider/subscription/subscription_provider.dart';
import 'package:task_management_system/widgets/dropdown/custom_dropdown.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/container/custom_container.dart';
import '../../../widgets/text_from_field/custom_text_form_field.dart';
import '../../../widgets/texts/custom_text.dart';

class NewSubscriptionScreen extends StatefulWidget {
  const NewSubscriptionScreen({super.key});

  @override
  State<NewSubscriptionScreen> createState() => _NewSubscriptionScreenState();
}

class _NewSubscriptionScreenState extends State<NewSubscriptionScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _createAdminFormKey = GlobalKey<FormState>();
  SubscriptionProvider? subscriptionProvider;

  @override
  void initState() {
    super.initState();
    subscriptionProvider = Provider.of<SubscriptionProvider>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey, appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName:
          subscriptionProvider!.isEditSubscription
              ? 'Edit Subscription'
              : 'New Subscription',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        subscriptionProvider!.resetForm();
        GoRouter.of(scaffoldKey.currentContext!).pop();
      },
    );
  }

  Widget _body() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomContainer(
                  applyShadow: true,
                  child: Form(
                    key: subscriptionProvider.subscriptionFormKey,
                    child: Column(
                      children: [
                        CustomText(
                          text:
                              subscriptionProvider.isEditSubscription
                                  ? 'Edit Subscription'
                                  : 'Create Subscription',
                          isHeading: true,
                        ),
                        const SizedBox(height: 24),
                        CustomTextFromField(
                          controller:
                              subscriptionProvider.subscriptionNameTextController,
                          labelText: 'Subscription Name *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Subscription name is required'
                                : value.length < 3
                                ? 'Subscription name must be of 3 length'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller:
                              subscriptionProvider.maxCompaniesTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          labelText: 'Max companies *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Max companies is required'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller: subscriptionProvider.maxUsersTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          labelText: 'Max users *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Max Users is required'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller:
                              subscriptionProvider
                                  .maxUploadPhotoAllowedTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          labelText: 'Max upload photo allowed *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Max upload photo allowed is required'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller:
                          subscriptionProvider.durationTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          labelText: 'Duration in Month *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Duration is required'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller: subscriptionProvider.priceTextController,
                          keyboardType: TextInputType.number,
                          labelText: 'Price *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'End Date is required'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller: subscriptionProvider.messageTextController,
                          labelText: 'Message',
                          minLine: 3,
                          maxLines: 3,
                          validator: (value) {},
                        ),
                        const SizedBox(height: 12),
                        CustomElevatedButton(
                          onPressed: () {
                            subscriptionProvider.isEditSubscription ? subscriptionProvider.onTapUpdateSubscription(context) : subscriptionProvider.onTapCreateSubscription(context);
                          },
                          width: 1,
                          height: 50,
                          backgroundColor: CustomColors.primaryColor,
                          widget: CustomText(
                            text:
                                subscriptionProvider.isEditSubscription
                                    ? 'Update'
                                    : 'Create',
                            isSubHeading: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        );
      },
    );
  }
}

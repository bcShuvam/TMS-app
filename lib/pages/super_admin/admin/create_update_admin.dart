import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/super_admin_provider/admin/create_admin_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/button/custom_elevated_button.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/text_from_field/custom_text_form_field.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../../widgets/texts/custom_text.dart';

class CreateUpdateAdminScreen extends StatefulWidget {
  const CreateUpdateAdminScreen({super.key});

  @override
  State<CreateUpdateAdminScreen> createState() =>
      _CreateUpdateAdminScreenState();
}

class _CreateUpdateAdminScreenState extends State<CreateUpdateAdminScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CreateUpdateAdminProvider? createUpdateAdminProvider;

  @override
  void initState() {
    super.initState();
    createUpdateAdminProvider = Provider.of<CreateUpdateAdminProvider>(
      context,
      listen: false,
    );
    if(!createUpdateAdminProvider!.isEditAdmin){
      createUpdateAdminProvider!.getSubscriptionsName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      key: scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName:
          createUpdateAdminProvider!.isEditAdmin
              ? 'Edit Admin'
              : 'Create Admin',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        createUpdateAdminProvider!.setIsEditAdmin(false);
        createUpdateAdminProvider!.resetForm();
        GoRouter.of(scaffoldKey.currentContext!).pushReplacementNamed(AppRouteName.superAdminDashboardRouteName);
      },
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Consumer<CreateUpdateAdminProvider>(
        builder: (context, createUpdateAdminProvider, _) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomContainer(
                  child: Form(
                    key: createUpdateAdminProvider.createAdminFormKey,
                    child: Column(
                      children: [
                        CustomText(text: 'Admin Details', isHeading: true),
                        const SizedBox(height: 24),
                        CustomTextFromField(
                          controller:
                              createUpdateAdminProvider.usernameTextController,
                          labelText: 'username *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Username is required'
                                : value.length < 3 ? 'Password must be 3 length' : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller:
                              createUpdateAdminProvider.emailTextController,
                          labelText: 'email *',
                          validator: (value) {
                            String pattern =
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            RegExp regex = RegExp(pattern);
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!regex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller:
                              createUpdateAdminProvider.phoneNumberTextController,
                          labelText: 'Phone number *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Phone number is required'
                                : value.length < 10
                                ? 'Password must be 10 length'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller:
                              createUpdateAdminProvider.addressTextController,
                          labelText: 'Address *',
                          validator: (value) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomDropdown(
                          labelText: 'Gender *',
                          items: createUpdateAdminProvider.genderList,
                          value: createUpdateAdminProvider.selectedGender,
                          onChanged:
                              (newValue) => createUpdateAdminProvider
                                  .setSelectedGender(newValue!),
                        ),
                        const SizedBox(height: 12),
                        CustomDropdown(
                          labelText: 'Subscription Name *',
                          items: createUpdateAdminProvider.assignSubscription,
                          value: createUpdateAdminProvider.selectedSubscription,
                          onChanged:
                              (newValue) => createUpdateAdminProvider
                                  .setSelectedSubscription(newValue!),
                        ),
                        const SizedBox(height: 12),
                        CustomTextFromField(
                          controller:
                              createUpdateAdminProvider.activationDateTextController,
                          labelText: 'Activation Date *',
                          // prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                          applySuffixIcon: true,
                          suffixIcon: InkWell(
                            onTap: () {
                              createUpdateAdminProvider.selectDate(context);
                            },
                            child: Icon(Icons.calendar_month,
                            ),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Activation date is required' : null;
                          },
                        ),
                        const SizedBox(height: 12,),
                        CustomTextFromField(
                          controller:
                          createUpdateAdminProvider.expirationDateTextController,
                          labelText: 'Expiration Date *',
                          // prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                          applySuffixIcon: true,
                          suffixIcon: InkWell(
                            onTap: () {
                              createUpdateAdminProvider.selectDate(context);
                            },
                            child: Icon(Icons.calendar_month,
                            ),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Expiration date is required' : null;
                          },
                        ),
                        const SizedBox(height: 12,),
                        CustomTextFromField(
                          controller:
                              createUpdateAdminProvider.passwordTextController,
                          obscure: createUpdateAdminProvider.obscure,
                          labelText: 'password *',
                          // prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                          applySuffixIcon: true,
                          suffixIcon: InkWell(
                            onTap: () {
                              createUpdateAdminProvider.toggleObscure();
                            },
                            child: Icon(
                              createUpdateAdminProvider.obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          validator: (value) {
                            return createUpdateAdminProvider.isEditAdmin ? null : value!.isEmpty
                                ? 'Password is required'
                                : value.length < 8
                                ? 'Password must be 8 length'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomElevatedButton(
                          onPressed: () {
                            // if (createUpdateAdminProvider.createAdminFormKey.currentState != null && createUpdateAdminProvider.createAdminFormKey.currentState!.validate()) {
                            createUpdateAdminProvider.isEditAdmin ? createUpdateAdminProvider.onTapUpdateAdmin(context) : createUpdateAdminProvider.onTapCreateAdmin(context);
                              // print('Admin Created successfully');
                            // } else {
                            //   print('Invalid Form');
                            // }
                          },
                          width: 1,
                          height: 50,
                          backgroundColor: CustomColors.primaryColor,
                          widget: CustomText(
                            text:
                                createUpdateAdminProvider.isEditAdmin
                                    ? 'Update'
                                    : 'Create',
                            isSubHeading: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

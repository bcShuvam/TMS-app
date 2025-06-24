import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/widgets/button/custom_elevated_button.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../themes/custom_colors.dart';
import '../widgets/appbar/custom_appbar.dart';
import '../widgets/text_from_field/custom_text_form_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        backgroundColor: CustomColors.primaryWhite,
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: "Task Management System",
        applyShadow: true,
        size: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _body() {
    return Consumer<AuthProvider>(
      builder: (context, _authProvider, _) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                  applyShadow: true,
                  child: Form(
                    key: _otpFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 0,),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _authProvider.clearOtpForm();
                                GoRouter.of(context).pushReplacementNamed(AppRouteName.loginRouteName);
                              },
                              child: Icon(FontAwesomeIcons.arrowLeft),
                            ),
                            Expanded(
                              child: Center(
                                child: CustomText(
                                  text: 'OTP Verification',
                                  isHeading: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomTextFromField(
                          controller: _authProvider.otpController,
                          keyboardType: TextInputType.number,
                          autoFocus: false,
                          validator: (value) {
                            return value!.isEmpty
                                ? 'otp required'
                                : value.length < 6
                                ? 'invalid otp'
                                : null;
                          },
                          onChange: (value) {},
                          hintText: 'OTP *',
                          prefixIcon: Image.asset(
                            'assets/images/otp.png',
                            scale: 14,
                            color: Colors.grey.shade700,
                          ),
                          applySuffixIcon: false,
                        ),
                        const SizedBox(height: 16),
                        CustomElevatedButton(
                          onPressed: () {
                            if(_otpFormKey.currentState!.validate()) {
                              _authProvider.verifyOTP(context);
                            }else{
                              NotiService().showNotification(title: 'TMS OTP Verification', body: 'Please enter a valid OTP');
                            }
                          },
                          width: 1,
                          backgroundColor: CustomColors.primaryColor,
                          height: 50,
                          widget: CustomText(text: 'Submit', isSubHeading: true),
                        ),
                        const SizedBox(height: 16),
                        CustomElevatedButton(
                          onPressed: () {},
                          width: 1,
                          backgroundColor: CustomColors.primaryColor,
                          height: 50,
                          widget: CustomText(text: 'Resend OTP', isSubHeading: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

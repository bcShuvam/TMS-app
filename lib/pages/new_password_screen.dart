import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../themes/custom_colors.dart';
import '../widgets/appbar/custom_appbar.dart';
import '../widgets/text_from_field/custom_text_form_field.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
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
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFFBBDEFB),
                ],
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'OTP Verification',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFromField(
                    controller: _authProvider.otpController,
                    keyboardType: TextInputType.number,
                    autoFocus: false,
                    validator: (value) {
                      return value!.isEmpty ? 'otp required' : value.length < 6 ? 'invalid otp' : null;
                    },
                    onChange: (value) {},
                    hintText: 'OTP',
                    prefixIcon: Icon(FontAwesomeIcons.userSecret, color: Colors.grey.shade600),
                    applySuffixIcon: false,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }
    );
  }
}

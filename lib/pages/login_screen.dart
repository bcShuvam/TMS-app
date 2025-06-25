import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/appbar/custom_appbar.dart';
import 'package:task_management_system/widgets/button/custom_elevated_button.dart';
import 'package:task_management_system/widgets/text_from_field/custom_text_form_field.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';
// import 'package:timezone/browser.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKeyAdmin = GlobalKey<FormState>();

  // final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  // @override
  // void initState() {
  //   init();
  //   super.initState();
  // }
  //
  // Future<void> init() async {
  //   initializeTimeZone();
  //
  //   setLocalLocation(
  //     getLocation('Asia/Kathmandu'),
  //   );
  //
  //   const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
  //   const DarwinInitializationSettings isoSettings = DarwinInitializationSettings();
  //
  //   const InitializationSettings initializationSettings = InitializationSettings(
  //     android: androidSettings,
  //     iOS: isoSettings,
  //   );
  //
  //   await notificationsPlugin.initialize(
  //       initializationSettings
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        SystemNavigator.pop();
        exit(0);
        // showDialog(
        //   context: context,
        //   builder: (_) {
        //     return AlertDialog(
        //       elevation: 10,
        //       backgroundColor: CustomColors.primaryWhite,
        //       title: CustomText(
        //         text: 'Exit',
        //         fontWeight: FontWeight.bold,
        //         size: 24.0,
        //         color: Colors.red,
        //       ),
        //       content: CustomText(
        //         text: 'Are you sure you want to exit ?',
        //         fontWeight: FontWeight.w500,
        //       ),
        //       actions: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             CustomElevatedButton(
        //               onPressed: () {
        //                 Navigator.pop(context, false);
        //               },
        //               // backgroundColor: Colors.green,
        //               borderColor: CustomColors.primaryBlack,
        //               widget: CustomText(
        //                 text: 'No',
        //                 fontWeight: FontWeight.w500,
        //                 color: CustomColors.primaryBlack,
        //               ),
        //             ),
        //             CustomElevatedButton(
        //               onPressed: () {
        //                 Navigator.pop(context, true);
        //                 SystemNavigator.pop();
        //                 exit(0);
        //               },
        //               // backgroundColor: Colors.red,
        //               borderColor: Colors.red,
        //               widget: CustomText(
        //                 text: 'Yes',
        //                 fontWeight: FontWeight.w500,
        //                 color: Colors.red,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     );
        //   },
        // );
      }),
      child: GestureDetector(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: adminLogin(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget adminLogin() {
    return Consumer<AuthProvider>(builder: (context, _authProvider, _) {
      return Form(
        key: _formKeyAdmin,
        child: Column(
          children: [
            CustomText(text: 'Login Screen', isHeading: true),
            const SizedBox(height: 24),
            CustomTextFromField(
              controller: _authProvider.userEmailController,
              keyboardType: TextInputType.emailAddress,
              autoFocus: true,
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
              onChange: (value) {},
              hintText: 'jane@example.com',
              prefixIcon: Icon(Icons.email, color: Colors.grey.shade600),
              applySuffixIcon: false,
            ),
            const SizedBox(height: 16),
            CustomTextFromField(
              controller: _authProvider.passwordController,
              obscure: _authProvider.obscure,
              validator: (value) => value!.isEmpty ? 'Password required' : null,
              onChange: (value) {},
              hintText: '••••••',
              prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
              applySuffixIcon: true,
              suffixIcon: InkWell(
                onTap: () => _authProvider.toggleObscure(),
                child: Icon(
                  _authProvider.obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              onPressed: () {
                if (_formKeyAdmin.currentState?.validate() ?? false) {
                  _authProvider.login(context);
                } else {
                  NotiService().showNotification(
                    id: 1,
                    title: 'Fields required',
                    body: 'Please enter email and password.',
                  );
                }
              },
              width: 1,
              height: 50,
              backgroundColor: CustomColors.primaryColor,
              widget: CustomText(text: 'Login', isSubHeading: true),
            ),
          ],
        ),
      );
    });
  }
}
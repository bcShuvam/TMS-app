import 'package:flutter/material.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }
  
  Widget _body(){
    return Center(
      child: CustomText(text: 'User Login Screen', isHeading: true, size: 24, fontWeight: FontWeight.w700),
    );
  }
}

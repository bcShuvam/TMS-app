import 'package:flutter/material.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({required this.title, this.onTap, super.key});

  final CustomText title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      onTap: onTap,
    );
  }
}

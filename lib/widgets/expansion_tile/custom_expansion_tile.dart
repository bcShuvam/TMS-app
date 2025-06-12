import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({required this.title, required this.leadingIcon, required this.children, super.key});
  final String title;
  final IconData leadingIcon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: CustomText(
        text: title, isSubHeading: true,
      ),
      leading: Icon(leadingIcon),
      childrenPadding: EdgeInsets.only(left: 60),
      children: children,
    );
  }
}

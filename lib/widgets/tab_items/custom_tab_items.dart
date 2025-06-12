import 'package:flutter/material.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

class CustomTabItems extends StatelessWidget {
  const CustomTabItems({
    required this.title,
    super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
              text: title,
            isSubHeading: true,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

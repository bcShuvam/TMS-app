import 'package:flutter/material.dart';
import '../../themes/custom_colors.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key, required this.value, required this.onChange});
  final bool value;
  final Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      thumbColor: WidgetStateProperty.all(CustomColors.primaryWhite),
      // activeColor: CustomColors.primaryBlack,
      activeTrackColor: CustomColors.jadeGreen,
      inactiveThumbColor: CustomColors.primaryWhite,
      inactiveTrackColor: CustomColors.lightRed,
      value: value,
      onChanged: onChange,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/custom_colors.dart';

class CustomTextFromField extends StatefulWidget {
  const CustomTextFromField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.applyPrefix = true,
    this.applySuffixIcon = false,
    this.suffixIcon,
    this.fillColor,
    this.borderRadius = 8.0,
    this.autoFocus = false,
    this.readOnly = false,
    this.minLine = 1,
    this.maxLines = 1,
    this.onChange,
    this.onTap,
    this.focusNode, // Add FocusNode as an optional parameter
    this.inputFormatters, // 👈 Add this
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool obscure;
  final bool applyPrefix;
  final Widget? prefixIcon;
  final bool applySuffixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final double borderRadius;
  final String? Function(String?) validator;
  final bool autoFocus;
  final bool readOnly;
  final TextInputType keyboardType;
  final int minLine;
  final int maxLines;
  final Function(String?)? onChange;
  final Function()? onTap;
  final FocusNode? focusNode; // Optional FocusNode
  final List<TextInputFormatter>? inputFormatters; // 👈 Add this
  @override
  _CustomTextFromFieldState createState() =>
      _CustomTextFromFieldState();
}

class _CustomTextFromFieldState
    extends State<CustomTextFromField> {
  // Declare a default FocusNode that will be used if none is provided
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // If the user provides a FocusNode, use it, otherwise create a new one
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    // If we created the FocusNode internally, dispose of it
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: widget.obscure,
      validator: widget.validator,
      autofocus: widget.autoFocus,
      readOnly: widget.readOnly,
      minLines: widget.minLine,
      maxLines: widget.maxLines,
      focusNode: _focusNode, // Use the internal or provided FocusNode
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: widget.onTap,
      onChanged: widget.onChange,
      // onTapOutside: (event) {
      //   FocusManager.instance.primaryFocus
      //       ?.unfocus(); // Dismiss the keyboard on outside tap
      // },
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor ?? CustomColors.primaryWhite,
        focusColor: CustomColors.primaryWhite,
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.applyPrefix ? widget.prefixIcon : null,
        suffixIcon: widget.applySuffixIcon ? widget.suffixIcon : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

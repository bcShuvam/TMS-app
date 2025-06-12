import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../themes/custom_colors.dart';
import '../texts/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    required this.tabName,
    this.titleColor,
    this.fontWeight,
    this.size,
    this.backgroundColor,
    this.centerTitle = true,
    this.showTrailingIcons = false,
    this.showPopupMenu = false,
    this.showLeading = false,
    this.isLeadingImage = false,
    this.leadingIconColor = Colors.black,
    this.imageName,
    this.leadingIcon,
    this.onTapLeadingIcon,
    this.applyShadow = false,
    this.showThemeIcon = false,
    this.onPressedThemeIcon,
    this.automaticallyImplyLeading = false,
    this.trailingSearchIcon = false,
    this.onTapTrailingSearchIcon,
    this.showApproveButton = false,
    this.onTapTrailingApproveIcon,
    this.onTap,
    super.key,
  });

  final String tabName;
  final Color? titleColor;
  final bool centerTitle;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final double? size;
  final bool showTrailingIcons;
  final bool showPopupMenu;
  final bool showLeading;
  final Color leadingIconColor;
  final bool isLeadingImage;
  final String? imageName;
  final IconData? leadingIcon;
  final Function()? onTapLeadingIcon;
  final bool applyShadow;
  final bool showThemeIcon;
  final Function()? onPressedThemeIcon;
  final bool automaticallyImplyLeading;
  final bool trailingSearchIcon;
  final Function()? onTapTrailingSearchIcon;
  final bool showApproveButton;
  final Function()? onTapTrailingApproveIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? CustomColors.primaryColor,
      elevation: applyShadow ? 4 : 0,
      title: CustomText(
        text: tabName,
        fontWeight: fontWeight ?? FontWeight.w600,
        size: size ?? 28.0,
        color: titleColor ?? Colors.black,
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: showLeading
          ? isLeadingImage
          ? InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp",
              fit: BoxFit.fill,
              width: 40,
              height: 40,
            ),
          ),
        ),
      )
          : IconButton(
        onPressed: onTapLeadingIcon,
        icon: Icon(
          leadingIcon ?? Icons.menu,
          color: leadingIconColor,
        ),
      )
          : null,
      actions: showTrailingIcons
          ? [
        if (showPopupMenu)
          PopupMenuButton(
            icon: const FaIcon(FontAwesomeIcons.bars),
            position: PopupMenuPosition.under,
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: CustomText(text: 'Change view'),
                onTap: () {
                  debugPrint('Tapped Change view');
                },
              ),
            ],
          ),
        if (showThemeIcon)
          IconButton(
            onPressed: onPressedThemeIcon,
            icon: const Icon(Icons.dark_mode),
          ),
        if (trailingSearchIcon)
          IconButton(
            onPressed: onTapTrailingSearchIcon,
            icon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: CustomColors.primaryBlack,
            ),
          ),
        if (showApproveButton)
          InkWell(
            onTap: onTapTrailingApproveIcon,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SizedBox(
                height: 36,
                width: 36,
                child: Image.asset('assets/images/check-mark.png'),
              ),
            ),
          ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class BuildAddOrSubtractButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool disabled;

  const BuildAddOrSubtractButton({Key? key, required this.icon, required this.onTap, required this.disabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 11),
        decoration: BoxDecoration(
          border: Border.all(
            color: disabled ? AppColors.zimkeyGrey : AppColors.zimkeyOrange,
          ),
          borderRadius: BorderRadius.circular(5),
          color: disabled ? AppColors.zimkeyWhite : AppColors.zimkeyBodyOrange,
        ),
        child: Icon(
          icon,
          color: disabled ? AppColors.zimkeyGrey : Colors.black,
        ),
      ),
    );
  }
}

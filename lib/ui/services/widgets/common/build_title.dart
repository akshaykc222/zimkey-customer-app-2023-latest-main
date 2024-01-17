import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class BuildTitle extends StatelessWidget {
  final String title;
  const BuildTitle({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.zimkeyDarkGrey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

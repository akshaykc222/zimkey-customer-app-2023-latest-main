import 'package:flutter/material.dart';


import '../../constants/colors.dart';
import '../helper/helper_widgets.dart';

class AnimatedButton extends StatefulWidget {
  final bool isLoading;
  final bool isEnabled;
  final String btnName;
  final VoidCallback onTap;

  const AnimatedButton(
      {super.key, required this.isLoading, required this.onTap, required this.isEnabled, required this.btnName});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: widget.isLoading ? () {} : widget.onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: widget.isLoading ? 50.0 : MediaQuery.of(context).size.width / 2.5,
            height: 50.0,
            decoration: BoxDecoration(
              color: widget.isEnabled ? AppColors.zimkeyOrange : AppColors.zimkeyWhite,
              borderRadius: BorderRadius.circular(30),
              boxShadow: widget.isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.zimkeyLightGrey.withOpacity(0.1),
                        blurRadius: 5.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: const Offset(
                          1.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? HelperWidgets.progressIndicator()
                  : HelperWidgets.buildText(
                      text: widget.btnName,
                      fontSize: 18,
                      color: widget.isEnabled ? AppColors.zimkeyWhite : AppColors.zimkeyBlack),
            )),
      ),
    );
  }
}

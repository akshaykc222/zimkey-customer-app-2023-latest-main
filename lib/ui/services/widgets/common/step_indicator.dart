import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class StepIndicator extends StatefulWidget {
  final int currentStage;
  const StepIndicator({Key? key,required this.currentStage}) : super(key: key);

  @override
  State<StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator>  with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    // _controller.reverse(
    //     from: _controller.value == 0.0
    //         ? 1.0
    //         : _controller.value);
    _controller.animateTo(1.0, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildStage(
                    context: context,
                    stageName: "Options",
                    completed: 0 <= widget.currentStage-1 ? true : false,
                  processing: 0==widget.currentStage?true:false
                ),
                const SizedBox(width: 3,),
                buildStage(
                    context: context,
                    stageName: "Schedule",
                    completed: 1 <= widget.currentStage-1 ? true : false,
                    processing: 1==widget.currentStage?true:false),
                const SizedBox(width: 3,),

                Center(
                  child: Text(
                    "Payment",
                    style: TextStyle(color: 2== widget.currentStage? AppColors.zimkeySecondaryColor :AppColors.zimkeyDarkGrey.withOpacity(0.3),fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildStage(
      {required BuildContext context,
        required String stageName,
        required bool completed,required bool processing}) {
    return Row(
      children: [
        Center(
          child: Text(
            stageName,
            style: TextStyle(color:processing?AppColors.buttonColor : completed ? AppColors.buttonColor : AppColors.zimkeyDarkGrey.withOpacity(0.3),fontSize: 12),
          ),
        ),
        const SizedBox(width: 3,),
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: [
                Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width * .1,
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.3)),
                Container(
                  height: 2,
                  width: stageName == widget.currentStage.toString()
                      ? MediaQuery.of(context).size.width *
                      .1 *
                      _controller.value
                      : MediaQuery.of(context).size.width * .1,
                  color: processing?AppColors.buttonColor:completed ? AppColors.buttonColor : AppColors.zimkeyDarkGrey.withOpacity(0.3),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

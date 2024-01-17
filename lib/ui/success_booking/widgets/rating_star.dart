
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/colors.dart';

class RatingStar extends StatefulWidget {
  final int rating;
  final int index;
  final double starHeight;
  final Function(int newrate) updateRating;
  const RatingStar({
    Key? key,
    required this.rating,
    required this.updateRating,
    required this.index,
    this.starHeight = 30,
  }) : super(key: key);

  @override
  RatingStarState createState() => RatingStarState();
}

class RatingStarState extends State<RatingStar> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.updateRating(widget.index);
      },
      child: SvgPicture.asset(
        widget.rating >= widget.index
            ? 'assets/images/icons/newIcons/starFilled.svg'
            : 'assets/images/icons/newIcons/star.svg',
        colorFilter: const ColorFilter.mode(AppColors.zimkeyOrange, BlendMode.srcIn),
        height: widget.starHeight,
      ),
    );
  }
}
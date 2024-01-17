import 'package:customer/constants/strings.dart';
import 'package:customer/data/model/home/home_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/colors.dart';

class BuildStaticBanners extends StatelessWidget {
  final GetHomeContent homeContent;
  const BuildStaticBanners( {Key? key,required this.homeContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // height: MediaQuery.of(context).size.width / 3.5,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: zimkeyBodyOrange,
        color: AppColors.zimkeyLightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          homeContent.description.isNotEmpty? Expanded(flex: 8,
            child: Html(shrinkWrap: true,
              data: homeContent.description,
            ),
          ):const SizedBox(),
          const SizedBox(
            width: 10,
          ),
          homeContent.image.isNotEmpty? Expanded(
            flex: 3,
            child: Container(
              padding:
              EdgeInsets.all(
                  10),
              decoration: BoxDecoration(
                  color: AppColors.zimkeyOrange.withOpacity(
                      0.2),
                  borderRadius:
                  BorderRadius.circular(20)),
              child: Image.network(Strings.mediaUrl+homeContent.image),
              // child: SvgPicture
              //     .asset(
              //   'assets/images/icons/newIcons/vaccine.svg',
              //   color:
              //   AppColors.zimkeyOrange,
              //   height:
              //   70,
              // ),
            ),
          ):const SizedBox(),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/model/services/single_service_response.dart';

class ServiceThumbnail extends StatelessWidget {
  final List<Media> medias;

  const ServiceThumbnail({Key? key, required this.medias}) : super(key: key);
  static double imageHeight = 250;

  @override
  Widget build(BuildContext context) {
    if (medias.isNotEmpty) {
      if (medias.first.url.contains('.svg')) {
        return SvgPicture.network(
          Strings.mediaUrl + medias.first.url,
          fit: BoxFit.contain,
          width: double.infinity,
        );
      } else {
        // return Image.network(
        //   Strings.mediaUrl + medias.first.url,fit: BoxFit.fitWidth,
        // );
        return CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: Container(
              width: double.infinity,
              height: imageHeight,
              decoration: const BoxDecoration(
                color: AppColors.zimkeyWhite,
              ),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          imageUrl: Strings.mediaUrl + medias.first.url,
          fadeInCurve: Curves.easeIn,
          fadeOutCurve: Curves.easeInOutBack,
        );
      }
    }
    return Image.asset(
      "assets/images/serviceinfo.png",
      fit: BoxFit.cover,
      width: double.infinity,
      // height: imageHeight,
    );
  }
}

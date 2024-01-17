import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/model/home/home_response.dart';
import '../../../utils/helper/helper_widgets.dart';

class BuildCarouselBanner extends StatefulWidget {
  final List<GetBanner> banners;

  const BuildCarouselBanner({Key? key, required this.banners})
      : super(key: key);

  @override
  State<BuildCarouselBanner> createState() => _BuildCarouselBannerState();
}

class _BuildCarouselBannerState extends State<BuildCarouselBanner> {
  PageController bannerController = PageController();
  ValueNotifier<int> bannerIndex = ValueNotifier(0);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 4),
      (Timer timer) {
        if (bannerIndex.value < (widget.banners.length - 1)) {
          bannerIndex.value++;
        } else {
          bannerIndex.value = 0;
        }
        if (bannerController.hasClients) {
          bannerController.animateToPage(
            bannerIndex.value,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 130,
          child: Stack(
            children: [
              PageView(
                controller: bannerController,
                physics: const BouncingScrollPhysics(),
                children: [
                  for (GetBanner bannerItem in widget.banners)
                    homeBannerItem(bannerItem),
                ],
                onPageChanged: (val) {
                  // setState(() {
                  bannerIndex.value = val;
                  // });
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        HelperWidgets.customPageViewIndicators(
          bannerController,
          widget.banners.length,
          true,
          8,
          dotColor: AppColors.zimkeyOrange,
        ),
      ],
    );
  }

  Widget homeBannerItem(GetBanner bannerItem) {
    return CachedNetworkImage(
      placeholder: (context, url) => Center(
        child: Container(
          height: double.infinity,
          margin: const EdgeInsets.only(right: 10, left: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.zimkeyLightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      imageUrl: Strings.mediaUrl + bannerItem.media!.url!,
      fadeInCurve: Curves.easeIn,
      fadeOutCurve: Curves.easeInOutBack,
    );
  }
}

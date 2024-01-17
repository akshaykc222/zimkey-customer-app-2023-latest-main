import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/model/home/home_response.dart';
import '../../../navigation/route_generator.dart';

class PopularService extends StatelessWidget {
  final List<GetPopularService> popularService;

  const PopularService({required this.popularService, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: popularService.isNotEmpty,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular services',
                style: TextStyle(
                  color: AppColors.zimkeyDarkGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              // controller: controller,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  width: 20,
                ),
                for (GetPopularService popServ in popularService)
                  homeServiceWidget(
                    popServ,
                    context,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget homeServiceWidget(GetPopularService service, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, RouteGenerator.serviceDetailsScreen, arguments: service.id),
      child: Container(
        width: MediaQuery.of(context).size.width / 3.4,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            service.thumbnail!=null
                ? CachedNetworkImage(
                    placeholder: (context, url) => Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.zimkeyLightGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      height: MediaQuery.of(context).size.height / 8,
                      // width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    imageUrl: Strings.mediaUrl + service.thumbnail!.url,
                    fadeInCurve: Curves.easeIn,
                    fadeOutCurve: Curves.easeInOutBack,
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 8,
                    // width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/servicePlaceholderThumb.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                ReCase(service.name!).titleCase,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.zimkeyDarkGrey,
                  // fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

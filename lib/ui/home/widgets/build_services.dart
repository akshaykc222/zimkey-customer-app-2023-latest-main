import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/model/home/home_response.dart';
import '../../../navigation/route_generator.dart';
import '../../../utils/helper/helper_widgets.dart';
import '../bloc/home_bloc.dart';

class BuildServices extends StatelessWidget {
  final HomeLoaded state;

  const BuildServices({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 13, right: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(
            state.homeResponse.getCombinedHome!.getHomeServices!.length,
            (index) => gridServiceItem(
                state.homeResponse.getCombinedHome!.getHomeServices![index],
                context)),
      ),
    );
  }

  Widget gridServiceItem(GetHomeService service, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteGenerator.serviceDetailsScreen,
            arguments: service.id);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.zimkeyGrey,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        width: MediaQuery.of(context).size.width / 4.8,
        height: MediaQuery.of(context).size.width / 4.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            service.icon!.url == null
                ? SvgPicture.asset(
                    Assets.iconDummyServices,
                    height: MediaQuery.of(context).size.width / 12.8,
                    width: MediaQuery.of(context).size.width / 12.8,
                  )
                : !(service.icon!.url!.contains('svg'))
                    ? Image.network(
                        Strings.mediaUrl + service.icon!.url!,
                        height: MediaQuery.of(context).size.width / 9.6,
                        width: MediaQuery.of(context).size.width / 9.6,
                      )
                    : SvgPicture.network(
                        Strings.mediaUrl + service.icon!.url!,
                        height: MediaQuery.of(context).size.width / 12.8,
                        width: MediaQuery.of(context).size.width / 12.8,
                      ),
            const SizedBox(
              height: 3,
            ),
            Center(
              child:HelperWidgets.buildText(text: service.name!,fontSize: 11,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2
              ),

            ),
          ],
        ),
      ),
    );
  }
}

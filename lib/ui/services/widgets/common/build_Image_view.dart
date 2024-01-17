import 'package:customer/utils/buttons/favourite/favourite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../bloc/services_bloc.dart';
import '../../cubit/calculate_service_cost_cubit.dart';
import 'service_thumbnail.dart';

class BuildImageView extends StatelessWidget {
  final SingleServiceLoaded state;
  final int currentStage;
  final Function({required int pageNo}) goToPage;

  const BuildImageView({Key? key, required this.state, required this.currentStage,required this.goToPage}) : super(key: key);

  // static double imageHeight = 0;
  @override
  Widget build(BuildContext context) {
    // imageHeight = HelperFunctions.screenHeight(context: context, dividedBy: 2);
    return Stack(
      children: [
        ServiceThumbnail(medias: state.serviceResponse.getService.medias),
        Positioned(
            top: 30,
            left: 10,
            child: GestureDetector(
              onTap: () {
                 if(currentStage==1){
                   BlocProvider.of<CalculatedServiceCostCubit>(context).changeButtonName(btnName: Strings.book);
                  goToPage(pageNo: 0);// Navigate back when back button is tapped
                }else if(currentStage==2){
                   BlocProvider.of<CalculatedServiceCostCubit>(context).changeButtonName(btnName: Strings.next);
                  goToPage(pageNo: 1);// Navigate back when back button is tapped
                }else{
                   Navigator.pop(context);
                 }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.transparent, // Semi-transparent color towards the edges
                    ],
                    stops: const [0.0, 0.6], // Adjust stops for desired gradient effect
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.zimkeyBlack,
                ),
              ),
            )),
        Positioned(
            top: 50,
            right: 30,
            child: FavoriteButton(serviceId: state.serviceResponse.getService.id,isFavourite:state.serviceResponse.getService.isFavorite,))
      ],
    );
  }
}

import 'package:customer/constants/assets.dart';
import 'package:customer/utils/buttons/favourite/cubit/favourite_cubit.dart';
import 'package:customer/utils/helper/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/colors.dart';
import '../../../data/provider/profile_provider.dart';

class FavoriteButton extends StatefulWidget {
  final bool isFavourite;
  final String serviceId;

  const FavoriteButton({Key? key, required this.isFavourite, required this.serviceId}) : super(key: key);

  @override
  State<FavoriteButton> createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  ValueNotifier<bool> isFavourite = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    isFavourite.value = widget.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteCubit(profileProvider: RepositoryProvider.of<ProfileProvider>(context)),
  child: BlocConsumer<FavouriteCubit, FavouriteState>(
      listener: (context, state) {
        if(state is FavouriteLoadedState) {
          isFavourite.value = state.response.updateFavoriteService;
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: isFavourite,
          builder: (BuildContext context, value, Widget? child) {
            return InkWell(
              child: state is FavouriteLoadingState?SizedBox(height: 25,width: 25,
                  child: Center(child: HelperWidgets.progressIndicator())): SvgPicture.asset(value ? Assets.heartFilled : Assets.heartEmpty,
                  height: 25,
                  width: 25,
                  colorFilter:  ColorFilter.mode(value?AppColors.zimkeyOrange:AppColors.zimkeyOrange2, BlendMode.srcIn)),
              onTap: () => state is FavouriteLoadingState?{}:BlocProvider.of<FavouriteCubit>(context).updateFavourite(serviceId: widget.serviceId, status: !value),
            );
          },

        );
      },
    ),
);
  }
}

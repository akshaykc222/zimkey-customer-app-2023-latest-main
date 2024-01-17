
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/colors.dart';
import '../../utils/helper/helper_widgets.dart';
import 'bloc/home_bloc.dart';
import 'widgets/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadHome());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.zimkeyWhite,
      body: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoaded) {
              // refreshController.refreshCompleted();
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: HelperWidgets.progressIndicator());
            } else if (state is HomeLoaded) {
              return HomeBody(
                homeLoadedState: state,
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

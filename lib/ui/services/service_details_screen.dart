import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../constants/colors.dart';
import '../../data/provider/schedule_provider.dart';
import '../../data/provider/services_provider.dart';
import '../../utils/helper/helper_functions.dart';
import '../../utils/helper/helper_widgets.dart';
import '../../utils/object_factory.dart';
import 'bloc/services_bloc.dart';
import 'cubit/calculate_service_cost_cubit.dart';
import 'cubit/overview_data_cubit.dart';
import 'widgets/1_build_option/build_options.dart';
import 'widgets/2_build_schedule/bloc/schedule_bloc.dart';
import 'widgets/2_build_schedule/build_schedule.dart';
import 'widgets/3_build_payment/build_payment.dart';
import 'widgets/common/build_Image_view.dart';
import 'widgets/common/build_total_and_button_view.dart';
import 'widgets/common/step_indicator.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String id;

  const ServiceDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  ValueNotifier<int> currentStageNoNotifier = ValueNotifier(0);

  late double imageHeight;
  late PageController _bookPageController;

  static const _kDuration = Duration(milliseconds: 500);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<OverviewDataCubit>(context).clearAllSelection();
    BlocProvider.of<CalculatedServiceCostCubit>(context)
        .clearTotalCalculation();
    BlocProvider.of<OverviewDataCubit>(context)
        .addMobileNum(ObjectFactory().prefs.getUserData().phone);
    _bookPageController = PageController(
        initialPage: currentStageNoNotifier.value, keepPage: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    currentStageNoNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageHeight =
        HelperFunctions.screenHeight(context: context, dividedBy: 2.5);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ScheduleBloc(
                scheduleProvider:
                    RepositoryProvider.of<ScheduleProvider>(context))),
        BlocProvider(
            create: (context) => ServicesBloc(
                servicesProvider:
                    RepositoryProvider.of<ServicesProvider>(context))
              ..add(LoadSingleService(id: widget.id))),
      ],
      child: GestureDetector(
        onTap: () => HelperFunctions.hideKeyboard(),
        child: Scaffold(
          body: BlocConsumer<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is SingleServiceLoaded) {
                BlocProvider.of<CalculatedServiceCostCubit>(context)
                    .setCurrentUnit(
                        unit: state.serviceResponse.getService.billingOptions
                            .first.minUnit);
                Logger().i(state.serviceResponse.getService.id);
                // currentUnit.value = state.serviceResponse.getService.billingOptions.first.minUnit;
                // Logger().i(state.serviceResponse.getService.billingOptions.first.minUnit);
              }
            },
            builder: (context, state) {
              if (state is ServicesLoading) {
                return Center(
                  child: HelperWidgets.progressIndicator(),
                );
              }
              if (state is SingleServiceLoaded) {
                return Stack(
                  children: [
                    Container(
                      color: AppColors.zimkeyWhite,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        // physics:const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ValueListenableBuilder(
                              valueListenable: currentStageNoNotifier,
                              builder: (BuildContext context, int value,
                                  Widget? child) {
                                return BuildImageView(
                                  state: state,
                                  currentStage: value,
                                  goToPage: goToPage,
                                );
                              },
                            ),
                            // SizedBox(height: imageHeight),
                            ValueListenableBuilder(
                              valueListenable: currentStageNoNotifier,
                              builder: (BuildContext context, int value,
                                  Widget? child) {
                                return StepIndicator(
                                  currentStage: value,
                                );
                              },
                            ),
                            ExpandablePageView(
                              physics: const NeverScrollableScrollPhysics(),
                              // physics: const BouncingScrollPhysics(),
                              onPageChanged: (value) =>
                                  currentStageNoNotifier.value = value,
                              controller: _bookPageController,
                              children: [
                                //step 1 - detail picker
                                BuildServiceOptions(
                                  service: state.serviceResponse.getService,
                                ),
                                const BuildSchedule(
                                    // service: state.serviceResponse.getService,
                                    ),
                                // step 3 - overview
                                BuildPayment(
                                    service: state.serviceResponse.getService,
                                    goToPage: goToPage)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    TotalAndButtonView(
                      goToPage: goToPage,
                    )
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  _buildPropertyType() {
    return Column(
      children: [],
    );
  }

  void goToPage({required int pageNo}) => _bookPageController.animateToPage(
        pageNo,
        duration: _kDuration,
        curve: _kCurve,
      );
}

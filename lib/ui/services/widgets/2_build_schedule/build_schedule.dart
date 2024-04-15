import 'package:customer/ui/profile/widgets/address/bloc/address_bloc.dart';
import 'package:customer/ui/services/widgets/2_build_schedule/widgets/1_month_and_date_view.dart';
import 'package:customer/utils/helper/helper_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/strings.dart';
import 'widgets/2_booking_slots_view.dart';
import 'widgets/3_address_list_view.dart';
import 'widgets/4_mobile_num_change_view.dart';

class BuildSchedule extends StatefulWidget {
  // final GetService service;

  // const BuildSchedule({Key? key, required this.service}) : super(key: key);
  const BuildSchedule({
    Key? key,
  }) : super(key: key);

  @override
  State<BuildSchedule> createState() => _BuildScheduleState();
}

class _BuildScheduleState extends State<BuildSchedule> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddressBloc>(context).add(FetchAddressEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HelperWidgets.buildTitle(Strings.selectDate),
        const MonthAndDateView(
          booking: true,
        ),
        const BookingSlotView(),
        const AddressListView(),
        const MobileNumUpdateView(),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * .15,
        )
      ],
    );
  }
}

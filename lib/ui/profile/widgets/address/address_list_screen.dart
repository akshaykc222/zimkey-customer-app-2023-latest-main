import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../services/widgets/2_build_schedule/widgets/3_address_list_view.dart';
import 'bloc/address_bloc.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddressBloc>(context).add(FetchAddressEvent());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.zimkeyWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme:const IconThemeData(
          color: AppColors.zimkeyBlack,
        ),
        leading: InkWell(
          onTap: () {
           Navigator.pop(context);
          },
          child:const Icon(
            Icons.chevron_left,
            color: AppColors.zimkeyDarkGrey,
            size: 30,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Container(
            color: AppColors.zimkeyWhite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address Book',
                            style: TextStyle(
                              color: AppColors.zimkeyBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Divider(
                  color: AppColors.zimkeyDarkGrey2.withOpacity(0.5),
                  height: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      body: const AddressListView(showAll: true,fromProfile: true,),
    );
  }
}

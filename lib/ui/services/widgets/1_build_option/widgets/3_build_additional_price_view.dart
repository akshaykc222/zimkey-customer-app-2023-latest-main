import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recase/recase.dart';

import '../../../../../constants/assets.dart';
import '../../../../../constants/colors.dart';

class BuildAdditionalPriceView extends StatelessWidget {
  const BuildAdditionalPriceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double additionalTotal = 4;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      // for (ServiceAdditionalPayment addl
      // in additionalPayments)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SvgPicture.asset(
              Assets.iconInformationProfile,
              colorFilter: const ColorFilter.mode(AppColors.zimkeyOrange, BlendMode.srcIn),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      const Text(
                        'This service includes an additional ',
                        style: TextStyle(
                          // fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      // if (addl != null &&
                      //     addl.refundable != null &&
                      //     addl.refundable)
                      const Text(
                        '(refundable) ',
                        style: TextStyle(
                          // fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'charge of ',
                        style: TextStyle(
                          // fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹$additionalTotal',
                        style: const TextStyle(
                          // fontSize: 14,
                          color: AppColors.zimkeyDarkGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // if (addl.description != null)
                  Text(
                    '*${ReCase("addl.description").sentenceCase}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.zimkeyOrange,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

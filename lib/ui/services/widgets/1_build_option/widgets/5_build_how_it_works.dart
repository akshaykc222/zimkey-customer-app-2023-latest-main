import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../../constants/colors.dart';
import '../../../../../data/model/services/single_service_response.dart';
import '../../../../../utils/helper/helper_functions.dart';
import '../../../../../utils/helper/helper_widgets.dart';

class BuildHowItWorks extends StatelessWidget {
  final GetService service;

  const BuildHowItWorks({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.zimkeyLightGrey,
          border: Border.all(
            color: AppColors.zimkeyDarkGrey.withOpacity(0.3),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'How it works',
                    style: TextStyle(
                      color: AppColors.zimkeyDarkGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() async => await HelperFunctions.launchURL('https://www.zimkey.in/')),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: const Center(
                      child: Text(
                        'T&C',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.zimkeyOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   child: HtmlWidget(
          //     service.description,
          //     customWidgetBuilder: (node) => HelperWidgets.htmlCustomRenderer(node),
          //   ),
          // )
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Html(shrinkWrap: true,
                    data: service.description,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

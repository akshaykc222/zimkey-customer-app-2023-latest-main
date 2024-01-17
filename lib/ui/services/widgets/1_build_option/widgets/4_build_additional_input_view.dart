import 'package:flutter/material.dart';

import '../../../../../constants/colors.dart';
import '../../../../../data/model/services/single_service_response.dart';

class BuildAdditionalInputsView extends StatefulWidget {
  final GetService service;

  const BuildAdditionalInputsView({Key? key, required this.service}) : super(key: key);

  @override
  State<BuildAdditionalInputsView> createState() => _BuildAdditionalInputsViewState();
}

class _BuildAdditionalInputsViewState extends State<BuildAdditionalInputsView> {
  TextEditingController additionalTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.service.inputs.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Additional Inputs',
              style: TextStyle(
                color: AppColors.zimkeyDarkGrey,
                fontSize: 14,
              ),
            ),
            // if (additionFieldsMap != null &&
            //     additionFieldsMap.isNotEmpty)
            //   for (ServiceInput inputItem
            //   in widget.service.inputs)
            //additional textfileds
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              decoration: BoxDecoration(color: AppColors.zimkeyLightGrey, borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: additionalTextEditingController,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 100,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  color: AppColors.zimkeyDarkGrey,
                  fontSize: 14,
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  counterText: '',
                  // hintText: '${widget.service.inputs[i].name}',
                  hintText: 'sample name',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.zimkeyDarkGrey.withOpacity(0.7),
                    fontWeight: FontWeight.normal,
                  ),
                  fillColor: AppColors.zimkeyOrange,
                  focusColor: AppColors.zimkeyOrange,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            // for (ServiceInput input
            // in widget.service.inputs)
            //   if (input.type
            //       .toString()
            //       .toLowerCase()
            //       .contains('location'))
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: InkWell(
                onTap: () async {
                  // if (!_serviceEnabled)
                  //   await onLocation();
                  // else
                  //   setState(() {
                  //     _serviceEnabled = false;
                  //   });
                },
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'This service requires current location to help our service partner.',
                        style: TextStyle(
                          color: AppColors.zimkeyDarkGrey,
                          // fontSize: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.check_circle,
                      color: AppColors.zimkeyOrange,
                      size: 25,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../constants/colors.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlViewerScreenArg htmlViewerScreenArg;
  const HtmlViewerScreen({Key? key,required this.htmlViewerScreenArg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.zimkeyWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: AppColors.zimkeyBlack,
        ),
        leading: InkWell(
          onTap: () {
           Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left,
            color: AppColors.zimkeyDarkGrey,
            size: 30,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Container(
            color: AppColors.zimkeyWhite,
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  htmlViewerScreenArg.title,
                  style: const TextStyle(
                    color: AppColors.zimkeyBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
      body: Container(
        color: AppColors.zimkeyWhite,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 10,
              ),
              Html(
                data: htmlViewerScreenArg.htmlData,

              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HtmlViewerScreenArg {
  final String htmlData;
  final String title;
  const HtmlViewerScreenArg({Key? key,required this.htmlData,required this.title});

}


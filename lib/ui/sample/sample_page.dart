import 'package:flutter/material.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({Key? key}) : super(key: key);

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        color: Colors.white,
        child: Center(
          child: buildCustomWidget(),
        ),
      ),
    );
  }

  Container buildCustomWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAvatharRow(),
          const SizedBox(
            height: 35,
          ),
          const Text(
            "Listen to our latest podcast.",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          buildPodCastContainer()
        ],
      ),
    );
  }

  Container buildPodCastContainer() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.45,
            ),
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
                child: Image.network("https://i.ytimg.com/vi/uk7sXO05Eu8/maxresdefault.jpg"),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("The School of Greatness",
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Lewis Howes is a New York Times best-selling author,",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Row buildAvatharRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                maxRadius: 40,
                child: Image.network(
                    "https://wohnbedarfduschen.ch/wp-content/uploads/2021/11/AdobeStock_244436923-800x800.jpeg"),
              ),
              const SizedBox(
                width: 10,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello!",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text("Carolin", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ),
        buildActionButton(iconData: Icons.account_balance_sharp, count: "3", onTap: () {}),
        const SizedBox(
          width: 10,
        ),
        buildActionButton(iconData: Icons.add_alert, count: "5", onTap: () {})
      ],
    );
  }

  Widget buildActionButton({required String count, required IconData iconData, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orangeAccent.shade100),
        child: Center(
          child: SizedBox(
            height: 35,
            width: 35,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Icon(
                  iconData,
                  size: 30,
                )),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orangeAccent.shade100),
                    child: Center(
                        child: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent.shade200,
                            ),
                            child: Center(
                              child: Text(
                                count,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

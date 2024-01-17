import 'package:get/get.dart';

class GetState extends GetxController {
  var isHomeListedServicesResponseLoaded = false.obs;
  // var homeListedServicesResponse = HomeListedServicesResponse().obs;
  var selectedAreaName = ''.obs;

  // setHomeListedServicesResponse(HomeListedServicesResponse val) {
  //   homeListedServicesResponse.value = val;
  // }

  setUserLoc(String areaName){
    selectedAreaName.value = areaName;
  }
}

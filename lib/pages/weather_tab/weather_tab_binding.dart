import 'package:get/get.dart';

import 'weather_tab_logic.dart';

class WeatherTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      WeatherTabLogic(),
      permanent: true,
    );
  }
}

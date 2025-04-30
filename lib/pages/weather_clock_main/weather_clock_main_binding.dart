import 'package:get/get.dart';

import 'weather_clock_main_logic.dart';

class WeatherClockMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeatherClockMainLogic());
  }
}

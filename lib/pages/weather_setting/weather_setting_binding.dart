import 'package:get/get.dart';

import 'weather_setting_logic.dart';

class WeatherSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeatherSettingLogic());
  }
}

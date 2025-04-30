import 'package:get/get.dart';

import 'get_failed_logic.dart';

class GetFailedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetFailedLogic());
  }
}

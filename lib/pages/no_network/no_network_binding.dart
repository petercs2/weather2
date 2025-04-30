import 'package:get/get.dart';

import 'no_network_logic.dart';

class NoNetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoNetworkLogic());
  }
}

import 'package:get/get.dart';
import '../controllers/traveler_info_controller.dart';

class TravelerInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelerInfoController>(() => TravelerInfoController());
  }
}
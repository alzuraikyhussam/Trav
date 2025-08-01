import 'package:get/get.dart';
import '../controllers/carriers_controller.dart';

class CarriersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarriersController>(() => CarriersController());
  }
}
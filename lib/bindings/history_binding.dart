import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
      fenix: true, // This will recreate the controller when needed
    );
  }
}

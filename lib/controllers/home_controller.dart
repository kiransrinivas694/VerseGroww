import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import '../models/verse.dart';
import '../services/verse_service.dart';

class HomeController extends GetxController {
  final VerseService _verseService = VerseService();
  final Rx<Verse?> todayVerse = Rx<Verse?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedMood = 'peaceful'.obs;

  @override
  void onInit() {
    super.onInit();
    loadTodayVerse();
    // Set up widget update interval
    HomeWidget.setAppGroupId('group.com.vrmg.versegroww');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  // Background callback for widget updates
  @pragma('vm:entry-point')
  static Future<void> backgroundCallback(Uri? uri) async {
    if (uri?.host == 'updateverse') {
      final controller = Get.find<HomeController>();
      await controller.loadTodayVerse();
    }
  }

  Future<void> loadTodayVerse() async {
    try {
      isLoading.value = true;
      final verse = await _verseService.getTodayVerse(selectedMood.value);
      todayVerse.value = verse;

      // Update the widget with new verse data
      if (verse != null) {
        await _updateWidget(verse);
      }
    } catch (e) {
      print('Error loading today\'s verse: $e');
      Get.snackbar(
        'Error',
        'Failed to load today\'s verse. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateMood(String mood) {
    selectedMood.value = mood;
    loadTodayVerse();
  }

  Future<void> refreshVerse() async {
    await loadTodayVerse();
  }

  Future<void> _updateWidget(Verse verse) async {
    try {
      // Save verse data for the widget
      await HomeWidget.saveWidgetData('verse_name', verse.name);
      await HomeWidget.saveWidgetData('verse_text', verse.text);
      await HomeWidget.saveWidgetData('verse_reference', verse.reference);
      await HomeWidget.saveWidgetData(
          'last_updated', DateTime.now().toIso8601String());

      // Update the widget
      await HomeWidget.updateWidget(
        androidName: 'VerseWidgetProvider',
        iOSName: 'VerseWidget',
      );

      print('Widget updated successfully with today\'s verse');
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  Future<void> addWidgetToHomeScreen() async {
    try {
      await HomeWidget.setAppGroupId('group.com.example.versegroww');
      await HomeWidget.updateWidget(
        androidName: 'VerseWidgetProvider',
        iOSName: 'VerseWidget',
      );
    } catch (e) {
      print('Error adding widget: $e');
    }
  }
}

import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import '../models/verse.dart';

class HomeController extends GetxController {
  final Rx<Verse> todayVerse = const Verse(
    name: 'John 3:16',
    text:
        'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
    reference: 'New International Version',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _updateWidget();
  }

  // This will be replaced with actual API call later
  void refreshVerse() {
    // Simulating API call
    todayVerse.value = const Verse(
      name: 'Philippians 4:13',
      text: 'I can do all things through Christ who strengthens me.',
      reference: 'New International Version',
    );
    _updateWidget();
  }

  Future<void> _updateWidget() async {
    try {
      await HomeWidget.saveWidgetData('verse_name', todayVerse.value.name);
      await HomeWidget.saveWidgetData('verse_text', todayVerse.value.text);
      await HomeWidget.updateWidget(
        androidName: 'VerseWidgetProvider',
        iOSName: 'VerseWidget',
      );
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

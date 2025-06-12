import 'package:get/get.dart';
import '../models/history_entry.dart';

class HistoryController extends GetxController {
  final RxList<HistoryEntry> entries = <HistoryEntry>[].obs;
  final RxBool isLoading = false.obs;
  final int pageSize = 10;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    // Simulating API call with static data
    final List<HistoryEntry> mockData = List.generate(
      20,
      (index) => HistoryEntry(
        verseNumber: 'Verse ${index + 1}',
        verseText:
            'This is a sample verse text for entry ${index + 1}. It contains some meaningful content that reflects the user\'s spiritual journey.',
        mood: index % 3 == 0
            ? 'Peaceful'
            : (index % 3 == 1 ? 'Grateful' : 'Reflective'),
        journalEntry:
            'Today I reflected on the meaning of this verse and how it relates to my life. I found new insights and understanding.',
        date: DateTime.now().subtract(Duration(days: index)),
      ),
    );

    entries.value = mockData.take(pageSize).toList();
  }

  void loadMoreData() {
    if (isLoading.value) return;

    isLoading.value = true;

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final List<HistoryEntry> mockData = List.generate(
        20,
        (index) => HistoryEntry(
          verseNumber: 'Verse ${index + 1 + (currentPage * pageSize)}',
          verseText:
              'This is a sample verse text for entry ${index + 1 + (currentPage * pageSize)}. It contains some meaningful content that reflects the user\'s spiritual journey.',
          mood: index % 3 == 0
              ? 'Peaceful'
              : (index % 3 == 1 ? 'Grateful' : 'Reflective'),
          journalEntry:
              'Today I reflected on the meaning of this verse and how it relates to my life. I found new insights and understanding.',
          date: DateTime.now()
              .subtract(Duration(days: index + (currentPage * pageSize))),
        ),
      );

      final newEntries =
          mockData.skip(currentPage * pageSize).take(pageSize).toList();
      if (newEntries.isNotEmpty) {
        entries.addAll(newEntries);
        currentPage++;
      }

      isLoading.value = false;
    });
  }
}

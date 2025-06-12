import 'package:get/get.dart';
import '../models/history_entry.dart';
import '../services/verse_service.dart';

class HistoryController extends GetxController {
  final VerseService _verseService = VerseService();
  final RxList<HistoryEntry> entries = <HistoryEntry>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  int _currentPage = 0;
  static const int _pageSize = 12;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh data when screen becomes active
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    print('verse load initial is called');
    _currentPage = 0;
    entries.clear();
    hasMore.value = true;
    await loadMoreData();
  }

  Future<void> loadMoreData() async {
    if (isLoading.value || !hasMore.value) return;

    try {
      isLoading.value = true;
      final historyData = await _verseService.getVerseHistory(
        limit: _pageSize,
        offset: _currentPage * _pageSize,
      );

      if (historyData.isEmpty) {
        hasMore.value = false;
        return;
      }

      final newEntries =
          historyData.map((data) => HistoryEntry.fromJson(data)).toList();

      if (newEntries.length < _pageSize) {
        hasMore.value = false;
      }

      entries.addAll(newEntries);
      _currentPage++;
    } catch (e) {
      print('Error loading history: $e');
      Get.snackbar(
        'Error',
        'Failed to load history. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateJournalEntry(String historyId, String journalEntry) async {
    try {
      final success =
          await _verseService.updateJournalEntry(historyId, journalEntry);
      if (success) {
        final index = entries.indexWhere((entry) => entry.id == historyId);
        if (index != -1) {
          final updatedEntry =
              entries[index].copyWith(journalEntry: journalEntry);
          entries[index] = updatedEntry;
        }
      }
    } catch (e) {
      print('Error updating journal entry: $e');
      Get.snackbar(
        'Error',
        'Failed to update journal entry. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

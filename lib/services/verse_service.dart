import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/verse.dart';

class VerseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get today's verse based on mood
  Future<Verse?> getTodayVerse(String mood) async {
    try {
      // Check if user already has a verse for today
      final today = DateTime.now().toIso8601String().split('T')[0];
      final existingVerseResponse = await _supabase
          .from('user_verse_history')
          .select('*, verses(*)')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .eq('viewed_at', today)
          .limit(1);

      // If we found an existing verse for today, return it
      if (existingVerseResponse.isNotEmpty) {
        return Verse.fromJson(existingVerseResponse.first['verses']);
      }

      // Get a new random verse for today
      final response = await _supabase.rpc('get_random_verse_by_mood', params: {
        'p_mood': mood,
        'p_user_id': _supabase.auth.currentUser!.id,
      }).limit(1);

      // If no verses available for this mood
      if (response.isEmpty) {
        print('No verses available for mood: $mood');
        return null;
      }

      final verse = Verse.fromJson(response.first);

      // Record this verse in user's history
      await _supabase.from('user_verse_history').insert({
        'user_id': _supabase.auth.currentUser!.id,
        'verse_id': verse.id,
        'mood': mood,
        'viewed_at': today,
      });

      return verse;
    } catch (e) {
      print('Error getting today\'s verse: $e');
      return null;
    }
  }

  // Get user's verse history
  Future<List<Map<String, dynamic>>> getVerseHistory({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      print("verse history is calleing");
      final response = await _supabase
          .from('user_verse_history')
          .select('*, verses(*)')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .order('viewed_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (response == null) return [];

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting verse history: $e');
      return [];
    }
  }

  // Update journal entry for a verse
  Future<bool> updateJournalEntry(String historyId, String journalEntry) async {
    try {
      await _supabase
          .from('user_verse_history')
          .update({'journal_entry': journalEntry})
          .eq('id', historyId)
          .eq('user_id', _supabase.auth.currentUser!.id);
      return true;
    } catch (e) {
      print('Error updating journal entry: $e');
      return false;
    }
  }
}

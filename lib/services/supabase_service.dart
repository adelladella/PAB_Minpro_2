import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getItems() async {
    final data = await supabase.from('items').select();
    return data;
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    await supabase.from('items').insert(item);
  }
  Future<void> updateItem(String id, Map<String, dynamic> item) async {
    await supabase.from('items').update(item).eq('id', id);
  }

  Future<void> deleteItem(String id) async {
    await supabase.from('items').delete().eq('id', id);
  }
}

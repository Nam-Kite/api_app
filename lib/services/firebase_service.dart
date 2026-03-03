import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dish.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Example: fetch documents from `items` collection.
  ///
  /// Any errors thrown by Firestore are caught and rethrown as [Exception].
  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      final snapshot = await _firestore.collection('items').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Firestore error: $e');
    }
  }

  /// Fetch a list of dishes stored in the `menu` collection.
  ///
  /// Documents are expected to contain `name` and `imageUrl` fields.
  /// This method maps each document to a [Dish] model defined in
  /// `lib/models/dish.dart`.
  Future<List<Dish>> fetchDishesFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('menu').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Dish(
          name: data['name']?.toString() ?? '',
          imageUrl: data['imageUrl']?.toString() ?? '',
          description: data['description']?.toString() ?? '',
          price: int.tryParse(data['price']?.toString() ?? '') ?? 0,
          isAvaiable: data['isAvaiable'] == true,
          category: data['category']?.toString() ?? '',
        );
      }).toList();
    } catch (e) {
      // Cloud Firestore throws PlatformException-like errors; permission denied
      // is common when the database rules are restrictive.  Wrap with a
      // clearer message so UI logs/debugs can differentiate.
      final message = e.toString().contains('permission-denied')
          ? 'Firestore error: permission denied. Check your security rules.'
          : 'Firestore error: $e';
      throw Exception(message);
    }
  }
}

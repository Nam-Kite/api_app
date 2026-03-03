import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  /// Helper executed in an isolate to convert raw maps into Dish objects.
  static List<Dish> _mapListToDishes(List<Map<String, dynamic>> raw) {
    return raw.map((data) => Dish.fromMap(data)).toList();
  }

  /// Fetch a list of dishes stored in the `menu` collection.
  ///
  /// Documents are expected to contain `name` and `imageUrl` fields.
  /// The map-to-model conversion is offloaded to a background isolate so that
  /// a large collection does not block the UI thread.
  Future<List<Dish>> fetchDishesFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('menu').get();
      // convert documents to simple maps first (maps are sendable across
      // isolates), then use compute() to do the heavy mapping work.
      final rawData = snapshot.docs
          .map((doc) => doc.data())
          .cast<Map<String, dynamic>>()
          .toList();
      return await compute(_mapListToDishes, rawData);
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

import '../models/dish.dart';
import 'firebase_service.dart';

class DishService {
  // The Firestore-backed service we already use elsewhere.
  final FirebaseService _firebase = FirebaseService();

  /// Fetches list of dishes from the `dishes` Firestore collection.
  ///
  /// Optionally throws an error when [shouldFail] is true so the
  /// consuming UI can display its error state (this flag is only
  /// used during testing with the mock toggle).
  Future<List<Dish>> fetchDishes({bool shouldFail = false}) async {
    try {
      if (shouldFail) {
        throw Exception('Network error: Unable to fetch dishes');
      }

      // Delegate to firebase service; any Firestore exceptions will
      // be wrapped by that method.
      return _firebase.fetchDishesFromFirestore();
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

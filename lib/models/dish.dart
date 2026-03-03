class Dish {
  final String name;
  final String imageUrl;
  final String description;
  final int price;
  final bool isAvaiable;
  final String category;

  Dish({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.isAvaiable,
    required this.category,
  });

  /// Convert a Dish to a simple map. Useful for sending through isolates.
  Map<String, dynamic> toMap() => {
    'name': name,
    'imageUrl': imageUrl,
    'description': description,
    'price': price,
    'isAvaiable': isAvaiable,
    'category': category,
  };

  /// Create a Dish from a map (e.g. from Firestore or an isolate result).
  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      name: map['name']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: int.tryParse(map['price']?.toString() ?? '') ?? 0,
      isAvaiable: map['isAvaiable'] == true,
      category: map['category']?.toString() ?? '',
    );
  }
}

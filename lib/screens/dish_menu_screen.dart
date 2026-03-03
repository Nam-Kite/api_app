import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../services/dish_service.dart';
import '../services/firebase_service.dart';

class DishMenuScreen extends StatefulWidget {
  const DishMenuScreen({super.key});

  @override
  State<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends State<DishMenuScreen> {
  late Future<List<Dish>> _futureDishes;
  final DishService _service = DishService();
  final FirebaseService _firebase = FirebaseService();
  bool _shouldFail = false;
  bool _useFirestore = false; // toggle between mock service and Firestore data

  // search
  List<Dish>? _allDishes;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  void _loadDishes() {
    _allDishes = null;
    if (_useFirestore) {
      _futureDishes = _firebase.fetchDishesFromFirestore();
    } else {
      _futureDishes = _service.fetchDishes(shouldFail: _shouldFail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu món ăn'),
        actions: [
          // Switch data source between mock and Firestore
          IconButton(
            icon: Icon(_useFirestore ? Icons.storage : Icons.dataset),
            tooltip: _useFirestore ? 'Use Firestore' : 'Use mock service',
            onPressed: () {
              setState(() {
                _useFirestore = !_useFirestore;
                _searchQuery = '';
                _searchController.clear();
                _loadDishes();
              });
            },
          ),
          // Toggle button for testing error state (only affects mock service)
          IconButton(
            icon: Icon(_shouldFail ? Icons.cloud_off : Icons.cloud),
            tooltip: _shouldFail ? 'Network OFF' : 'Network ON',
            onPressed: () {
              setState(() {
                _shouldFail = !_shouldFail;
                _searchQuery = '';
                _searchController.clear();
                _loadDishes();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm theo tên món ăn',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Dish>>(
              future: _futureDishes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Đang tải danh sách món ăn...'),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return _buildError(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final dishes = snapshot.data!;
                  // cache full list once
                  _allDishes ??= dishes;
                  final visible = _searchQuery.isEmpty
                      ? _allDishes!
                      : _allDishes!
                            .where(
                              (d) => d.name.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ),
                            )
                            .toList();
                  if (visible.isEmpty) {
                    return const Center(child: Text('Không tìm thấy món ăn'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final dish = visible[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: Image.network(
                                  dish.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                  errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dish.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (!dish.isAvaiable) ...[
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Hết hàng',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Text(
                                      '${dish.price}₫',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dish.category,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Không có dữ liệu'));
                }
              },
            ),
          ), // close Expanded
        ],
      ), // close Column
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải dữ liệu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _shouldFail = false;
                  _searchQuery = '';
                  _searchController.clear();
                  _loadDishes();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

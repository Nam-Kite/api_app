import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'firestore_screen.dart';
import 'dish_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> _futurePosts;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    _futurePosts = _api.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TH3 - Phạm Ngọc Minh Nam - 2351060471'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
            tooltip: 'View Firestore',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FirestoreScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            tooltip: 'Dish menu',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const DishMenuScreen()));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _fetch();
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

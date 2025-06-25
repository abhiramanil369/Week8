import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';
import 'create_post_screen.dart'; // ✅ Import this
import 'post_detail_screen.dart';
import '../models/post.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> futurePosts;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    futurePosts = ApiService.fetchPosts();
  }

  Future<void> _checkLoginStatus() async {
    final token = await TokenStorage.getToken();
    setState(() {
      isLoggedIn = token != null;
    });
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog Posts')),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading posts.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.summary),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(postId: post.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: _navigateToCreatePost,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

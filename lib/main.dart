import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostsApp extends StatefulWidget {
  const PostsApp({super.key});

  @override
  PostsAppState createState() => PostsAppState();
}

class PostsAppState extends State<PostsApp> {
  List<dynamic> posts = [];
  int currentPage = 0;
  int postsPerPage = 2;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> getPostsData() async {
    final apiUrl =
        'https://jsonplaceholder.typicode.com/posts?_start=$currentPage&_limit=$postsPerPage';

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        posts.addAll(data);
        currentPage += postsPerPage;
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to fetch posts data.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPostsData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getPostsData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    //*********************************
    //in answer sheet dispose will be Dispose
    //in ide pls change this to dispose()
    //************************************
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Posts')),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: posts.length + 1,
        //**********************
        //length will be Length
        //so pls change this to length
        //**********************
        itemBuilder: (ctx, index) {
          if (index == posts.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    getPostsData();
                  },
                  child: const Text('Load More'),
                ),
              ),
            );
          } else {
            final post = posts[index];
            return ListTile(
              leading: Text((index + 1).toString()),
              title: Text(post['title']),
              subtitle: Text(post['body']),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PostsApp(),
  ));
}
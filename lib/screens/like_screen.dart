import 'package:flutter/material.dart';

class LikeCounter extends StatefulWidget {
  const LikeCounter({super.key});

  @override
  State<LikeCounter> createState() => _LikeCounterState();
}

class _LikeCounterState extends State<LikeCounter> {
  int likedCount = 12;
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likedCount += isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Like Counter')),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$likedCount', style: const TextStyle(fontSize: 20)),

          IconButton(
            onPressed: toggleLike,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon((CupertinoIcons.home)),
        title: const Text('ChatHive'),
        actions: [
          // search button
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          //user profile
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add_comment_rounded)),
      ),
    );
  }
}
import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        child: FloatingActionButton(onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        }, child: const Icon(Icons.add_comment_rounded)),
      ),
    
      body: ListView.builder(
        itemCount:16,
        padding:EdgeInsets.only(top: mq.height*.01),
        physics: BouncingScrollPhysics(),
        itemBuilder:(context,index){
          return const ChatUserCard();
        } 
      )
    );
  }
}
import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/chat_user.dart';
import 'package:chat_hive/screens/profile_screen/profile_screen.dart';
import 'package:chat_hive/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  List<ChatUser> list =[];

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

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
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(user: APIs.me)));
          }, icon: const Icon(Icons.more_vert))
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(onPressed: () async {
          // await APIs.auth.signOut();
          // await GoogleSignIn().signOut();
        }, child: const Icon(Icons.add_comment_rounded)),
      ),
    
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context, snapshot) {
          
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:

              final data = snapshot.data?.docs;
              list=data?.map((e) => ChatUser.fromJson(e.data())).toList()??[];

              if(list.isNotEmpty){
                return ListView.builder(
                  itemCount: list.length,
                  padding:EdgeInsets.only(top: mq.height*.01),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    return ChatUserCard(user: list[index]);
                  } 
                );
              }else{
                return Text('No Conversations Yet!',
                  style: TextStyle(fontSize: 20, 
                  fontWeight: FontWeight.w300,
                  color: const Color.fromARGB(255, 114, 116, 113)),
                );
              }
          }
        },
      )
    );
  }
}
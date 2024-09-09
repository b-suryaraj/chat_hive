import 'dart:developer';

import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/chat_user.dart';
import 'package:chat_hive/screens/profile_screen/profile_screen.dart';
import 'package:chat_hive/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  List<ChatUser> _list =[];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message : $message');
      
      if(APIs.auth.currentUser!=null){
        if(message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
        if(message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
      }
      
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () { 
          if (_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
         },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon((CupertinoIcons.home)),
            title: _isSearching ? TextField(
              
              decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Search...'
                ,hintStyle: TextStyle(color: const Color.fromARGB(255, 190, 189, 189)),
              ),
              style: const TextStyle(fontSize:17, letterSpacing: 0.5, color: Colors.white),
              autofocus: true,
              onChanged: (val) {
                _searchList.clear();
        
                for(var i in _list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) 
                  || i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                };
              }
            ) 
            : Text('ChatHive'),
            actions: [
              // search button
              IconButton(onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
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
                  _list=data?.map((e) => ChatUser.fromJson(e.data())).toList()??[];
        
                  if(_list.isNotEmpty){
                    return ListView.builder(
                      itemCount:_isSearching ? _searchList.length : _list.length,
                      padding:EdgeInsets.only(top: mq.height*.01),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        return ChatUserCard(
                          user: 
                            _isSearching ? _searchList[index] : _list[index]);
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
        ),
      ),
    );
  }
}
import 'package:chat_hive/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatUserCard extends StatefulWidget{
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard>{
  @override
  Widget build(BuildContext context) {
    return Card(
      margin:EdgeInsets.symmetric(horizontal: mq.width*.03, vertical:4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){},
        child:const ListTile(
          leading: CircleAvatar(child:Icon(CupertinoIcons.person)),
          title : Text('Demo USer'),
          subtitle: Text('Last user message', maxLines: 1),
          trailing: Text(
            '12:00 PM',
            style: TextStyle(color: Colors.black54),  
          ),
        )
      )
    );
  }
}
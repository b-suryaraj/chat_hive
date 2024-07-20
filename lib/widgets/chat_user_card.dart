import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/helper/my_date_util.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/chat_user.dart';
import 'package:chat_hive/models/message.dart';
import 'package:chat_hive/screens/chat_screen/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget{
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard>{
  
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:EdgeInsets.symmetric(horizontal: mq.width*.03, vertical:4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(user: widget.user,)));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot){

            final data = snapshot.data?.docs;

            final list = data?.map((e)=> Message.fromJson(e.data())).toList() ??[];
            if(list.isNotEmpty){
              _message = list[0];
            }


             return ListTile(

              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.3),
                child: CachedNetworkImage(
                  height: mq.height*.055,
                  width:mq.height*.055,
                  imageUrl:widget.user.image,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => CircleAvatar(child:Icon(CupertinoIcons.person)),
                ),
              ),
              title : Text(widget.user.name),
              
              subtitle: Text(_message!= null ? _message!.msg: widget.user.about , maxLines: 1),
              trailing: _message ==null ? null 
              
              : _message!.read.isEmpty && _message!.fromid != APIs.user.uid
              ?Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ) 
              :
              Text(
                MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
                style: TextStyle(color: Colors.black54),  
              ),
            );
          },
        )
      )
    );
  }
}
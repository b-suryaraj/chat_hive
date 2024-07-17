import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ChatUserCard extends StatefulWidget{
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

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
        child: ListTile(

          // leading: CircleAvatar(child:Icon(CupertinoIcons.person)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.3),
            child: CachedNetworkImage(
              height: mq.height*.055,
              width:mq.height*.055,
              imageUrl:widget.user.image,
              errorWidget: (context, url, error) => CircleAvatar(child:Icon(CupertinoIcons.person)),
            ),
          ),
          title : Text(widget.user.name),
          
          subtitle: Text(widget.user.about, maxLines: 1),
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // trailing: Text(
          //   '12:00 PM',
          //   style: TextStyle(color: Colors.black54),  
          // ),
        )
      )
    );
  }
}
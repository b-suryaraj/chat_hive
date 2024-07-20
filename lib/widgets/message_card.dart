import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/helper/my_date_util.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromid 
    ? _greenMsg() 
    : _purpleMsg();
  }

  Widget _purpleMsg(){

    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
      // log('message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color:  Color.fromARGB(255, 237, 230, 250),
              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.9)),
              
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30))),
            child:Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
              )
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
        ),
      ],
    );
  }

  Widget _greenMsg(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        //message time
        Row(
          children: [
              
            SizedBox(width: mq.width * .04),

            if( widget.message.read.isNotEmpty)           
              const Icon(Icons.done_all_outlined, color: Colors.blue, size: 20),

            const SizedBox(width: 2.2),
              
            Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color:  Color.fromARGB(255, 212, 246, 213),
              border: Border.all(color: Colors.green.withOpacity(0.9)),
              
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
            child:Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
              )
          ),
        ),
      ],
    );
  }
}
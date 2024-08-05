import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/chat_user.dart';
import 'package:chat_hive/screens/view_profile_screen/view_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            children: [
              //user profile picture
              Positioned(
                top: mq.height * .09,
                left: mq.width * .135,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    width: mq.height * .2,
                    height: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl:user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(
                            child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              //user name
              Positioned(
                left: mq.width * .04,
                top: mq.height * .02,
                width: mq.width * .55,
                child: Text(user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              //info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      Navigator.pop(context);

                      //move to view profile screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.blue, size: 30),
                  ))
            ],
          )),
    );
  }
}
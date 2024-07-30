// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/helper/my_date_util.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/chat_user.dart';
import 'package:chat_hive/models/message.dart';
import 'package:chat_hive/screens/view_profile_screen/view_profile_screen.dart';
import 'package:chat_hive/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  List<Message> _list = [];
  bool _showEmoji = false ,  _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () { 
          if (_showEmoji){
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
         },
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: _appBar(),
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 245, 241, 252),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
        
                            if (_list.isNotEmpty) {
                              return SingleChildScrollView(
                                reverse: true,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount: _list.length,
                                  padding: EdgeInsets.only(top: mq.height * .01),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, int index) {
                                    return MessageCard(message: _list[index]);
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('Say Hii!👋', style: TextStyle(fontSize: 20)),
                              );
                            }
                        }
                      },
                    ),
                  ),

                  if (_isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2)
                    )
                  ),
                  _chatInput(),
                  if (_showEmoji) _emojiPicker(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context, 
            MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(stream : APIs.getUsersInfo(widget.user),builder: (context, snapshot){
          final data = snapshot.data?.docs;
          final list = 
            data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return Row(
          children: [

            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black54),
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .03),
              child: CachedNetworkImage(
                width: mq.height * .05,
                height: mq.height * .05,
                imageUrl: list.isNotEmpty? list[0].image : widget.user.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( list.isNotEmpty? list[0].name : widget.user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 2),
                Text(list.isNotEmpty 
                  ? list[0].isOnline 
                    ? 'Online'
                    : MyDateUtil.getLastActiveTime(context : context, lastActive :list[0].lastActive)
                  : MyDateUtil.getLastActiveTime(context : context, lastActive :widget.user.lastActive),

                 style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ],
        );
      
        }),
    ));
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: Icon(Icons.emoji_emotions,
                        color: Colors.deepPurpleAccent.withOpacity(0.9), size: 25),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.deepPurpleAccent.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async{
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: Icon(Icons.image,
                          color: Colors.deepPurpleAccent.withOpacity(0.9), size: 26)),
                  IconButton(
                      onPressed: () async{
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);  
                          await APIs.sendChatImage(widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: Icon(Icons.camera_alt_rounded,
                          color: Colors.deepPurpleAccent.withOpacity(0.9), size: 26)),
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';

                // Scroll to the bottom of the ListView when a new message is sent
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _emojiPicker() {
    return EmojiPicker(
                  textEditingController: _textController,
                  scrollController: _scrollController,
                  config: Config(
                    height: 300,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      emojiSizeMax: 28 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.2
                              : 1.0),
                    ),
                    swapCategoryAndBottomBar: false,
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: const CategoryViewConfig(),
                    bottomActionBarConfig: const BottomActionBarConfig(),
                    searchViewConfig: const SearchViewConfig(),
                  ),
                );
  }
}

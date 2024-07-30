import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/helper/dialog.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/models/chat_user.dart';
import 'package:chat_hive/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {

  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {

final _formKey = GlobalKey<FormState>();
String? _image;

  Future<void> _requestPermissions() async {
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted) {
    } else {
      
    }
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   await _requestPermissions();
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = pickedFile.path;
  //     });
  //     APIs.updateProfilePicture(File(_image!));
  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Screen'),
          
        ),
      
        floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton.extended(
                  backgroundColor: Colors.redAccent,
                  onPressed: () async{
                    Dialogs.showProgressBar(context);

                    await APIs.updateActiveStatus(false);
      
                    await APIs.auth.signOut().then((value) async {
                      await GoogleSignIn().signOut().then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);

                        APIs.auth = FirebaseAuth.instance;

                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                      });
                    });
                    
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
            ),
      
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height * .03),
                    
                  Stack(
                    children: [

                      _image != null ?

                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(mq.height * .1),
                        child: Image.file(File(_image!),
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover)
                        )

                      : ClipRRect(
                        borderRadius:
                            BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.add_a_photo_outlined, size: 22, color: Colors.deepPurple),
                        ),
                      )
                    ],
                  ),
                    
                  SizedBox(height: mq.height * .03),
                    
                  Text(widget.user.email,
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 16)),
                    
                  SizedBox(height: mq.height * .05),
                    
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val!=null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.deepPurpleAccent),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Asit Kumar',
                      label: const Text('Name')
                    ),
                  ),
                    
                  SizedBox(height: mq.height * .02),
                    
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val!=null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info_outline_rounded,
                            color: Colors.deepPurpleAccent),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. Feeling Happy',
                        label: const Text('About')),
                  ),
                    
                  SizedBox(height: mq.height * .05),
                    
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * .44, mq.height * .06)),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value){
                          Dialogs.showSnackbar(context, 'Profile Updated Successfully!');
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 28),
                    label: const Text('UPDATE', style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .08),
            children: [
              Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.5))),

              SizedBox(height: mq.height * .02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image3.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
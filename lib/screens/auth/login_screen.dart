import 'dart:developer';
import 'dart:io';

import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/helper/dialog.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/screens/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  
  bool _isAnimate = false;
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate = true;
      });
    });
  }

   _handleGoogleBtnClick() async {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async{
      Navigator.pop(context);

      if(user != null){
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if((await APIs.userExists())){
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }else {
          APIs.createUser().then((value) {
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch(e){
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context,'🛑 Something went wrong! Check Internet');
      return null;
    } 
  }

 

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Login to ChatHive'),
      ),
      body: Stack(children: [
        //app logo
        AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width* .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset('images/login_icon.png')),

        //google login button
        Positioned(
            bottom: mq.height * .15,
            left: mq.width * .08,
            width: mq.width * .85,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                    shape: const StadiumBorder(),
                    elevation: 1),

                // on tap
                onPressed:_handleGoogleBtnClick,

                //google icon
                icon: Image.asset('images/google.png', height: mq.height * .03),

                //login with google label
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ]),
                ))),
      ]),
    );
  }
}
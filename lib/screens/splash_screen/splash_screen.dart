import 'dart:developer';

import 'package:chat_hive/api/apis.dart';
import 'package:chat_hive/main.dart';
import 'package:chat_hive/screens/auth/login_screen.dart';
import 'package:chat_hive/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds:2500),(){

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white)
      );

      if(APIs.auth.currentUser != null){
        log('\nUser: ${APIs.auth.currentUser}');

        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }else{
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }

      });
  }

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.sizeOf(context);
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   title: const Text('Login to ChatHive'),
      // ),
      body: Stack(children: [
        //app logo
        Positioned(
          top: mq.height * .35,
          right: mq.width * .25,
          width: mq.width * .5,
          child: Image.asset('images/login_icon.png')
        ),

        //text below
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text('Hello, Konichiwa!👋',
            textAlign : TextAlign.center,
            style:TextStyle(
              fontSize: 16, color: Colors.black87,letterSpacing:.5
            )
          )
        )
      ]),
    );
  }
}
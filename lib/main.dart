import 'package:chat_hive/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';


late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
  .then((value) {
    _initializeFirebase();
    runApp(const MyApp());
    }
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatHive',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          // centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.deepPurple,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,  // Increased font size
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
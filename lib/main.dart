import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/provider/user_provider.dart';
import 'package:instagram_app/responsive/mobile.dart';
import 'package:instagram_app/responsive/responsive.dart';
import 'package:instagram_app/responsive/web.dart';
 
import 'package:instagram_app/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
import 'package:instagram_app/shared/snackbar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAfGsFfsQPhIu39W5VzXsSbEaSA_WljnD4",
            authDomain: "level4-instaaaaa.firebaseapp.com",
            projectId: "level4-instaaaaa",
            storageBucket: "level4-instaaaaa.appspot.com",
            messagingSenderId: "230268819679",
            appId: "1:230268819679:web:65fa191161a2366137316a"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return UserProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return const Resposive(
                myMobileScreen: MobileScerren(),
                myWebScreen: WebScerren(),
              );
            } else {
              return const Login();
            }
          },
        ),
        // home: Resposive(
        //   myMobileScreen: MobileScerren(),
        //   myWebScreen: WebScerren(),
        // ),
      ),
    );
  }
}

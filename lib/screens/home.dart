import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/post_design.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            widthScreen > 600 ? webBackgroundColor : mobileBackgroundColor,
        appBar: widthScreen > 600
            ? null
            : AppBar(
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.messenger_outline,
                      )),
                  IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(
                        Icons.logout,
                      )),
                ],
                backgroundColor: mobileBackgroundColor,
                title: SvgPicture.asset(
                  "assets/img/instagram.svg",
                  color: primaryColor,
                  height: 32,
                ),
              ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('postSSS').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return PostDesign(
                  data: data,
                );
              }).toList(),
            );
          },
        ));
  }
}

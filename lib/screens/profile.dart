import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/shared/colors.dart';

class Profile extends StatefulWidget {
  final String uiddd;

  const Profile({Key? key, required this.uiddd}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map userDate = {};
  bool isLoading = true;

  late int followers;
  late int following;
  late int postCount;
  late bool showFollow;

  getData() async {
    // Get data from DB

    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userSSS')
          .doc(widget.uiddd)
          .get();

      userDate = snapshot.data()!;

      followers = userDate["followers"].length;
      following = userDate["following"].length;

      showFollow = userDate["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);

//  To get posts length
      var snapshotPosts = await FirebaseFirestore.instance
          .collection('postSSS')
          .where("uid", isEqualTo: widget.uiddd)
          .get();

      postCount = snapshotPosts.docs.length;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return isLoading
        ? const Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userDate["username"]),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 22),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(125, 78, 91, 110),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(userDate["profileImg"]),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                postCount.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Posts",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          Column(
                            children: [
                              Text(
                                followers.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          Column(
                            children: [
                              Text(
                                following.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(33, 21, 0, 0),
                    width: double.infinity,
                    child: Text(userDate["title"])),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.white,
                  thickness: widthScreen > 600 ? 0.06 : 0.43,
                ),
                const SizedBox(
                  height: 9,
                ),
                widget.uiddd == FirebaseAuth.instance.currentUser!.uid
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 24.0,
                            ),
                            label: const Text(
                              "Edit profile",
                              style: TextStyle(fontSize: 17),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(0, 90, 103, 223)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: widthScreen > 600 ? 19 : 10,
                                      horizontal: 33)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: const BorderSide(
                                      color: Color.fromARGB(109, 255, 255, 255),
                                      // width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.logout,
                              size: 24.0,
                            ),
                            label: const Text(
                              "Log out",
                              style: TextStyle(fontSize: 17),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(143, 255, 55, 112)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: widthScreen > 600 ? 19 : 10,
                                      horizontal: 33)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )

// ________________________________________________________________

                    : showFollow
                        ?

// ____________________________________________________________

                        ElevatedButton(
                            onPressed: () async {
                              followers--;
                              setState(() {
                                showFollow = false;
                              });

                              // widget.uiddd ==> الشخص الغريب

                              await FirebaseFirestore.instance
                                  .collection("userSSS")
                                  .doc(widget.uiddd)
                                  .update({
                                "followers": FieldValue.arrayRemove(
                                    [FirebaseAuth.instance.currentUser!.uid])
                              });

                              await FirebaseFirestore.instance
                                  .collection("userSSS")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "following":
                                    FieldValue.arrayRemove([widget.uiddd])
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(143, 255, 55, 112)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 66)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            child: const Text(
                              "unfollow",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              followers++;
                              setState(() {
                                showFollow = true;
                              });

                              // widget.uiddd ==> الشخص الغريب

                              await FirebaseFirestore.instance
                                  .collection("userSSS")
                                  .doc(widget.uiddd)
                                  .update({
                                "followers": FieldValue.arrayUnion(
                                    [FirebaseAuth.instance.currentUser!.uid])
                              });

                              await FirebaseFirestore.instance
                                  .collection("userSSS")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "following":
                                    FieldValue.arrayUnion([widget.uiddd])
                              });
                            },
                            style: ButtonStyle(
                              // backgroundColor: MaterialStateProperty.all(
                              //     Color.fromARGB(0, 90, 103, 223)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 77)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Follow",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                const SizedBox(
                  height: 9,
                ),
                Divider(
                  color: Colors.white,
                  thickness: widthScreen > 600 ? 0.06 : 0.43,
                ),
                const SizedBox(
                  height: 19,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('postSSS')
                      .where("uid", isEqualTo: widget.uiddd)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Expanded(
                        child: Padding(
                          padding: widthScreen > 600
                              ? const EdgeInsets.all(66.0)
                              : const EdgeInsets.all(3.0),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    // snapshot.data!.docs  = [  {"imgPost": 000000000}, {"imgPost": 0000000}    ]

                                    snapshot.data!.docs[index]["imgPost"],
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator());
                                    },

                                    // "https://cdn1-m.alittihad.ae/store/archive/image/2021/10/22/6266a092-72dd-4a2f-82a4-d22ed9d2cc59.jpg?width=1300",
                                    // height: 333,
                                    // width: 100,

                                    fit: BoxFit.cover,
                                  ),
                                );
                              }),
                        ),
                      );
                    }

                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  },
                )
              ],
            ),
          );
  }
}

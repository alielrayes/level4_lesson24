import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:instagram_app/firebase_services/firestore.dart';
import 'package:instagram_app/screens/comments.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/heart_animation.dart';
import 'package:intl/intl.dart';

class PostDesign extends StatefulWidget {
  // current post
  final Map data;
  const PostDesign({Key? key, required this.data}) : super(key: key);

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  int commentCount = 0;
  bool showHeart = false;
  bool isLikeAnimating = false;

  getCommentCount() async {
    try {
      QuerySnapshot commentdata = await FirebaseFirestore.instance
          .collection("postSSS")
          .doc(widget.data["postId"])
          .collection("commentSSS")
          .get();

      setState(() {
        commentCount = commentdata.docs.length;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  showmodel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            FirebaseAuth.instance.currentUser!.uid == widget.data["uid"]
                ? SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await FirebaseFirestore.instance
                          .collection("postSSS")
                          .doc(widget.data["postId"])
                          .delete();
                    },
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Delete post",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : const SimpleDialogOption(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Can not delete this post ✋",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  onClickekonPic() async {
    setState(() {
      isLikeAnimating = true;
    });
    await FirebaseFirestore.instance
        .collection("postSSS")
        .doc(widget.data["postId"])
        .update({
      "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  @override
  void initState() {
    super.initState();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: mobileBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(
          vertical: 11, horizontal: widthScreen > 600 ? widthScreen / 6 : 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(125, 78, 91, 110),
                      ),
                      child: CircleAvatar(
                        radius: 33,
                        backgroundImage: NetworkImage(
                            // widget.snap["profileImg"],
                            // "https://i.pinimg.com/564x/94/df/a7/94dfa775f1bad7d81aa9898323f6f359.jpg"
                            // "https://static-ai.asianetnews.com/images/01e42s5h7kpdte5t1q9d0ygvf7/1-jpeg.jpg"
                            widget.data["profileImg"]),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Text(
                      widget.data["username"],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      showmodel();
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await onClickekonPic();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  // widget.snap["postUrl"],
                  // "https://cdn1-m.alittihad.ae/store/archive/image/2021/10/22/6266a092-72dd-4a2f-82a4-d22ed9d2cc59.jpg?width=1300",
                  widget.data["imgPost"],
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: const Center(
                                child: CircularProgressIndicator()));
                  },
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 111,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.data['likes']
                          .contains(FirebaseAuth.instance.currentUser!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods()
                              .toggleLike(postData: widget.data);
                        },
                        icon: widget.data['likes'].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                    data: widget.data,
                                    showTextField: true,
                                  )),
                        );
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_outline),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              width: double.infinity,
              child: Text(
                "${widget.data["likes"].length} ${widget.data["likes"].length > 1 ? "Likes" : "Like"}      ",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
              )),
          Row(
            children: [
              const SizedBox(
                width: 9,
              ),
              Text(
                widget.data["username"],
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 189, 196, 199)),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                // " ${widget.snap["description"]}",
                widget.data["description"],
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 189, 196, 199)),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                          data: widget.data,
                          showTextField: false,
                        )),
              );
            },
            child: Container(
                margin: const EdgeInsets.fromLTRB(10, 13, 9, 10),
                width: double.infinity,
                child: Text(
                  "view all $commentCount comments",
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                  textAlign: TextAlign.start,
                )),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 9, 10),
              width: double.infinity,
              child: Text(
                DateFormat('MMMM d, ' 'y')
                    .format(widget.data["datePublished"].toDate()),
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                textAlign: TextAlign.start,
              )),
        ],
      ),
    );
  }
}

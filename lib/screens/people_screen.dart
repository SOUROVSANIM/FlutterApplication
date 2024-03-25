import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/comment_section.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  late Query<Map<String, dynamic>> postsQuery;
  late ScrollController _scrollController;
  bool _loadingLike = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    postsQuery = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true);
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getUserInfo(
      QueryDocumentSnapshot<Map<String, dynamic>> post) async {
    String uid = post.data()['userId'];
    debugPrint('UID for post: $uid');

    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
    debugPrint('Users found:\n${users.docs}');
    if (users.docs.isEmpty) {
      return null;
    }

    final user = users.docs.first;

    debugPrint('User found');

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: postsQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> posts =
                snapshot.data!.docs;

            return ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: getUserInfo(posts[index]),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData || snapshot.data == null) {
                      String postId = posts[index].id;
                      int likes = 0; // Change this line to get likes count

                      return Card(
                        child: Column(
                          children: [
                            Text(
                                'Username: ${snapshot.data == null ? 'Not found' : snapshot.data!.id}'),
                            const Text('Post:'),
                            Text(posts[index].data()['postText']),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up),
                                  onPressed: _loadingLike
                                      ? null
                                      : () async {
                                          setState(() {
                                            _loadingLike = true;
                                          });

                                          final likeRef = FirebaseFirestore
                                              .instance
                                              .collection('likes')
                                              .where(Filter.and(
                                                  Filter('post_id',
                                                      isEqualTo:
                                                          posts[index].id),
                                                  Filter('reactor_id',
                                                      isEqualTo: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)));

                                          final doc =
                                              await likeRef.count().get();

                                          if (doc.count != null &&
                                              doc.count! > 0) {
                                            // Already liked, remove the like
                                            final likeDoc = await likeRef.get();
                                            await FirebaseFirestore.instance
                                                .collection('likes')
                                                .doc(likeDoc.docs.first.id)
                                                .delete();
                                          } else {
                                            // User didn't like the post yet
                                            await FirebaseFirestore.instance
                                                .collection('likes')
                                                .add({
                                              'post_id': posts[index].id,
                                              'reactor_id': FirebaseAuth
                                                  .instance.currentUser!.uid
                                            });
                                          }

                                          setState(() {
                                            _loadingLike = false;
                                          });
                                        },
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('likes')
                                        .where('post_id',
                                            isEqualTo: posts[index].id)
                                        .count()
                                        .get()
                                        .asStream(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                            '${snapshot.data!.count!} Likes');
                                      }

                                      if (snapshot.hasError) {
                                        return Text('Error loading likes');
                                      }

                                      return Text('Loading likes...');
                                    })),

                                //cooment part(url from comment screen)

                                IconButton(
                                  icon: Icon(Icons.comment),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CommentSection(url: postId)),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      debugPrint(snapshot.error.toString());
                      return const Text('Error fetching user or post data');
                    }

                    return const Text('Loading...');
                  }),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return const Text('Error loading posts...');
          }

          return const Text('Loading...');
        },
      ),
    );
  }
}

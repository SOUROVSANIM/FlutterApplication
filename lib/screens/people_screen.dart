import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/comment_section.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  late Query<Map<String, dynamic>> postsQuery;
  late ScrollController _scrollController;
  bool _loadingLike = false;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _posts = [];
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMore);
    postsQuery = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true);
    _firstLoad();
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

  void _loadMore() async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await postsQuery.startAfterDocument(_posts.last).get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _posts.addAll(querySnapshot.docs);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await postsQuery.get();
      setState(() {
        _posts = querySnapshot.docs;
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: getUserInfo(_posts[index]),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData || snapshot.data == null) {
                            String postId = _posts[index].id;

                            return Card(
                              child: Column(
                                children: [
                                  Text(
                                      'Username: ${snapshot.data == null ? 'Not found' : snapshot.data!.id}'),
                                  const Text('Post:'),
                                  Text(_posts[index].data()?['postText'] ?? ''),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                                    .where('post_id',
                                                        isEqualTo:
                                                            _posts[index].id)
                                                    .where('reactor_id',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid);

                                                final doc =
                                                    await likeRef.count().get();

                                                if (doc.count != null &&
                                                    doc.count! > 0) {
                                                  // Already liked, remove the like
                                                  final likeDoc =
                                                      await likeRef.get();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('likes')
                                                      .doc(
                                                          likeDoc.docs.first.id)
                                                      .delete();
                                                } else {
                                                  // User didn't like the post yet
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('likes')
                                                      .add({
                                                    'post_id': _posts[index].id,
                                                    'reactor_id': FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid
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
                                                  isEqualTo: _posts[index].id)
                                              .snapshots(),
                                          builder: ((context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                  '${snapshot.data!.docs.length} Likes');
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error loading likes');
                                            }

                                            return Text('Loading likes...');
                                          })),

                                      //comment part(url from comment screen)

                                      IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentSection(
                                                        url: postId)),
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
                            return const Text(
                                'Error fetching user or post data');
                          }

                          return const Text('Loading...');
                        }),
                      );
                    },
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.amber,
                    child: const Center(
                      child: Text('You have fetched all of the content'),
                    ),
                  ),
              ],
            ),
    );
  }
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pages/Page1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Page2 extends StatefulWidget {
  final String url;

  const Page2({Key key, this.url}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  VideoPlayerController playerController;
  bool looping;
  bool autoplay;
  bool _isPlaying = false;
  Duration _duration;
  Duration _position;
  bool _isEnd = false;
  Future<void> _initializeVideoPlayerFuture;

  var userID;

  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.asset('${widget.url}')
      ..addListener(() {
        final bool isPlaying = playerController.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
        Timer.run(() {
          this.setState(() {
            _position = playerController.value.position;
          });
        });
        setState(() {
          _duration = playerController.value.duration;
        });
        _duration?.compareTo(_position) == 0 ||
                _duration?.compareTo(_position) == -1
            ? this.setState(() {
                _isEnd = true;
              })
            : this.setState(() {
                _isEnd = false;
              });
      })
      ..initialize();

    _initializeVideoPlayerFuture = playerController.initialize();

    playerController.setLooping(true);

    getvideostatus();
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }

  dynamic _counter = 1;

  Future<void> _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.get('userID');

    if (_position.inSeconds == 0 && playerController.value.isPlaying) {
      setState(() {
        firestore.collection('VideoStatus').doc(userID).update({
          "viewcount": "${cnt == null ? 0 + _counter : cnt + _counter}",
        }).then((value) {
          print('value');
        });
      });
    } else {
      setState(() {
        _counter;
      });
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  User firebaseUser = FirebaseAuth.instance.currentUser;

  dynamic count;

  var cnt;

  void getvideostatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.get('userID');

    firestore.collection('VideoStatus').doc(userID).get().then((value) {
      setState(() {
        count = value.data()['viewcount'].toString();
        cnt = int.parse(count);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: playerController.value.aspectRatio,
                    child: VideoPlayer(playerController),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          Positioned(
            top: 50,
            left: 30,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Page1()));
                },
              ),
            ),
          ),

          Positioned(
            right: 30,
            bottom: 50,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (playerController.value.isPlaying) {
                    playerController.pause();
                  } else {
                    playerController.play();
                    _incrementCounter();
                  }
                });
              },
              child: Icon(
                playerController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            ),
          ),

          Positioned(
            top: 50,
            right: 30,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Text(
                'Live',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 30,
            child: Text(
              count == null || count == 0 ? '0 views' : '$count views',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

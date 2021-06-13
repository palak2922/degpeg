import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class sample extends StatefulWidget {
  @override
  _sampleState createState() => _sampleState();
}

class _sampleState extends State<sample> {

  VideoPlayerController _controller;
  bool _isPlaying = false;
  Duration _duration;
  Duration _position;
  bool _isEnd = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'images/v4.mp4',
    )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
        Timer.run(() {
          this.setState((){
            _position = _controller.value.position;
          });
        });
        setState(() {
          _duration = _controller.value.duration;
        });
        _duration?.compareTo(_position) == 0 || _duration?.compareTo(_position) == -1 ? this.setState((){
          _isEnd = true;
          print('END : $_isEnd');
        }) : this.setState((){
          _isEnd = false;
        });
      })
      ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _position.toString(),
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height*1.6,
          child: Stack(
              children: <Widget> [
                _controller.value.initialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(),
                Positioned(
                  bottom: 50,
                    left: 30,
                    child: Column(
                      children: [
                        Text('Duration ${_duration?.toString()}'),
                        Text('Position ${_position?.toString()}'),
                        Text('isEnd?  $_isEnd'),
                  ],
                ))
              ]
          ),
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: _controller.value.isPlaying
              ? _controller.pause
              : _controller.play,
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


class RoundedButton extends StatefulWidget {

  final String name;
  final Function onpresses;
  final Color color;
  final Icon icon;

  RoundedButton({@required this.name, @required this.onpresses, @required this.color, this.icon});

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}


class _RoundedButtonState extends State<RoundedButton> with SingleTickerProviderStateMixin{

  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }


  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
        scale: _scale,
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            elevation: 10,
            color: Colors.white,//pinkAccent,//white,
            textColor: widget.color,
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.icon,
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 19,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            onPressed: widget.onpresses,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
          ),
        ),
      ),
    );
  }
}

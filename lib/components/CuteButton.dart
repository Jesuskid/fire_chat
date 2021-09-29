import 'package:flutter/material.dart';


class CuteButton extends StatelessWidget {
  VoidCallback? pressed;
  Color? color;
  String? text;

  CuteButton({this.text, this.pressed, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: pressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

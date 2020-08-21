import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPressed;

  Button({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: ButtonTheme(
        minWidth: 300.0,
        height: 48.0,
        child: RaisedButton(
          onPressed: this.onPressed,
          child: Text(
            this.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.white,
        child: SizedBox(
          height: 400.0,
          width: 400.0,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 300.0,
                  width: 300.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kRed),
                    strokeWidth: 15.0,
                  ),
                ),
              ),
              Center(
                child: TypewriterAnimatedTextKit(
                  text: ['Oops an error', ' has occurred ...'],
                  totalRepeatCount: 10,
                  speed: Duration(milliseconds: 200),
                  pause: Duration(milliseconds: 1000),
                  textStyle: TextStyle(
                      color: kRed,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.error_outline,
                    size: 100.0,
                    color: kRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

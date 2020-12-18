import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.white,
        child: SizedBox(
          height: 400.0,
          width: 400.0,
          child: Stack(
            textDirection: TextDirection.ltr,
            children: [
              Center(
                child: Container(
                  height: 300.0,
                  width: 300.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kLightBlue),
                    strokeWidth: 15.0,
                  ),
                ),
              ),
              Center(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: TypewriterAnimatedTextKit(
                    text :['Loading ...'],
                    totalRepeatCount: 10,
                    speed: Duration(milliseconds: 200),
                    pause: Duration(milliseconds: 1000),
                    textStyle: TextStyle(
                        color: kLightBlue, fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

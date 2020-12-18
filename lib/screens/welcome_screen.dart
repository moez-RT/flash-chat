import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/button_component.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget  {
  static String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin  {
  AnimationController controller;
  Animation animation;
  Animation animation1;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
    animation1 = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {
      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation1.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  totalRepeatCount: 10,
                  pause: Duration(milliseconds: 1000),
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black
                  ),
                  textAlign: TextAlign.start,

                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ButtonComponent(color: Colors.lightBlueAccent,text:'Log In', onPressed: () { Navigator.pushNamed(context, LoginScreen.id);}),
            ButtonComponent(color: Colors.blueAccent,text:'Register', onPressed: () { Navigator.pushNamed(context, RegistrationScreen.id);}),

          ],
        ),
      ),
    );
  }
}

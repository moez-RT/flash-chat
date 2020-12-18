import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';

import '../constants.dart';
import 'button_component.dart';

class FormComponent extends StatefulWidget {
  final String text;
  final Color background;
  final bool login;

  FormComponent({@required this.text, @required this.background, @required this.login});

  @override
  _FormComponentState createState() => _FormComponentState();
}

class _FormComponentState extends State<FormComponent> {
  String email;
  String password;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool validateEmail = false;
  bool validatePassword = false;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 400.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Form(
                key: _formKey,

                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty | !(EmailValidator.validate(value))) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty | (value.length < 6)) {
                          return 'Invalid Password or Weak password ';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              ButtonComponent(
                  color: widget.background,
                  text: widget.text,
                  onPressed: () async {
                    try {
                      setState(() {
                        showSpinner = true;
                      });
                      if (_formKey.currentState.validate()) {
                        if (widget.login) {
                          final loggedUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (loggedUser != null) {
                            _passwordController.clear();
                            _emailController.clear();
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        }
                        else {
                          final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                          if (newUser != null) {
                            _passwordController.clear();
                            _emailController.clear();
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        }}
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      print(e);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flash_chat/components/form_component.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  static String id = '/login';
  @override
  Widget build(BuildContext context) {
    return FormComponent(background: Colors.lightBlueAccent, text: 'Log In', login: true,);
  }
}

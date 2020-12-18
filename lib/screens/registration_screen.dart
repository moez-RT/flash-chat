import 'package:flash_chat/components/form_component.dart';
import 'package:flutter/material.dart';


class RegistrationScreen extends StatelessWidget {
  static String id = '/register';

  @override
  Widget build(BuildContext context) {
    return FormComponent(background: Colors.blueAccent, text: 'Register', login: false,);


}}

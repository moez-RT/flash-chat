import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

final _auth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  final _storage = FirebaseStorage.instance;
  User currentUser;
  final picker = ImagePicker();

  clearSelection() {
    setState(() {
      _image = null;
    });
  }

  Future chooseFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  setUserProfileUrl(String uri) async {
    User user = _auth.currentUser;
    await user.updateProfile(photoURL: uri);
  }

  Future uploadFile() async {
    var snapshot = await _storage
        .ref()
        .child('profiles/${Path.basename(_image.path)}')
        .putFile(_image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    await setUserProfileUrl(downloadUrl);
    setState(() {
      _image = null;
      currentUser = _auth.currentUser;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/back.jpg'), fit: BoxFit.cover)),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Container(
                alignment: Alignment(0.0, 2.5),
                child: CircleAvatar(
                  backgroundImage: currentUser.photoURL != null?
                      NetworkImage(currentUser.photoURL ):
                  AssetImage('images/default.png'),
                  radius: 60.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Text(
            "Email : ${currentUser.email}",
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.blueGrey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Address : Tunis , Tunisia",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
          ),
          _image != null
              ? CircleAvatar(
                backgroundImage: AssetImage(
                    _image.path,
                  ),
            radius: 45.0,

          )
              : Container(
                  margin: EdgeInsets.all(15.0),
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.lightBlueAccent, width: 2.0),
                        top: BorderSide(
                            color: Colors.lightBlueAccent, width: 2.0),
                        right: BorderSide(
                            color: Colors.lightBlueAccent, width: 2.0),
                        left: BorderSide(
                            color: Colors.lightBlueAccent, width: 2.0),
                      )),
                  child: Center(
                    child: RaisedButton(
                      child: Text(
                        'Choose File',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: chooseFile,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
          _image != null
              ? RaisedButton(
                  child: Text(
                    'Upload File',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: uploadFile,
                  color: Colors.lightBlueAccent,
                )
              : Container(),
          _image != null
              ? RaisedButton(
                  child: Text(
                    'Clear Selection',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: clearSelection,
                )
              : Container(),
        ],
      ),
    );
  }
}

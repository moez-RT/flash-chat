import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:ListView(

        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Expanded(
            child: Container(
              child: DrawerHeader(
                child: Text('⚡️Chat', style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_rounded),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign out'),
            onTap: () {

              Navigator.pop(context);
            },
          ),
        ],
      ), // Populate the Drawer in the next step.
    );
  }
}

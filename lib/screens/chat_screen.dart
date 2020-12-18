import 'package:flash_chat/components/drawer_component.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class _ChatScreenState extends State<ChatScreen> {
  final _msgController = TextEditingController();
  User loggedInUser;
  String messageText;
  PageController _controller = PageController(
    initialPage: 0,

  );
  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  @override
  void dispose() {
    _controller.dispose();
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerComponent(),
      appBar: AppBar(
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: PageView(
          controller: _controller,

          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Material(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    color: Colors.blueGrey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child:
                              Text('You are logged in as ${loggedInUser.email}')),
                    )),
                MessageStream(
                  loggedInUser: loggedInUser,
                ),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _msgController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          final msg = messageText.trim();
                          if (msg != '') {
                            _fireStore.collection('messages').add({
                              'sender': loggedInUser.email,
                              'text': msg,
                              'timestamp': DateTime.now().millisecondsSinceEpoch
                            });
                            _msgController.clear();
                          }
                        },
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  final User loggedInUser;

  MessageStream({this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kLightBlue,
            ),
          );
        }

        List<MessageBubble> messageBubbles = [];
        final messages = snapshot.data.docs.reversed;
        for (var msg in messages) {
          final msgText = msg['text'];
          final sender = msg['sender'];
          final bool c = sender == loggedInUser.email;
          messageBubbles
              .add(MessageBubble(text: msgText, sender: sender, isMe: c));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final List<Color> backgroundColors = [Colors.lightBlue, Colors.grey[300]];

  final List<Color> textColors = [Colors.white, Colors.black];

  MessageBubble(
      {@required this.text, @required this.sender, @required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            'Sent by : $sender',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 5.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .6,
            child: Material(
              color: isMe ? backgroundColors[0] : backgroundColors[1],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                  topLeft: Radius.circular(isMe ? 40.0 : 0),
                  topRight: Radius.circular(isMe ? 0 : 40.0)),
              elevation: 7.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isMe ? textColors[0] : textColors[1],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

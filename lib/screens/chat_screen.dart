// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

String email='';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  var messageController = TextEditingController();
  var loggedInUser;
  String? message;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
  }

  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        email = loggedInUser.email;
        print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

  // void getMessages() async{
  //   final messages = await _firestore.collection('messages').get();
  //   for(var message in messages.docs){
  //     print(message.data()['sender']);
  //   }
  // }

  void messageStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()) {
      for(var message in snapshot.docs){
         print(message.data()['text']);
        }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messageStream();
               //_auth.signOut();
               //Navigator.pushNamed(context, LoginScreen.id);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.black54),
                      onChanged: (value) {
                        message = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageController.clear();
                      //Implement send functionality.

                      _firestore.collection('messages').add({'text': message, 'sender':loggedInUser.email,  'createdOn': FieldValue.serverTimestamp(),});

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

      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('createdOn').snapshots(),
      builder: (context, snapshot){
        List<Widget> messageList = [];
      if(!snapshot.hasData){
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
      else{
        final messages = snapshot.data?.docs.reversed;
        for (var message in messages!){
          Map<String, dynamic> valueReturned = message.data() as Map<String, dynamic>;
          print(valueReturned);
          final currentUser = email;

          final messageWidget = MessageBubble(
              message:valueReturned['text'],
              sender:valueReturned['sender'],
              isMe: currentUser == valueReturned['sender'],
          );
          messageList.add(messageWidget);
          print(messageList);

          if(currentUser == valueReturned['sender']){

          }

        }
      }

      return Expanded(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          reverse: true,
          children: messageList,
        ),
      );
    },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.message, this.sender, this.isMe});

  final String? sender;
  final String? message;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$sender', style: TextStyle(fontSize: 12.0, color: Colors.black54),),
          Material(
          elevation: 5.0,
          borderRadius: isMe! ? kBorderMessageMe : kBorderMessageYou,
          color: isMe! ? Colors.lightBlueAccent: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text('$message',
                style: TextStyle(color:isMe! ? Colors.white : Colors.black54, fontSize: 15.0),),
            ),
        ),
        ],
      ),
    );
  }
}

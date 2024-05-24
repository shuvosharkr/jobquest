import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final String receiveEmail;

  const ChatRoom({Key? key, required this.receiveEmail}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    chatRoomId = _generateChatRoomId(_auth.currentUser!.email!, widget.receiveEmail);
    _markMessagesAsSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiveEmail)),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final messages = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index].data() as Map<String, dynamic>;
              final isCurrentUser = message['senderEmail'] == _auth.currentUser!.email;
              final messageText = message['message'] ?? 'No message';
              final senderEmail = isCurrentUser ? 'You' : (message['senderEmail'] ?? 'Unknown sender');
              final messageTime = (message['timestamp'] as Timestamp).toDate();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messageText,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${DateFormat('yyyy-MM-dd hh:mm a').format(messageTime)}', // Format timestamp
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        senderEmail,
                        style: TextStyle(color: Colors.grey),
                        textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

 Widget _buildMessageComposer() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter your message...',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 43, 1, 1)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    ),
  );
}


  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      String currentUserId = _auth.currentUser!.uid;
      String currentUserEmail = _auth.currentUser!.email!;
      Timestamp timestamp = Timestamp.now();

      _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderID': currentUserId,
        'senderEmail': currentUserEmail,
        'receiverEmail': widget.receiveEmail,
        'message': messageText,
        'timestamp': timestamp,
        'seen': false, // Mark message as unseen initially
      });
      _messageController.clear();
    }
  }

  void _markMessagesAsSeen() {
    _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverEmail', isEqualTo: _auth.currentUser!.email)
        .where('seen', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'seen': true});
      }
    });
  }

  String _generateChatRoomId(String currentUserEmail, String receiveEmail) {
    List<String> emails = [currentUserEmail, receiveEmail];
    emails.sort();
    return emails.join('_');
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.blue : Colors.green,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['message'] ?? 'No message',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            message['senderEmail'] ?? 'Unknown sender',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Enter your message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
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

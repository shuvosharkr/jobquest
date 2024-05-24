import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobquest/chat/ChatRoom.dart';
import 'package:jobquest/chat/UserTile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User List')),
        leading: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search User'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Enter email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = _searchController.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
          final documents = snapshot.data?.docs ?? [];
          final currentUserEmail = _auth.currentUser!.email;

          final otherUsers = documents.where((doc) {
            final email = doc['email'];
            return email != currentUserEmail &&
                (_searchQuery.isEmpty || email.contains(_searchQuery));
          }).toList();

          if (otherUsers.isEmpty) {
            return const Center(
              child: Text('User not found'),
            );
          }

          return ListView(
            children: otherUsers.map((doc) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat_rooms')
                    .doc(_generateChatRoomId(currentUserEmail!, doc['email']))
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return UserTile(
                      text: doc['email'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatRoom(receiveEmail: doc['email']),
                          ),
                        );
                      },
                    );
                  } else {
                    final lastMessage = snapshot.data!.docs.first;
                    final isUnseen = lastMessage['receiverEmail'] == currentUserEmail && !lastMessage['seen'];
                    return UserTile(
                      text: doc['email'],
                      textColor: isUnseen ? Colors.blue : Colors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatRoom(receiveEmail: doc['email']),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }).toList(),
          );
        }
      },
    );
  }

  String _generateChatRoomId(String currentUserEmail, String receiveEmail) {
    List<String> emails = [currentUserEmail, receiveEmail];
    emails.sort();
    return emails.join('_');
  }
}
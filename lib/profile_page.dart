import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobquest/text_box.dart';
import 'package:jobquest/wall_post.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;

  // All users collection
  final usersCollection = FirebaseFirestore.instance.collection('users');

  final postsCollection = FirebaseFirestore.instance.collection('User Posts');

  // Edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // Save button
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    // Update in Firestore
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 82, 79, 79),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid) // Use the uid to fetch the document
            .snapshots(),
        builder: (context, snapshot) {
          // Check if the document exists and has data
          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null) {
              return Center(
                child: Text('No data found'),
              );
            }

            return ListView(
              children: [
                const SizedBox(height: 50),

                // Profile pic
                const Icon(Icons.person, size: 72),

                const SizedBox(height: 10),

                // Email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),

                const SizedBox(height: 50),

                // User details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Reviews',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),

                // Username
                MyTexBox(
                  text: userData['username'],
                  sectionName: 'Username',
                  onPrssed: () => editField('username'),
                ),

                // Bio
                MyTexBox(
                  text: userData['bio'],
                  sectionName: 'Bio',
                  onPrssed: () => editField('bio'),
                ),

                const SizedBox(height: 50),

                // User posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),

                // Display user posts in a scrollable widget
                Container(
                  height: 200, // Adjust the height as per your requirement
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: postsCollection
                              .where('UserEmail', isEqualTo: currentUser.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final post = snapshot.data!.docs[index];
                                  return WallPost(
                                    message: post['Message'],
                                    User: post['UserEmail'],
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

//Done
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobquest/CreateJob.dart';
import 'package:jobquest/JobPost.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userEmail;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });
    } else {
      // Handle the case where no user is logged in
      userEmail = 'No user logged in';
    }
  }

  final textController = TextEditingController();

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true, // Center the title
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //Job wall
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Job Posts").orderBy("deadline", descending: false).snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                        //get the jobs
                        final post = snapshot.data!.docs[index];
                        return JobPost(
                          jobname: post['JobName'],
                          user: post["user"],
                          course: post["course"],
                          description: post["description"],
                          deadline: post["deadline"],
                          pay: post["pay"],
                        );
                      });
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text("Error: " + snapshot.error.toString()),
                        );
                    }
                    return const Center(child: CircularProgressIndicator(),
                    );
                  },
        
                ),
              ),
          
              //Job Post
              Padding(
                padding: EdgeInsets.all(25),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( //Go to Create Job  Screen
                              onPressed: () {
                              Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => CreateJob()),
                            );
            },
            child: const Text('Go to Create Job'),
          ),
                    ),
                  ],
                ),
              ),
          
              //Logged in as
              Text('Logged in as: $userEmail'),
            ],
          ),
        ),
      ),
        
    );
  }
}

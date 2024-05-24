// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//Done
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobquest/JobWall.dart';

class CreateJob extends StatefulWidget {
  const CreateJob({super.key});

  @override
  State<CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
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
  final _jobNameController = TextEditingController();
  final _courseController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _payController = TextEditingController();
  // final _userController = TextEditingController();
   

  // Firestore reference
  final CollectionReference _jobsCollection =
      FirebaseFirestore.instance.collection('Job Posts');
  final FirebaseFirestore _firestore1= FirebaseFirestore.instance;

  void postJob() async {
    if(_jobNameController.text.isNotEmpty){
      await FirebaseFirestore.instance.collection("Job Posts").add({
      'JobName' : _jobNameController.text.trim(),
      'course' : _courseController.text.trim(),
      'description' : _descriptionController.text.trim(),
      'deadline' : _deadlineController.text.trim(),
      'pay' : _payController.text.trim(),
      'user' : userEmail,
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff607274),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 60, left: 19),
                child: Text(
                  "Create A Job",
                  style: TextStyle(
                    color: const Color(0xffF2EFE5),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF2EFE5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _jobNameController,
                        decoration: InputDecoration(
                          labelText: "Job Name",
                          labelStyle: TextStyle(
                            color: const Color(0xffB4B4B8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _courseController,
                        decoration: InputDecoration(
                          labelText: "Course Name or ID",
                          labelStyle: TextStyle(
                            color: const Color(0xffB4B4B8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _descriptionController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(
                            color: const Color(0xffB4B4B8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _deadlineController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Add a deadline",
                          labelStyle: TextStyle(
                            color: const Color(0xffB4B4B8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _payController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Payment",
                          labelStyle: TextStyle(
                            color: const Color(0xffB4B4B8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //   height: 50,
                      // ),
                      GestureDetector(
                        onTap: () async => {
                          postJob(),
                          await Future.delayed(const Duration(seconds: 2)),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobWall(),
                            ),
                          )

                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            color: const Color(0xff607274),
                            borderRadius: BorderRadius.circular(40),
                          ),
                         child: Center(
                            child: Text(
                              "Create Job",
                              style: TextStyle(
                                color: const Color(0xffF2EFE5) ,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                            Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => JobWall()),
                        );
                      },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xff607274),
                            borderRadius: BorderRadius.circular(40),
                          ),
                         child: Center(
                            child: Text(
                              "Go To Job Wall",
                              style: TextStyle(
                                color: const Color(0xffF2EFE5) ,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
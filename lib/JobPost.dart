import 'package:flutter/material.dart';

class JobPost extends StatelessWidget{
  final String jobname;
  final String course;
  final String description;
  final String deadline;
  final String pay;
  final String user;
  // final String time;

  const JobPost({
    super.key,
    required this.jobname,
    required this.user,
    required this.course,
    required this.description,
    required this.deadline,
    required this.pay,
  });

  @override
  Widget build(BuildContext context){
    return Row(children: [
      Column(
        children:[
          Text(user),
          Text(jobname),
          Text(course),
          Text(description),
          Text(deadline),
          Text(pay),
        ],
      ),
    ],);
  }
}
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
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffFAEED1), borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),

          //msg and useremail
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(color: const Color(0xff607274)),
              ),
              const SizedBox(height: 10),
              Text(jobname, style: TextStyle(color: const Color(0xff607274)),),
              const SizedBox(height: 10),
              Text(course, style: TextStyle(color: const Color(0xff607274)),),
              const SizedBox(height: 10),
              Text(description, style: TextStyle(color: const Color(0xff607274)),),
              const SizedBox(height: 10),
              Text(deadline, style: TextStyle(color: const Color(0xff607274)),),
              const SizedBox(height: 10),
              Text(pay, style: TextStyle(color: const Color(0xff607274)),),
            ],
          )
        ],
      ),
    );
  }
}


// Row(children: [
//       Column(
//         children:[
//           Text(user),
//           Text(jobname),
//           Text(course),
//           Text(description),
//           Text(deadline),
//           Text(pay),
//         ],
//       ),
//     ],);
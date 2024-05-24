import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard functionality

class JobPost extends StatelessWidget {
  final String jobname;
  final String course;
  final String description;
  final String deadline;
  final String pay;
  final String user;

  const JobPost({
    Key? key,
    required this.jobname,
    required this.user,
    required this.course,
    required this.description,
    required this.deadline,
    required this.pay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFAEED1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user,
                      style: const TextStyle(color: Color(0xff607274)),
                    ),
                    const SizedBox(height: 10),
                    Text(jobname, style: const TextStyle(color: Color(0xff607274))),
                    const SizedBox(height: 10),
                    Text(course, style: const TextStyle(color: Color(0xff607274))),
                    const SizedBox(height: 10),
                    Text(description, style: const TextStyle(color: Color(0xff607274))),
                    const SizedBox(height: 10),
                    Text(deadline, style: const TextStyle(color: Color(0xff607274))),
                    const SizedBox(height: 10),
                    Text(pay, style: const TextStyle(color: Color(0xff607274))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                _copyToClipboard(user);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email copied to clipboard')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}

import 'package:flutter/material.dart';

class WallPost extends StatelessWidget {
  final String message;
  final String User;

  const WallPost({
    super.key,
    required this.message,
    required this.User,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
            padding: EdgeInsets.all(10),
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
                User,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(height: 10),
              Text(message),
            ],
          )
        ],
      ),
    );
  }
}

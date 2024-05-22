import 'package:flutter/material.dart';

class MyTexBox extends StatelessWidget {
  final void Function()? onPrssed;
  final String text;
  final String sectionName;

  const MyTexBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPrssed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 218, 216, 216),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Color.fromARGB(255, 67, 66, 66)),
              ),

              //edit  utton
              IconButton(
                onPressed: onPrssed,
                icon: Icon(Icons.settings),
                color: const Color.fromARGB(255, 72, 69, 69),
              ),
            ],
          ),
          Text(text),
        ],
      ),
    );
  }
}

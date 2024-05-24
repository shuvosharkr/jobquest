import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onTap;

  const UserTile({
    Key? key,
    required this.text,
    this.textColor = Colors.black,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[100], // Changed the background color
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(16), // Reduced padding for a more compact look
        child: Row(
          children: [
            CircleAvatar( // Added a CircleAvatar for the user icon
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
              backgroundColor: Colors.blueGrey[400],
            ),
            const SizedBox(width: 16), // Added some spacing between the icon and text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor, // Used the provided textColor
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

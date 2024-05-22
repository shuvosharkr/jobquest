// ignore_for_file: prefer_const_constructors
//Done
import 'package:flutter/material.dart';
import 'package:jobquest/loginscreen.dart';
import 'package:jobquest/regscreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 241, 241, 246),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, // Set your desired width
              height: 100, // Set your desired height
              child: Image(image: AssetImage('assets/images/job.png')),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 103, 57, 229),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: const Color.fromARGB(255, 103, 57, 229), width: 2),
                ),
                child: Center(
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 103, 57, 229),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegScreen()),
                );
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 103, 57, 229),
                    ),
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

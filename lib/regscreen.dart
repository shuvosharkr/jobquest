// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//Done
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobquest/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _userController = TextEditingController();

  // Firestore reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firestore1 = FirebaseFirestore.instance;

  bool PasswordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmpasswordController.text.trim();
  }

  Future<bool> isUsernameTaken(String username) async {
    final QuerySnapshot result =
        await _usersCollection.where('username', isEqualTo: username).get();
    return result.docs.isNotEmpty;
  }

  Future<void> signUP(BuildContext context) async {
    if (PasswordConfirmed()) {
      // Check if username already exists
      bool usernameTaken = await isUsernameTaken(_userController.text.trim());

      if (usernameTaken) {
        _showErrorDialog(context, "Username is already taken.");
      } else {
        try {
          // Create user in FirebaseAuth
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          //add user data to firestore
          await _usersCollection.doc(userCredential.user!.uid).set({
            'uid': userCredential.user!.uid,
            'username': _userController.text.trim(),
            'email': _emailController.text.trim(),
            'bio': 'Empty Bio', // Default bio value
          });

// _firestore1.collection("Users").doc(userCredential.user!.uid).set(
//   {
//     'uid':userCredential.user!.uid,
//     'email': _emailController,
//   }
// );

          _showErrorDialog(context, "SignUP is Successful. You can SignIn now");
          await Future.delayed(const Duration(seconds: 2));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );

          // // Add user data to Firestore
          // await _usersCollection.add({
          //   'username': _userController.text.trim(),
          //   'email': _emailController.text.trim(),
          //   // Add other user data as needed
          // });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            _showErrorDialog(context,
                "The email address is already in use by another account.");
          } else if (e.code == 'weak-password') {
            _showErrorDialog(context, "Password is too weak.");
          } else {
            _showErrorDialog(context, "Registration failed. Please try again.");
          }
        }
      }
    } else {
      _showErrorDialog(context, "Passwords do not match");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 103, 57, 229),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 60, left: 19),
              child: Text(
                "Create\nYour Account",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
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
                color: Colors.white,
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
                      controller: _userController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        labelText: "Username",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 103, 57, 229),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 103, 57, 229),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 103, 57, 229),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 103, 57, 229),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () => signUP(context),
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 103, 57, 229),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            "REGISTER",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
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
    );
  }
}

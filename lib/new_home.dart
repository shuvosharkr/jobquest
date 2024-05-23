import 'package:flutter/material.dart';
import 'package:jobquest/HomePage.dart';
import 'package:jobquest/drawer.dart';
import 'package:jobquest/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobquest/profile_page.dart';

class NewHome extends StatelessWidget {
  const NewHome({super.key});

  void goToProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Prevent back navigation to the login screen
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("J O B  Q U E S T"),
          backgroundColor: Colors.blueGrey,
        ),
        drawer: MyDrawer(
          onProfileTap: () => goToProfilePage(context),
          onSignoutTap: () => signOut(context),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to Review Wall (HomePage)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text("Review Wall"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Job Wall
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobWall()),
                  );
                },
                child: Text("Job Wall"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobWall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Wall"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text("This is the Job Wall."),
      ),
    );
  }
}

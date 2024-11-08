import 'package:el_realproject/screens/main/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_realproject/screens/auth/login.dart';
import 'package:el_realproject/screens/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

//General initialization fuction
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  //Start the app on based if the user is logged in or not
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? islogin = prefs.getBool('islogin');
  if (islogin == true) {
    runApp(MaterialApp(home: HomeScreen()));
  } else {
    runApp(MaterialApp(home: WelcomeScreen()));
  }
}

//UI
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, //Background colour
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //top image
            Image.asset(
              'assets/img/Logo.png',
              width: 300,
              height: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 0), //This is for spacing
            //When you press sign up you go to the sign up screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
              child: Text('Sign Up'),
            ), //Press login to go to the login screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
